public class PS_OverideOrderNewButton{


  private ApexPages.StandardController controller;
  public String retURL {get; set;}
  public String saveNewURL {get; set;}
  public String rType {get; set;}
  public String cancelURL {get; set;}
  public String ent {get; set;}
  public String confirmationToken {get; set;}
  public String accountID {get; set;}
  public String contactID {get; set;}

public PS_OverideOrderNewButton(ApexPages.StandardController controller) {
    system.debug('$$$$$$$$'+ApexPages.currentPage().getParameters());
    this.controller = controller;
    retURL = ApexPages.currentPage().getParameters().get('retURL');
    rType = ApexPages.currentPage().getParameters().get('RecordType');
    cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
    ent = ApexPages.currentPage().getParameters().get('ent');
    confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
    saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
    accountID = ApexPages.currentPage().getParameters().get('aid');
    contactID = ApexPages.currentPage().getParameters().get('cid');
 
}


public PageReference OverideOrderNewButton()
        {
             try{system.debug('$$$$$$$$'+ApexPages.currentPage().getParameters());
             PageReference returnURL; 
             id persetid = [SELECT Id from permissionset   where Name = 'Pearson_Backend_Order_Creation'].id;   
             List<PermissionSetAssignment> assigneduser =    [SELECT Id, PermissionSetId ,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() and PermissionSetId =:persetid ];
             if(assigneduser.size()>0)
                 {
                          returnURL = new PageReference('/801/e');
                 
                 
            returnURL.getParameters().put('retURL', retURL);
            returnURL.getParameters().put('RecordType', rType);
            returnURL.getParameters().put('cancelURL', cancelURL);
            returnURL.getParameters().put('ent', ent);
            returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
            returnURL.getParameters().put('save_new_url', saveNewURL);
            returnURL.getParameters().put('nooverride', '1');
 
    IF (accountID != null){
 
        returnURL.getParameters().put('aid', accountID);
 
    }
 
    IF (contactID != null){
 
        returnURL.getParameters().put('cid', contactID);
 
        } 
    } 
    else
    {
              returnURL = new PageReference('/apex/PS_InsufficientPrivilegesErrorPage');
    }     
            returnURL.setRedirect(true);
            return returnURL;
         }catch(exception e){system.debug('Error'+e);return null;}
    }    
        

}