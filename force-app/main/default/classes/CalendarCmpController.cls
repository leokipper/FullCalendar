/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* CalendarCmpController.cls
*
* Controller for CalendarCmp.cmp
* Returns Event data based on Contact Id
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Leonardo Kipper   <leonardo_kipper@hotmail.com>
* @version        1.0
* @created        2020-03-24
* ──────────────────────────────────────────────────────────────────────────────────────────────────
*/
public without sharing class CalendarCmpController {
    
    @AuraEnabled
    public static List<EventWrapper> getEvents() {
        List<EventWrapper> lstEventWrapper = new List<EventWrapper>();
        List<Event> lstEvent = new List<Event>();
        List<Task> lstTask = new List<Task>();
        
        lstEvent = [SELECT Id, Description, EndDateTime, ActivityDateTime, Subject,
                WhatId, What.Name, WhoId, Who.Name, RecordType.Name 
                FROM Event];
        
        if(!lstEvent.isEmpty()){
            for(Event lEvent : lstEvent){
                EventWrapper lEventWrapper = new EventWrapper();
                lEventWrapper.id = lEvent.Id;
                lEventWrapper.start = lEvent.ActivityDateTime;
                lEventWrapper.finish = lEvent.EndDateTime;
                lEventWrapper.title = lEvent.RecordType.Name;
                if(String.isNotBlank(lEvent.WhatId))
                    lEventWrapper.title += ' -- ' + lEvent.What.Name;
                if(String.isNotBlank(lEvent.WhoId))
                    lEventWrapper.title += ' -- ' + lEvent.Who.Name;
    
                if(lEvent.RecordType.Name.equals('Entrevista'))
                    lEventWrapper.backgroundColor = 'green';
                else if(lEvent.RecordType.Name.equals('Qualificação'))
                    lEventWrapper.backgroundColor = 'blue';
                else if(lEvent.RecordType.Name.equals('Reunião'))
                    lEventWrapper.backgroundColor = 'rgb(188, 71, 252)';
                else
                    lEventWrapper.backgroundColor = 'orange';
                
                lstEventWrapper.add(lEventWrapper); 
            }
        }

        lstTask = [SELECT Id, ActivityDate, Description, RecordType.Name, Subject, Status, WhatId, WhoId,
        What.Name, Who.Name 
                FROM Task];

        if(!lstTask.isEmpty()){
            for(Task lTask : lstTask){
                EventWrapper lEventWrapper = new EventWrapper();
                lEventWrapper.id = lTask.Id;
                lEventWrapper.start = lTask.ActivityDate;
                lEventWrapper.finish = lTask.ActivityDate;
                lEventWrapper.title = lTask.Subject;
                lEventWrapper.title = lTask.RecordType.Name;
                if(String.isNotBlank(lTask.WhatId))
                    lEventWrapper.title += ' -- ' + lTask.What.Name;
                if(String.isNotBlank(lTask.WhoId))
                    lEventWrapper.title += ' -- ' + lTask.Who.Name;
    
                if(lTask.RecordType.Name.equals('Interview'))
                    lEventWrapper.backgroundColor = 'green';
                else if(lTask.RecordType.Name.equals('Qualification Interview'))
                    lEventWrapper.backgroundColor = 'blue';
                else if(lTask.RecordType.Name.equals('Meeting'))
                    lEventWrapper.backgroundColor = 'rgb(188, 71, 252)';
                else
                    lEventWrapper.backgroundColor = 'orange';
                
                lstEventWrapper.add(lEventWrapper); 
            }
        }
        return lstEventWrapper;
    }

    @AuraEnabled
    public static List<CustomSelectOptions> getEventOptions(){
		List<CustomSelectOptions> lstEventOptons = new List<CustomSelectOptions>();
        
        for(RecordType rec : [SELECT Id, Name, DeveloperName, Description FROM RecordType 
                            WHERE SobjectType = 'Task' AND IsActive = true]) {
            CustomSelectOptions lOption = new CustomSelectOptions();
			lOption.label = rec.Name; 
			lOption.value = rec.Id;

			lstEventOptons.add(lOption);
		}
		return lstEventOptons;
    }

	public class CustomSelectOptions{
		@AuraEnabled public String label {get;set;}
		@AuraEnabled public String value {get;set;}
		  
		public CustomSelectOptions() {
			this.label = '';
			this.value = '';
		}
	
		public CustomSelectOptions(String lab, String val) {
			this.label = lab;
			this.value = val;
		}
	}

    class EventWrapper{
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public DateTime start {get; set;}
        @AuraEnabled public DateTime finish {get; set;}
        @AuraEnabled public String title {get; set;}
        @AuraEnabled public String backgroundColor {get; set;}
    }
}