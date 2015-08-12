/*************************************************************
@Author     : Accenture - Davi Borges 
@Description: Controller to 'OneCRMSampleProductSelection' component controller
@Date       : 22/06/2015
**************************************************************/
public class OneCRMSampleProductSelectionController {
    
    //Propertie that holds all sample selected products
    public list < displayproductlineitem > productsToSample 
    {
        get
        {
            emptyproduct = ! (productsToSample !=null && productsToSample.size() > 0);

            return productsToSample;  
        }
        set;
             //wrapper class to display and for the selction the productlineitem 
    }
    public boolean emptyproduct {
        get{
            System.debug('@@@emptyproduct:' + emptyproduct);
            return emptyproduct;
        }
        set;
    }
    
         //wrapper class to display and for the selction the productlineitem 
    public class displayproductlineitem {
        public boolean selected {
            get;
            set;
        }
        //public Apttus_Config2__RelatedProduct__c familymember {
        public Product2 product {
            get;
            set;
        }
        /*public list < Apttus_Config2__RelatedProduct__c > digitalproductfamily {
            get;
            set;
        }*/

        public String restriction {
            get;
            set;
        }

        public displayproductlineitem(Apttus_Config2__RelatedProduct__c temp) {       
            this(temp.Apttus_Config2__RelatedProductId__r);
        }

        public displayproductlineitem(Product2 disProduct)
        {
            selected = false;
            product = disProduct;
            restriction = disProduct.Sampling_Restriction__c ;
        }

    }
   
}