@isTest
public class DataFactoryTest {
	//Create data using the data factory
    @TestSetup
    static void makeData(){
        
        List<Account> accts = DataFactory.createAccounts(1);
        insert accts;
        
		Contract ctr = DataFactory.createContract(accts[0]);
		insert ctr;
        
        System.debug('Number of pricebook: '+[select id from Pricebook2 where isStandard=true].size());
        Order order = DataFactory.createOrders(1, accts[0], Test.getStandardPricebookId(),ctr)[0];
        Order order2 = DataFactory.createOrders(1, accts[0], Test.getStandardPricebookId(),ctr)[0];
        insert order;
        insert order2;
        
        Pricebook2 book = DataFactory.createPricebook2(1)[0];
        insert book;
        List<Product2> products = DataFactory.createProduct2(2);
        insert products;
        
        List<PriceBookEntry> bookEntries = DataFactory.createPriceBookEntry(Test.getStandardPricebookId(),products);
        insert bookEntries;
        
        List<OrderItem> orderItems = DataFactory.createOrderItems(order.Id,bookEntries);
        insert orderItems;		
    }
    //check if the right number of data was inserted in the database
    @isTest
    static void testData(){
        
        Test.startTest();
        
        System.debug([SELECT Id FROM Account].size());
        System.AssertEquals(1,[SELECT Id FROM Account].size());        
        System.AssertEquals(2,[SELECT Id FROM Order].size());        
        System.AssertEquals(1,[SELECT Id FROM PriceBook2].size());
        System.AssertEquals(2,[SELECT Id FROM Product2].size());        
        System.AssertEquals(2,[SELECT Id FROM PriceBookEntry].size());
        System.AssertEquals(2,[SELECT Id FROM PriceBookEntry].size());
        
        Test.stopTest();
		
    }
}