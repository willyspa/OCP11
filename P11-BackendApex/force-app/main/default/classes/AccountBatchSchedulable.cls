public class AccountBatchSchedulable implements Schedulable {

    public void execute(SchedulableContext sc){
        
        Database.executeBatch(new AccountTaskBatch(),200);
    }
}