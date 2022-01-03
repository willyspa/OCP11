@isTest
public class AccountTaskBatchTest {
    
    //Créer des enregistrements avec la data factory
    @TestSetup
    private static void makeData(){
        
        List<Account> accts = DataFactory.createAccounts(300);
		insert accts;       
    } 
    //Cette méthode verifie que les tâches sont créées lorsque un compte n'a pas d'order
	@isTest
    private static void areTaskCreated(){
        
        Test.startTest();
        
        Database.executeBatch(new AccountTaskBatch(),300);
                   
        Test.stopTest();
        
        Date past = System.now().date()+4;
        Date future = System.now().date()+6;
        
        Integer numberOftasks = [SELECT Id FROM Task WHERE Subject = 'Call' AND 
                                 						   Status='New' AND 
                                 						   Priority='Normal' AND 
                                 					   	   IsReminderSet = true AND 
                                 						   ReminderDateTime > :past AND 
                                 						   ReminderDateTime < :future].size();

        System.assertEquals(300,numberOftasks);        
    }
}