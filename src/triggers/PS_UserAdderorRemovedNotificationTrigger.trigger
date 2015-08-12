/* Trigger fires when any user is assigned to a Territory or removed from a Territory
 Author: IDC Accenture 
 Date: 1st June' 15 
 Handler for this Trigger is PS_USerAdderorRemovedNotificationHandler 
 */

trigger PS_UserAdderorRemovedNotificationTrigger on UserTerritory2Association (before insert,after delete) {
    PS_UserAdderorRemovedNotificationHandler handler = new PS_UserAdderorRemovedNotificationHandler ();
   // Insert Triggers
    if(trigger.isInsert){
        PS_UserAdderorRemovedNotificationHandler.isAdded = true;
        handler.userNotification(trigger.new);
    }
    // Delete Triggers
    if(trigger.IsDelete){
        PS_UserAdderorRemovedNotificationHandler.isAdded = false;
        handler.userNotification(trigger.old);
    }
}