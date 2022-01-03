public with sharing class OrderTriggerHelper {
    //RG01 on verifie si l'order est des orderItems si ce n'est pas le cas un message d'erreur à
    //destination de l'utilisateur.
    public static void doesTheOrderGetChild(List<Order> orders,Map<Id,Order> ordersOldMap){
        
		Set<Id> orderIds = ordersOldMap.keySet();
        //Je collecte les orderItems liés aux orders qui ont déclenchés le trigger
        List<OrderItem> orderItemsList = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orderIds];
        orderIds = new Set<Id>();
        
        
        if(orderItemsList.size()>0){
        	for(OrderItem oi:orderItemsList){
            	orderIds.add(oi.OrderId);
        	}            
        }
        
        // Si le statut de l'Order à été modifié à 'Activated' et que la liste ne contient pas l'orderId ``
		// alors une erreur est levée 
        for(Order o:orders){
            if(o.status == 'Activated' && o.status != ordersOldMap.get(o.id).status && !orderIds.contains(o.Id)){
				o.status = 'Draft';
                o.addError('Add product Order before to change the status to Activated');
            }
        }
    }
    //RG02 Je verifie si les comptes qui déclenchent le trigger on des orders 
    //la custom checkbox 'active' devra être coché lorsque le compte à des Orders
    //et décoché en l'absence d'Order
    public static void isTheAccountActive(List<Order> ordersList, boolean isDelete){
    	Set<Id> accountsIds = new Set<Id>();
        Map <Id,Boolean> mapAccountIdxActive = new Map<Id,Boolean>();
        
        //Création d'une Map avec la paire compte, statut du compte. Avec le statut à inactive par défaut
        for(Order o:ordersList){
            accountsIds.add(o.AccountId);
			mapAccountIdxActive.put(o.AccountId,false);            
        }
        // Dans le cas d'un after delete je recolte à nouveau les Orders présent en base
        // sinon j'utilise la liste qui déclenche le trigger afin d'identifier les comptes actifs
        ordersList = isDelete ? [SELECT Id, AccountId FROM Order]:ordersList;
        
        if(ordersList.size() > 0){
            for(Order o:ordersList){
				mapAccountIdxActive.put(o.AccountId,true);
       		}         
        }

        List<Account> accounts = [SELECT Id, Active__c FROM Account WHERE Id IN :accountsIds];
        
        //utilisation de la map afin de mettre à jour des comptes avec le statut approprié 
        for(Account acct:accounts){
            acct.active__c = mapAccountIdxActive.get(acct.Id);
        }
        
        update accounts;

    }
}