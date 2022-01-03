@isTest
private class OrderTriggerTest {
    
    //Create data using the data factory
    @TestSetup
    private static void makeData(){
        
        List<Account> accts = DataFactory.createAccounts(2);
        insert accts;
        
		Contract ctr = DataFactory.createContract(accts[0]);
		insert ctr;
        
        List<Order> orders = DataFactory.createOrders(300, accts[0], Test.getStandardPricebookId(),ctr);
        insert orders;

        Pricebook2 book = DataFactory.createPricebook2(1)[0];
        insert book;
        
        List<Product2> products = DataFactory.createProduct2(2);
        insert products;
        
        List<PriceBookEntry> bookEntries = DataFactory.createPriceBookEntry(Test.getStandardPricebookId(),products);
        insert bookEntries;
        
        List<OrderItem> orderItems = new List<OrderItem>();
        List<Order> orderWithItems = new List<Order>();
        List<Order> orderWithoutItems = new List<Order>();
        
        for(Integer i = 0;i<150;i++){
            orderItems.addAll(DataFactory.createOrderItems(orders[i].Id,bookEntries));
            orderWithItems.add(orders[i]);
        } 
        
        insert orderItems;		        
    }
    
    //Create data using the data factory
    
    @isTest
    private static void checkIfTheAccountIsActiveOnCreate(){
        
        Test.startTest();        
        
        List<Account> acctsActive = [SELECT Id, Active__c FROM Account WHERE Active__c = true];
        
		Test.stopTest(); 
        
       	System.assertEquals(1, acctsActive.size());

        				       
    }
    @isTest    
	private static void checkIfTheAccountIsActiveOnDelete(){
            
        Test.startTest();        
        
		delete [SELECT Id FROM Order];
        List<Account> acctsNotActive = [SELECT Id, Active__c FROM Account WHERE Active__c = false];
        
		Test.stopTest(); 
        
        System.assertEquals(2, acctsNotActive.size());
        				       
    }
      
	
    @isTest
    private static void isTheOrderValid(){
				        
        Test.startTest();
        
        Set<Id> OrderWithItemIds = new Set<Id>();
        Set<Id> OrderWithtoutItemIds = new Set<Id>();       
        List<OrderItem> orderItems = [SELECT OrderId FROM OrderItem WHERE OrderId != null];
                
        for(OrderItem orderItem:orderItems){
            OrderWithItemIds.add(orderItem.OrderId);
        }
		List<Order> orderWithoutItem = [SELECT Id,status FROM Order WHERE Id NOT IN :OrderWithItemIds];
        List<Order> orderWithItem = [SELECT Id,status FROM Order WHERE Id IN :OrderWithItemIds];
        
        for(Order o:orderWithoutItem){
            o.status = 'Activated';
        }try{
        	update orderWithoutItem;
        }catch(Exception e){}
       
        Boolean isActivated = true;
        Boolean isNotActivated = true;
        
		orderWithoutItem = [SELECT Id,status FROM Order WHERE Id NOT IN :OrderWithItemIds];    
        
        for(Order o:orderWithoutItem){
            if('Activated'.EqualsIgnoreCase(o.status)){
                isNotActivated = false;
            }
        }
        
        orderWithItem = [SELECT Id,status FROM Order WHERE Id IN :OrderWithItemIds];
        
       	for(Order o:orderWithItem){
            o.status = 'Activated';
        }try{
        	update orderWithItem;
        }catch(Exception e){}
                
        for(Order o:orderWithItem){
            if('Draft'.EqualsIgnoreCase(o.status)){
                isActivated = false;
            }
        }
                    
        Test.stopTest();
        
        System.assertEquals(true,isNotActivated);
        System.assertEquals(true,isActivated);
        
        //System.assertEquals('Activated', orders[0].Status);
        //System.assertEquals('Draft', orders[1].Status);        
    }
    
    
        @isTest
    private static void errorOnUpdate(){
		
        Exception exceptionOnUpdate;
        
        Test.startTest();
        
        	try{
				List<Contract> contracts = new List<Contract>();             
				List<Order> orders = new List<Order>();
                
       			orders = [SELECT Id, Status FROM Order];
                contracts = [SELECT Id,status FROM Contract];
                delete [SELECT Id FROM OrderItem];
                
                for(contract c:contracts){
                   c.status = 'activated';
                }
                System.debug(contracts.size());
                update contracts;
                    
                for(Order o:orders){
                	orders[0].Status = 'Activated';
                }
				      
       			update orders; 
            
        }catch(System.Exception e){
            
            	exceptionOnUpdate = e;
            	System.debug(e.getMessage());           	           
        }

        Test.stopTest();
        
        String error = 'Add product Order before to change the status to Activated';
		System.assert(exceptionOnUpdate.getMessage().contains(error));       
    }

}