trigger OrderTrigger on Order (Before Update,After Insert, After Delete){
    
	if(Trigger.isBefore && Trigger.isUpdate){
		OrderTriggerHelper.doesTheOrderGetChild(Trigger.New,Trigger.oldMap);
    }
    if(Trigger.IsInsert && Trigger.isAfter){
        OrderTriggerHelper.isTheAccountActive(Trigger.New, false);
    }
    if(Trigger.isDelete && Trigger.isAfter){
        OrderTriggerHelper.isTheAccountActive(Trigger.Old, true);
    }	
}