public with sharing class OrderTriggerHelper {
    //1
    public static void doesTheOrderGetChild(List<Order> orders,Map<Id,Order> ordersOldMap){
        
		Set<Id> orderIds = ordersOldMap.keySet();       
        List<OrderItem> orderItemsList = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orderIds];
        Set<Id> orderItemsOrderIds = new Set<Id>();
        
        if(orderItemsList.size()>0){
        	for(OrderItem oi:orderItemsList){
            	orderItemsOrderIds.add(oi.OrderId);
        	}            
        }
               
        for(Order o:orders){
            if(o.status == 'Activated' && o.status != ordersOldMap.get(o.id).status && !orderItemsOrderIds.contains(o.Id)){
				o.status = 'Draft';
                o.addError('Add product Order before to change the status to Activated');
            }
        }
    }
    //2
    public static void isTheAccountActive(List<Order> ordersList, boolean isDelete){
    	Set<Id> accountsIds = new Set<Id>();
        Map <Id,Boolean> mapAccountIdxActive = new Map<Id,Boolean>();
        
        for(Order o:ordersList){
            accountsIds.add(o.AccountId);
			mapAccountIdxActive.put(o.AccountId,false);            
        }
        
        ordersList = isDelete ? [SELECT Id, AccountId FROM Order]:ordersList;
        
        if(ordersList.size() > 0){
            for(Order o:ordersList){
				mapAccountIdxActive.put(o.AccountId,true);
       		}         
        }

        List<Account> accounts = [SELECT Id, Active__c FROM Account WHERE Id IN :accountsIds];
        
        for(Account acct:accounts){
            acct.active__c = mapAccountIdxActive.get(acct.Id);
        }
        
        update accounts;

    }
}