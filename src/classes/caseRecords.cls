Public class caseRecords{
 Public Id AccountId1;
 public String caseId{get; set;}
  public caseRecords(Apexpages.standardcontroller controller){
   AccountId1= ApexPages.currentPage().getParameters().get('id');
  }
  public List<case> getcaselist(){
  List<case> caselist = [select id,CaseNumber from case where Type=:'Account Update' and AccountId=:Accountid1];
   return caselist;
  }
  
  public pageReference caseEdit(){
        PageReference casepage = new PageReference('/'+caseId+'/e?retURL=%2F'+caseId);
        return casepage;    
    }
}