/*************************************************************
@Author     : Accenture IDC
@Description: Trigger to create a new event on opportunity
@Date       : 23/03/2015
**************************************************************/
trigger createNewEventOnOpportunity on Event (after insert,before update) {
createNewEventOnOpportunity newEvent = new createNewEventOnOpportunity();
newEvent.createNewEvent(Trigger.New); 
}