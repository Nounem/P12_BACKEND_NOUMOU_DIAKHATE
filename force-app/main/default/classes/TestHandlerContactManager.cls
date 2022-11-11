/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-11-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestHandlerContactManager 
{

    @testSetup 
    static void makeData() 
    {
        Contact con = new Contact(
            LastName = 'lastNameTestNoumou',
            FirstName = 'firstNameTestDIA',
            Email = 'moumouTest@test.com',
            Phone = '060606060'
        );
        insert con;
    }

    
    @isTest
    static void createContact() {

    Test.startTest();
    
    RestRequest request = new RestRequest();
    RestResponse res = new RestResponse();

    RestContext.response = res;
    request.requestURI = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contact/';
    request.httpMethod = 'POST';
    RestContext.request = request;
    HandlerContactManager.createContact('TestFirstName', 'TestLastName', 'new@email.com','0102030708');

    Test.stopTest();

    Integer nbOfContact = [SELECT Id FROM Contact].size();
    System.assertEquals(2, nbOfContact);     
    }

    @isTest
    static void createContactWithSameEmail() {

        Test.startTest();

        Id contactId = [SELECT Id FROM Contact WHERE Email = 'moumouTest@test.com' LIMIT 1].Id;
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        RestContext.request = request;
        RestContext.response = res;
        request.requestURI = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contact/'+contactId;
        request.httpMethod = 'POST';
        RestContext.request = request;
        HandlerContactManager.createContact('TestFirstName', 'TestLastName', 'moumouTest@test.com','0102030405');

        Test.stopTest();

        Integer nbOfContact = [SELECT Id FROM Contact].size();
       
        System.assertEquals(1, nbOfContact);   
    }


    // Test get a contact
    @isTest static void testGetContactById() 
    {
        Id contactId = [SELECT Id, Email, FirstName FROM Contact LIMIT 1 ].Id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contact/'+ contactId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Contact thisContact = HandlerContactManager.getContactById();
        // Verify results
        System.assert(thisContact != null);
        System.assertEquals('firstNameTestDIA lastNameTestNoumou', thisContact.Name );
    }
    //Test to update contact with info from AXG
    @isTest static void testUpdateContact() {
        //Create a record of contact to test
        Id thisContactId =  [SELECT Id, Email, FirstName FROM Contact LIMIT 1 ].Id;
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contact/'+thisContactId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"email": "newemail@exemple.com"}');
        RestContext.request = request;
        //Update contact of existing contact
        Contact contactUpdate = HandlerContactManager.updateContact();
        
        //Verify contact was update
        System.assert(contactUpdate != null);
        Contact thisContact = [SELECT Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals('newemail@exemple.com', thisContact.Email);
        
    }

    //Test to unactive contact after delete from AXG
    @isTest static void testDisableContact() {
        //Create a record of contact to test
        Id thisContactId =  [SELECT Id, Email, FirstName FROM Contact LIMIT 1 ].Id;
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contact/'+thisContactId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        //Disable contact
        HandlerContactManager.deactivateContact();
        
        //Verify the contact is disable and NOT delete
        Contact thisContact = [SELECT Active__c FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(false, thisContact.Active__c);
    }

   

   
}
