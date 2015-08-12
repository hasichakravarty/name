/*
 *Author: Matt Hime (tquila)
 *Date: 21/8/2012
 *Description:	This test class asserts that the pagecontrollerbase and componentcontrollerbase classes maintain their relationship with each other.
 *				These classes are used to controll multiple custom components on a page.  Each component is given a key value which the page can then
 				use to call that component to apply data to it or grab data from it
 */
 
@isTest()
public with sharing class PageControllerBaseTester {
	
	static testMethod void testSingleComponent(){
		
		//Create the page controller object,  this is usually extended by the page on which the component sits
		PageControllerBase pageBase = new PageControllerBase();
		
		//Create a component controller object. This is usually extended by the custom component controller
		ComponentControllerBase controllerBase =  new ComponentControllerBase();
		//This is the key by which the page can distinguish the component
		controllerBase.key = 'controllerBase';
		//The controller holds a reference to the page it sits in
		controllerBase.pageController = pageBase;

		//The page holds a reference to this controller
		pageBase.setComponentController(controllerBase);
		
		//Check we can return the correct component controller
		system.AssertEquals(controllerBase, pageBase.getComponentController());
	}
	
	static testMethod void testMultipleComponent(){
		
		//Create the page controller object,  this is usually extended by the page on which the component sits
		PageControllerBase pageBase = new PageControllerBase();
		
		//Create a component controller object. This is usually extended by the custom component controller
		ComponentControllerBase controllerBase1 =  new ComponentControllerBase();
		controllerBase1.pageController = pageBase;
		controllerBase1.key = 'controllerBase1';
		
		//Create a 2nd component controller object - note that we give it and unique value for key
		ComponentControllerBase controllerBase2 =  new ComponentControllerBase();
		controllerBase2.key = 'controllerBase2';
		controllerBase2.pageController = pageBase;

		//Add the components to the page
		pageBase.setComponentControllerMap('controllerBase2', controllerBase2);
		pageBase.setComponentControllerMap('controllerBase1', controllerBase1);
		
		//Check that we can retrieve the components
		Map<String, ComponentControllerBase> componentMap = pageBase.getComponentControllerMap();
		system.AssertEquals(controllerBase2, componentMap.get('controllerBase2'));
		system.AssertEquals(controllerBase1, componentMap.get('controllerBase1'));
	}
	
	static testMethod void testSelfSelect(){
		
		//Create the page controller object,  this is usually extended by the page on which the component sits
		PageControllerBase pageBase = new PageControllerBase();

		//Create a component controller object. This is usually extended by the custom component controller
		ComponentControllerBase controllerBase1 =  new ComponentControllerBase();
		controllerBase1.key = 'controllerBase1';
		controllerBase1.pageController = pageBase;

		//Check that we cn retrieve a reference to This
		PageControllerBase pageBase2 = pageBase.getThis();
		system.assertEquals(pageBase.getComponentController(), pageBase2.getComponentController());
	}
	
}