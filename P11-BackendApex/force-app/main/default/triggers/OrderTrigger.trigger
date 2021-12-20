trigger OrderTrigger on Order (Before Update,After Insert, After Delete){
    
	if(Trigger.isBefore && Trigger.isUpdate){
		OrderTriggerHelper.doesTheOrderGetChild(Trigger.New,Trigger.oldMap);
    }
    if(Trigger.IsInsert){
        System.debug('*TR_isInsert******************');
        OrderTriggerHelper.isTheAccountActive(Trigger.New, false);
    }
    if(Trigger.isDelete && Trigger.isAfter){
        System.debug('TR_isDelete*******************');
        OrderTriggerHelper.isTheAccountActive(Trigger.Old, true);
    }	
}