global class INT_Account
{

    webservice INT_Organisation pearsonOrganisation;

    webService String sourceId; // unique identifier of the learner
    webService String destinationId;
    webservice String legacyAccountId;
    webservice String friendlyUniqueIdentifier;

    webService INT_Contact primaryContact;
    webService INT_Contact defaultBillToContact;

    webservice INT_CourseProduct activeCourse;

    webservice String businessId;
    webservice String subBusinessId;
    webservice String name;

    webservice INT_Address shippingAddress;

    webservice INT_Account parentAccount;
}