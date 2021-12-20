public class AccountTaskBatch implements  Database.Batchable<SObject>{
/*
    public void execute(SchedulableContext sc){
        Database.executeBatch(this,1);
    }
*/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id '+
                                        'FROM Account '+
                                        'WHERE Active__c = false');
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        
        if(scope.size()>0){
            System.debug('scope need task');
       		AccountBatchHelper.doesTheAccountNeedATask(scope);            
        }

    }
    
    public void finish(Database.BatchableContext bc){

    }    
    

}