({
    afterScriptsLoaded : function(component, event, helper) {
        var calendarEvent = [];
        var results = [];
        var action = component.get("c.getEvents");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                results = response.getReturnValue();
                for(var i= 0; i < results.length; i++){
                    var element = results[i];
               
                    var item = { 
                        id : element.id,
                        start : element.start, 
                        end : element.finish,
                        title : element.title,
                        editable: true,
                        backgroundColor: element.backgroundColor
                    };
                    calendarEvent.push(item);
                };
                $A.enqueueAction(component.get('c.loadEventOptions'));
                helper.renderCalendar(component, event, calendarEvent);
            }
        });
       $A.enqueueAction(action);
    },

    loadEventOptions : function (component, event, helper){
        var action = component.get("c.getEventOptions");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.eventTypes', response.getReturnValue());
                component.set('v.selectedEventType', component.get('v.eventTypes')[0].value);
            }
            else{}
        });
        $A.enqueueAction(action); 
    },

    closeModal : function(component, event) {
        var modal = component.find('modal');
        $A.util.removeClass(modal, 'slds-fade-in-open');
    },

    createEvent : function(component, event, helper){
        var selectedEventRecordTypeId = component.get('v.selectedEventType');
        var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                // "entityApiName": "Event",
                "entityApiName": "Task",
               'recordTypeId' : selectedEventRecordTypeId,
               'defaultFieldValues': {
                    'ActivityDate': component.get("v.selectedDate")
                    // 'StartDateTime': component.get("v.selectedDate"),
                    // 'EndDateTime': component.get("v.selectedDate")
            }
        });
        createRecordEvent.fire();
    }
})