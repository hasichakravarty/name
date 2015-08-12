// Project: Convert Assets from Product Info.
// Created by: Comity Designs [Developer: Rashi Girdhar]
// Class: AssetWrapper.cls     
// Description: Wrapper class for the Asset Object used by ProductsToAssets.cls 
// Other Package Classes: ProductsToAssets.cls
// VisualForce Page: ProductsToAssets.page
// Date: 8/3/2009

/**
 ** Class: AssetWrapper
**/
public with sharing class AssetWrapper {
    //Variables
    private Boolean isAssetSelected = false;
    private Asset asset;
    private String oliID;
    
    /**
    ** Constructor
    **/ 
    public AssetWrapper(Asset a, String id) {
        this.setAsset(a);   
        this.oliID=id;
    }
    
    //Getters
    public Asset getAsset(){
        return this.asset;
    }           
    
    public Boolean getIsAssetSelected(){
        return this.isAssetSelected;
    }
    
    public String getOliID() {
        return this.oliID;
    }
    
    //Setters
    public void setIsAssetSelected(Boolean value){
        this.isAssetSelected = value;
    }
    
    private void setAsset(Asset a){
        this.asset=a;
    }
}