({
    renderCalendar : function (component, event, calendarEvent){
        var calendarEl = component.find('calendar').getElement();
        var calendar = new FullCalendar.Calendar(calendarEl, {
            plugins: ['dayGrid', 'interaction', 'timeGrid', 'list'],
            // eventLimit: false, // allow "more" link when too many events
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridDay,dayGridWeek,dayGridMonth timeGridWeek listWeek'
            },
    
            //// uncomment this line to hide the all-day slot
            //allDaySlot: false,
            events: calendarEvent,

            eventClick: function(info) {
                var eventObj = info.event;
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": eventObj.id
                });
                editRecordEvent.fire();
            },
            
            dateClick: function (info) {
                $A.util.addClass(component.find('modal'), 'slds-fade-in-open');
                component.set('v.selectedDate', info.date);
                //this should me improved, popup is not overriding Calendar whitout this call
                // is not working correctly on Microsoft Edge browser
                this.helperMethod(component, event, helper);
            }
        });
        calendar.render();
    },

    helperMethod : function(component, event, helper) {}
})