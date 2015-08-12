/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description:	This class is extended by the controller of any component that is used more than once on
 *				a single visualforce page 
 *
 *See http://wiki.developerforce.com/page/Controller_Component_Communication for explanations...
 */
 
public with sharing virtual class ComponentControllerBase {
	
	//The key is used to identify each custom component on a page 	
	public string key { 
		get;
		set{
			if(value != null){
				Key = value;
				
				if(pageController != null){
					pageController.setComponentControllerMap(Key, this);
				}
			}
		}
	}


	//The pageController of the page on which this component sits
	public PageControllerBase pageController { 
		get; 
		set {
			if (value != null) {
				pageController = value;
				pageController.setComponentController(this);
			}
		}
	}


}