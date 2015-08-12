/*
 *Author: Matt Hime (tquila)
 *Date: 3/8/2012
 *Description: This class builds the data used to populate the tree view used on the CourseSearchTreeview page
 */

public class PearsonCourseStructureUtility {
/*
 *The node wrapper class stores the structure of the PearsonCourseStructure objects in their
 *hierarchy.  It is subsequently converted to a JSON string and consumed by the tree view
 */
	public class NodeWrapper{
		public string NodeName {get; set;}				//PearsonCourseStructure__c.Name
		public id NodeId {get; set;}					//The Sf Id of the record being displayed
		public list<NodeWrapper> Children {get; set;}	//Holds every NodeWrapper object below this one in the hierarchy
		public boolean hasChildren {get; set;}			//True if childCount > 0
		public integer childCount {get; set;}			//The number of items in Children list
		public string Type {get; set;}					//PearsonCourseStructure__c.Type__c
		
		/*
		 *Constructor
		 *Initialise significant variables
		 */
		public NodeWrapper(){
			Children = new list<NodeWrapper>();
			hasChildren = false;
			childCount = 0;
		}
	}
	
	//This list holds all the top-level nodes and is used as a starting point to build the tree
	private static list<PearsonCourseStructure__c> ParentCourseStructures;
	
	//TRhis mapp allows us to work with Id's and flesh out the data when required
	private static map<id, PearsonCourseStructure__c> AllCoursesMap;
	
	//The ParentMap is used to get all the children of a single PearsonCourseStructure__c
	private static map<id, list<PearsonCourseStructure__c>> CourseParentMap;
	
	/*
	 *CourseNodes follow the hierarchy of the PearsonCourseStructure__c objects,  that's to say the branch
	 *typically begins with a Discipline and has a number of Clusters that end in Courses
	 */
	private static list<NodeWrapper> CourseNodes;
	
	//Standard Sf object used to generate the JSON data
	private static JSONGenerator gen;

	/*
	 *This method gets called by the treeview page
	 *It populates all the data and forms a hierarchical view of it
	 */
	public static void PrepareTreeViewNodeData(){
		loadCourseData();
		
		CourseNodes = new list<NodeWrapper>();
		
		for(PearsonCourseStructure__c d : ParentCourseStructures){
			CourseNodes.add(createNode(d.Id));
		}
	}
	
	/*
	 *This method makes one loop through all the PearsonCourseStructure objects
	 *It stores all data as a map (with the Sf Id as the key)
	 *It stores all the parent nodes (where Parent_Pearson_Course_Structure__c == null) in a list
	 *It stores al the child nodes (where Parent_Pearson_Course_Structure__c != null) 
	 *in a map with a key of Parent_Pearson_Course_Structure__c
	 */
	private static void loadCourseData(){
		//The three significant data collections...
		ParentCourseStructures = new list<PearsonCourseStructure__c>();
		AllCoursesMap = new  map<id, PearsonCourseStructure__c>();
		CourseParentMap = new map<id, list<PearsonCourseStructure__c>>();
		
		// Setting containing course types to display
		Map<String,PearsonCourseStructureSearchTypes__c> displayCourseTypes = PearsonCourseStructureSearchTypes__c.getAll();
		
		//Iterating through all the PearsonCourseStructure__c objects in the org 
		for(PearsonCourseStructure__c pcs :[select Id, Name, Type__c, Parent_Pearson_Course_Structure__c, Parent_Pearson_Course_Structure__r.Type__c
											from PearsonCourseStructure__c
											where Active_Indicator__c = true
											and Type__c in : displayCourseTypes.keySet()
											order by Name, Parent_Pearson_Course_Structure__c]){
			
			//Is this a parent object? (Treat it as a parent if we haven't loaded it's parent)
			if(pcs.Parent_Pearson_Course_Structure__c == null || !displayCourseTypes.containsKey(pcs.Parent_Pearson_Course_Structure__r.Type__c)){
				ParentCourseStructures.add(pcs);
			}
			else{
				//Okay,  it's a child,  does it have brothers and sisters?
				list<PearsonCourseStructure__c> siblings = CourseParentMap.get(pcs.Parent_Pearson_Course_Structure__c);
				
				if(siblings == null){
					//No,  so,  create a new list
					siblings = new list<PearsonCourseStructure__c>{pcs};
				}
				else{
					//Yes,  add it to the list
					siblings.add(pcs);
				}
				/*
				 *Store the list in the map with the parent Id as the key
				 *It doesn't matter if the key value already exists in the map,  this will overwrite it
				 */
				CourseParentMap.put(pcs.Parent_Pearson_Course_Structure__c, siblings);
			}
			//Record the details of all the objects
			AllCoursesMap.put(pcs.Id, pcs);
		}
	}
	
	/*
	 *This method takes any PearsonCourseStructure__c Id and converts it into a NodeWrapper object
	 *It also calls itself for each child of the Id it is passed to build an hierarchical structure
	 *with each child nested within it's parent object
	 */
	private static NodeWrapper createNode(Id PCSId){
		//Get the data for this Id
		PearsonCourseStructure__c pcs = AllCoursesMap.get(PCSId);
		
		//Create the NodeWrapper object and populate it
		NodeWrapper nw = new NodeWrapper();
		nw.NodeName = pcs.Name;
		nw.NodeId = pcs.Id;
		nw.Type = pcs.Type__c;
		
		//Check the parent map to see if there are any children
		list<PearsonCourseStructure__c> children = CourseParentMap.get(pcs.Id);
		if(children != null){
			//If there are,  fill in the child details
			nw.hasChildren = true;
			nw.childCount = children.size();
			nw.Children = new list<NodeWrapper>();
			
			//Now call this method for every child to build the hierarchy
			for(PearsonCourseStructure__c child : children){
				nw.Children.add(createNode(child.Id));
			}
		}
		
		return nw;
	}

	/*
	 *This method takes a NodeWrapper object and uses the standard Sf JSON object to convert it into
	 *JSON data.  It calls itself for each child NodeWrapper found.
	 *
	 *There's a mass of settings that can be passed to the tree view,  
	 *for the complete list see the documentation in the DynaTree static resource
	 *At it's simplest,  we need to specify  node name,  it's id and any children
	 */
    private static void convertNodeToJSON(NodeWrapper node){
        gen.writeStartObject();
        gen.writeStringField('title', node.NodeName);	//Value to be displayed on screen
        gen.writeStringField('key', node.NodeId);		//The Sf id of the item displayed
        gen.writeBooleanField('unselectable', false);
        gen.writeBooleanField('expand', false);			//Don't expand all the nodes,  let the user do it
        gen.writeBooleanField('isFolder', false);
        gen.writeStringField('Type', node.Type);		//Type as dictated by Type__c

        if (node.hasChildren){
            gen.writeFieldName('children');
            gen.writeStartArray();
                
            for (NodeWrapper nw : node.Children){
                convertNodeToJSON(nw);
            }
                
            gen.writeEndArray();
        }

    	gen.writeEndObject();
    }
	
	/*
	 *Takes the NodeWrapper collection,  wraps it in a root node and then calls the convertNodeToJSON
	 *iteratively to produce a string of JSON formatted data for cionsumption by the tree view
	 *
	 *This is what is fed to the DynaTree component
	 */
	public static string getTreeJSONData() {
        gen = JSON.createGenerator(false);
        gen.writeStartArray();
        
        for(NodeWrapper nw : CourseNodes){
        	convertNodeToJSON(nw);
        }
        gen.writeEndArray();
        
        return gen.getAsString();
    }
}