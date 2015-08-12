Public class createTask{
 public static boolean var = false;
 
List<Task>task1 = new List<Task>();
 public void createTaskOnLead(Id accontid ){
if(!var)
            
            {Task tk = new task(Subject='Add Sponsor to Opportunity',Description = 'The students sponsor already exists in OneCRM. Action required: Search for the sponsor [ insert: Sponsor Name ] and manually add them to the opportunity'
             ,Priority= 'High',ActivityDate= System.today(),WhatId=accontid);
             Task1.add(tk);
             var =true;
             
insert task1;             
  }
 

}
}