global class INT_Order
{
    webservice String sourceId;
    webservice String destinationId;
    webservice INT_Account account;
    webservice INT_Price price;
    webservice INT_Payment payment;
    webservice List<INT_LineItem> lineItems;
    webservice INT_Contact billToContact;
    webservice INT_Contact shipToContact;
    webservice String orderStatus;
    webservice String internationalStudentStatus;
    webservice String internationalSponsor;
    webservice Date academicStartDate;
    webservice String enrolmentStatus;
    webservice String enrolmentType;
    webservice INT_CancelEnrolment cancelEnrolment;

    webservice Date cancelAfterDate;
    webservice String createdDate;
    webservice Date doNotShipBeforeDate;
    webservice String businessId;
    webservice INT_Address overrideDeliveryAddress;

    webservice Boolean schedDeliveryOverride;
    webservice Boolean pOBoxIndicator;
    webservice Boolean rushFlag;
    webservice String divisionId;

    webservice INT_Employee salesrep;

    webservice List<INT_Instruction> instructions;

}