/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description:	This class is extended by the visualforce page controller of any page that holds multiple
 *				custom components of the same type
 *
 *See http://wiki.developerforce.com/page/Controller_Component_Communication for explanations...
 */
 
public with sharing virtual class PageControllerBase{
	
	private ComponentControllerBase ComponentController;
	private Map<String, ComponentControllerBase> ComponentControllerMap;
	

	public virtual ComponentControllerBase getComponentController(){
		return ComponentController;
	}

	public PageControllerBase getThis() {
		return this;
	}

	public virtual Map<String, ComponentControllerBase> getComponentControllerMap(){
		return componentControllerMap;
	}
	
	public virtual void setComponentControllerMap(String key, ComponentControllerBase compController){
		if(componentControllerMap == null){
			componentControllerMap = new Map<String, ComponentControllerBase>();
		}
		
		componentControllerMap.put(key,compController);
	}
	
	public virtual void setComponentController(ComponentControllerBase compController){
		ComponentController = compController;
	}

}