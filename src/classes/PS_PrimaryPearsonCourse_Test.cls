@isTest(SeeAllData = true)
private class PS_PrimaryPearsonCourse_Test
{
    static testMethod void myUnitTest()
    {
     Boolean b = Boolean.valueOf('true');
     PS_PrimaryPearsonCourse ppc = new PS_PrimaryPearsonCourse ();   
     List<Pearson_Course_Equivalent__c> newlist= new List<Pearson_Course_Equivalent__c>();
     List<Pearson_Course_Equivalent__c> oldlist= new List<Pearson_Course_Equivalent__c>();
     map<id,Pearson_Course_Equivalent__c> oldmap = new map<id,Pearson_Course_Equivalent__c> ();
     //query to get the profile of sales user OneCRM
     Profile pfile = [Select Id,name from profile where name = 'Pearson Sales User OneCRM'];
     
      //code for creating an User
      User u = new User();
      u.LastName = 'primarycourseuser';
      u.alias = 'pmryusr'; 
      u.Email = 'primarycourse@gmail.com';  
      u.Username='primarycourse@gmail.com';
      u.LanguageLocaleKey='en_US'; 
      u.TimeZoneSidKey='America/New_York';
      u.Price_List__c='US HE All';
      u.LocaleSidKey='en_US';
      u.EmailEncodingKey='ISO-8859-1';
      u.ProfileId = pfile.id;       // '00eg0000000M99E';    currently hardcoded  for admin         
      u.Geography__c = 'Growth';
      u.Market__c = 'ZA';
      u.Line_of_Business__c = 'Higher Ed';
      insert u;
      
    
    System.runAs(u){
    
      //code written for creating an account.
     
     
     //query to get the Recordtype of the Account
     RecordType accrdtype = [Select Id,name from RecordType where name = 'Organisation'];
      Account Acc = new Account();
          Acc.Name = 'primarycourseAccount';
          Acc.Phone = '+910000055';
          Acc.ShippingCountry = 'India';
          Acc.ShippingCity = 'Bangalore';
          Acc.ShippingStreet = 'BNGECO';
          Acc.ShippingPostalCode = '5600374';
          Acc.RecordTypeId = accrdtype.id;     //'012g00000004tzM';  //currently hardcoded 
          Acc.Territory_Code_s__c = '2ZZ';   
          insert Acc;           
       
       
      //code for creating course
      UniversityCourse__c course = new UniversityCourse__c();
          course.Name = 'PrimaryCourseNameandcode';
          course.Account__c = Acc.id;
          course.Catalog_Code__c = 'Primarycoursecode';
          course.Course_Name__c = 'Primarycoursename';
          course.CurrencyIsoCode = 'USD';
          insert course;
          
      UniversityCourse__c course1 = new UniversityCourse__c();
          course1.Name = 'PrimaryCourseNameandcode1';
          course1.Account__c = Acc.id;
          course1.Catalog_Code__c = 'Primarycoursecode1';
          course1.Course_Name__c = 'Primarycoursename1';
          course1.CurrencyIsoCode = 'USD';
          insert course1;
      
      UniversityCourse__c course2 = new UniversityCourse__c();
          course2.Name = 'PrimaryCourseNameandcode2';
          course2.Account__c = Acc.id;
          course2.Catalog_Code__c = 'Primarycoursecode2';
          course2.Course_Name__c = 'Primarycoursename2';
          course2.CurrencyIsoCode = 'USD';
          insert course2;
          
           //code for creating the Hirarchy
        Apttus_Config2__ClassificationName__c cn = new Apttus_Config2__ClassificationName__c();
      cn.Apttus_Config2__HierarchyLabel__c = 'TestcategoryName';
      cn.Apttus_Config2__Type__c = 'Offering';
      cn.Apttus_Config2__Active__c = true;
      cn.Market__c = 'US';
      cn.Name = 'TestcategoryName';
      insert cn; 
           
            //code for inserting Category Hierarchy 
      Apttus_Config2__ClassificationHierarchy__c categoryhierarchy = new Apttus_Config2__ClassificationHierarchy__c();
      categoryhierarchy.Apttus_Config2__HierarchyId__c = cn.id;  //'a1cg00000003ePw';
      categoryhierarchy.Apttus_Config2__Label__c = 'TestCategoryHierarchy';
      categoryhierarchy.Name = 'TestCategoryHierarchy';
      insert categoryhierarchy; 
      
      Test.startTest();
      //code for mapping Pearson Course with the category Hirarchy
     /*  Pearson_Course_Equivalent__c pce = new Pearson_Course_Equivalent__c();
          pce.Active__c = true;   
          pce.Course__c = course.id;
          pce.Primary__c = True;
          pce.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKD'; 
          Insert pce;   
      
      Pearson_Course_Equivalent__c pce1 = new Pearson_Course_Equivalent__c();
          pce1.Active__c = true;   
          pce1.Course__c = course1.id;
          pce1.Primary__c = false;
          pce1.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKN'; 
          Insert pce1;
          pce1.Primary__c = true;
          update pce1;
       
      Pearson_Course_Equivalent__c pce2 = new Pearson_Course_Equivalent__c();
          pce2.Active__c = true;   
          pce2.Course__c = course2.id;
          pce2.Primary__c = True;
          pce2.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKN'; 
          Insert pce2;
          update pce2;            
       //PS_PrimaryPearsonCourse ppc = new PS_PrimaryPearsonCourse();
       
       Pearson_Course_Equivalent__c pce3 = new Pearson_Course_Equivalent__c();
          pce3.Active__c = true;   
          pce3.Course__c = course1.id;
          pce3.Primary__c = True;
          pce3.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKN'; 
          Insert pce3;
          pce3.Primary__c = true;
          update pce3; 
          */
          
           
     
           Pearson_Course_Equivalent__c pce4 = new Pearson_Course_Equivalent__c();
          pce4.Active__c = true;   
          pce4.Course__c = course.id;
          pce4.Primary__c = True;
          pce4.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKD'; 
         // Insert pce4;
          newlist.add(pce4);
          
           Pearson_Course_Equivalent__c pce5 = new Pearson_Course_Equivalent__c();
          pce5.Active__c = true;   
          pce5.Course__c = course.id;
          pce5.Primary__c = True;
          pce5.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKD'; 
        //  Insert pce5;
          newlist.add(pce5);
           system.debug('newlist--> afterinsert'+newlist);
          insert newlist;
          
           Pearson_Course_Equivalent__c pce6 = new Pearson_Course_Equivalent__c();
          pce6.Active__c = true;   
          pce6.Course__c = course.id;
          pce6.Primary__c = false;
          pce6.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKD'; 
         // Insert pce6;
          oldlist.add(pce6);
          
           Pearson_Course_Equivalent__c pce7 = new Pearson_Course_Equivalent__c();
          pce7.Active__c = true;   
          pce7.Course__c = course.id;
          pce7.Primary__c = false;
          pce7.Pearson_Course_Code__c = categoryhierarchy.id; //'a1bg00000003RKD'; 
         // Insert pce7;
          system.debug('oldlist before insert-->'+oldlist);
          oldlist.add(pce7);
          insert oldlist;
          for(Pearson_Course_Equivalent__c pce9 :newlist)
          for(Pearson_Course_Equivalent__c pce8 :oldlist)
          oldmap.put(pce9.id ,pce8);
          system.debug('oldlist-->'+oldlist+ 'boolean-->' +b);
           system.debug('newlist-->'+newlist);
          ppc.updatePrimaryFlag(newlist,oldmap,b,b);
          
          
        Test.stopTest(); 
        
        }// run as close
    }
    
}