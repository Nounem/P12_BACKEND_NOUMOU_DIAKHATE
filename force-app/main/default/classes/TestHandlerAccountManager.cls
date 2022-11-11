/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-05-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestHandlerAccountManager 
{

    public static Id createAccountId() {
        Account account = new Account(
            Name = 'AccountTest',
            Phone = '01020302'
        );
        insert account;
        return account.Id;
    }

    //Test to create a new account
    @isTest static void testCreateAccount() { 
        
        //Call the method to test
        Id thisAccountId = HandlerAccountManager.createAccount('accountTest');
        
        //Verify the test
        System.assert(thisAccountId != null);
        Account thisAccount = [SELECT name FROM Account WHERE Id=:thisAccountId];
        System.assert(thisAccount != null);
        
        System.assertEquals('accountTest', thisAccount.Name);
    }

    // Test get an account
    @isTest static void testgetAccountById() {
        Id accountId = createAccountId();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Account/'+ accountId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = HandlerAccountManager.getAccountById();
        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals('AccountTest', thisAccount.Name );
    }  


    //Test to update contact with info from AXG
    @isTest static void testUpdateaccount() {
        
        String account = createAccountId();
        
        //Create a record of contact to test
        Id thisAccountId = HandlerAccountManager.createAccount('AccountTest');
        
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://p7wirebrite-consulting-dev-ed.my.salesforce.com/services/apexrest/Account/'+thisAccountId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name": "NewNameTest"}');
        RestContext.request = request;
        
        //Update account of existing account
        HandlerAccountManager.updateAccount();
        
        //Verify contact was update
        
        account thisAccount = [SELECT Name FROM account WHERE Id=:thisaccountId];
        System.assert(thisAccount != null);
        System.assertEquals('NewNameTest', thisAccount.Name);
        
    }

   
    
}
