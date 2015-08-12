global class INT_LineItem
{
    webservice String sourceId;
    webservice String destinationId;
    webservice String itemNumber;
    webservice INT_CourseProduct course;
    webservice INT_ModuleProduct module;
	webservice INT_BookProduct book;

    webservice Integer quantity;
    webservice String status;
    webservice String action;
    webService String parentLineId;

    webservice String shipMethodCode;
    webservice INT_BookProduct shippedBook;

    webservice Boolean allowSubstitution;
    webservice Boolean restrictionOverride;
    webservice Boolean forceShipping;

    webservice String targetSystem;

}