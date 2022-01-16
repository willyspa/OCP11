public class AccountBatchHelper {
    
    public static void doesTheAccountNeedATask(List<Account> listAccount){
        
        System.debug('batch executed');
        Set<Id> accountsIds = new Set<Id>();
        Set<Id> accountsIdsWithTask = new Set<Id>();
        Set<Id> accountsIdsWithoutTask = new Set<Id>();
        
        for(Account acct:listAccount){
            accountsIds.add(acct.Id);
        }
        //Je verifie si des tâches sont présentes sur les comptes 
        //Si ce n'est pas le cas creation d'une liste de compte sans tâches 'accountsIdsWithoutTask'
        List<Task> listTasks = [SELECT Id,AccountId FROM Task WHERE AccountId IN :accountsIds];

        if(listTasks.size() > 0){
            for(Task t:listTasks){
                accountsIdsWithTask.add(t.AccountId);
            }
        }
		System.debug('accountsIdsWithTask:'+accountsIdsWithTask);	       
        accountsIdsWithoutTask = accountsIds;
        accountsIdsWithoutTask.removeAll(accountsIdsWithTask);
        
        listTasks.clear();
        
        //Création des tâches associés aux compte adéquates
        if(accountsIdsWithoutTask.size() > 0){
            for(Id AcctId:accountsIdsWithoutTask){
            	listTasks.add(New Task(WhatId=AcctId, 
                                       Subject='Call',
                                       Status='New',
                                       Priority='Normal',
                                       IsReminderSet = true, 
                                       ReminderDateTime = System.now()+5, 
                                       ActivityDate = (System.now()+5).date()));
        	}          
        } 

		insert listTasks;        
    }
}


/*
Détails de la tâche à créer :
- Sujet : « Call »
- Statut : « Nouvelle »
- Priorité : « Normale »
- Rappel automatique dans 5 jours
*/