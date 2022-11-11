/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-11-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestHandlerContractManager 
{

    @testSetup 
    static void makeData() 
    {
        Account account = new Account(
            Name = 'AccountTest'
        );
        insert account;

        Contract contract = new Contract(
            AccountId = account.Id,
            Status = 'Draft',
            ContractTerm = 12,
            StartDate = Date.valueOf('2022-12-22')          
        );
        insert contract;
       

    }

    @isTest
    static void testCreateContract() 
    {
        Id thisAccountId =  [SELECT Id FROM Account].Id;

        Test.startTest();
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();

        RestContext.response = res;
        request.requestURI = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contract/';
        request.httpMethod = 'POST';
        RestContext.request = request;
        HandlerContractManager.createNewContract('TestContract','Draft',thisAccountId, Date.valueOf('2022-01-30'),12);

        Test.stopTest();

        Integer nbOfContract = [SELECT Id FROM Contract].size();
        System.assertEquals(2, nbOfContract);     
    }
   
    @isTest 
    static void testGetContractById() {
        Id thisContractId =  [SELECT Id FROM Contract].Id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contract/'+thisContractId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Contract thisContract = HandlerContractManager.getContractById();
        // Verify results
        System.assert(thisContract != null);
        System.assertEquals('Draft', thisContract.Status);
    }

    @isTest 
    static void testUpdateContract() {
        
        //Create a record of contact to test
        Id thisContractId =  [SELECT Id FROM Contract].Id;
        
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Contract/'+thisContractId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Activated"}');
        RestContext.request = request;
        
        //Update contract of existing contract
        HandlerContractManager.updateContract();
        
        //Verify contact was update
        
        Contract thisContract = [SELECT Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals('Activated', thisContract.Status);
        
    }



}
