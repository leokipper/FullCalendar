/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* CalendarCmpControllerTest.cls
*
* Test class for CalendarCmpController.cls
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Leonardo Kipper   <leonardo_kipper@hotmail.com>
* @version        1.0
* @created        2020-03-26
* ──────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public with sharing class CalendarCmpControllerTest {
    @IsTest
    static void testEvents(){
        Integer insertedRecords = 0;
        Account lAccount = new Account(Name = 'Test Account');
        insert lAccount;

        Contact lContact = new Contact(
           LastName = 'LastName',
           AccountId = lAccount.Id
        );
        insert lContact;

        List<Event> lstEvent = new List<Event>();
        for(RecordType rec : [SELECT Id FROM RecordType 
                            WHERE SobjectType = 'Event' AND IsActive = true]) {

            Event lEvent = new Event(
                RecordTypeId = rec.Id,
                Description = 'This is a Test',
                ActivityDateTime = System.now(),
                EndDateTime = System.now(),
                WhatId = lAccount.Id,
                WhoId = lContact.Id);
            lstEvent.add(lEvent);
        }
        if(!lstEvent.isEmpty()){
            insert lstEvent;
            insertedRecords += lstEvent.size();
        }

        List<Task> lstTask = new List<Task>();
        for(RecordType rec : [SELECT Id FROM RecordType 
                            WHERE SobjectType = 'Task' AND IsActive = true]) {
            Task lTask = new Task(
                RecordTypeId = rec.Id,
                ActivityDate = System.today(),
                Description = 'This is a test',
                WhatId = lAccount.Id,
                WhoId = lContact.Id);
            lstTask.add(lTask);
        }
        if(!lstTask.isEmpty()){
            insert lstTask;
            insertedRecords += lstTask.size();
        }
        
        Test.startTest();
            CalendarCmpController.CustomSelectOptions lOptions = new CalendarCmpController.CustomSelectOptions('Key', 'Value');
            System.assertEquals(insertedRecords, CalendarCmpController.getEvents(lContact.Id).size());
            CalendarCmpController.getEventOptions();
        Test.stopTest();   
   }
}