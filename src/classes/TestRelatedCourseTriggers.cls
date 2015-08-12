@isTest
private class TestRelatedCourseTriggers
{
    static testMethod void myUnitTest()
    {
        
        TestClassAutomation.FillAllFields = true;
        
        Account sAccount                = (Account)TestClassAutomation.createSObject('Account');
        sAccount.BillingCountry         = 'Australia';
        sAccount.BillingState           = 'Victoria';
        sAccount.BillingCountryCode     = 'AU';
        sAccount.BillingStateCode       = 'VIC';
        sAccount.ShippingCountry        = 'Australia';
        sAccount.ShippingState          = 'Victoria';
        sAccount.ShippingCountryCode    = 'AU';
        sAccount.ShippingStateCode      = 'VIC';
        
        insert sAccount;
        
        /* UniversityCourse__c sUniversityCourse  = (UniversityCourse__c)TestClassAutomation.createSObject('UniversityCourse__c');
        sUniversityCourse.Account__c  = sAccount.Id;
        insert sUniversityCourse;
        
        UniversityCourse__c sUniversityCourse2   = (UniversityCourse__c)TestClassAutomation.createSObject('UniversityCourse__c');
        sUniversityCourse2.ImportID__c  = 'ubywqruqwe8912';
        sUniversityCourse2.UniversityCourseAccountComboStrId__c  = null;
        sUniversityCourse2.Account__c  = sAccount.Id; 
        insert sUniversityCourse2; */
        
          List<UniversityCourse__c> courselist=new List<UniversityCourse__c>();
      for(integer i=0;i<3;i++){
          UniversityCourse__c course = new UniversityCourse__c();
          course.Name = 'TerritoryCourseNameandcode'+i;
          course.Account__c = sAccount.id;
          course.Catalog_Code__c = 'Territorycoursecode'+i;
          course.Course_Name__c = 'Territorycoursename'+i;
          course.CurrencyIsoCode = 'USD';
          courselist.add(course);
      }

      insert courselist;
        
        Test.startTest();
        
            RelatedCourse__c     sRelatedCourse     = (RelatedCourse__c)TestClassAutomation.createSObject('RelatedCourse__c');
            sRelatedCourse.Course__c                = courselist[0].Id;
            sRelatedCourse.Related_Course__c        = courselist[1].Id;
            sRelatedCourse.RelationshipClone__c     = null;
            
            insert sRelatedCourse;
            
            sRelatedCourse.Type__c  = 'Other';
            
            // update sRelatedCourse;
            
            delete sRelatedCourse;
            
            undelete sRelatedCourse;
        
        Test.stopTest();
    }
}