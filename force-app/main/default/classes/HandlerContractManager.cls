/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-11-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/Contract/*')
global with sharing class  HandlerContractManager 
{
    @HttpGet
    global static Contract getContractById() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contract result =  [SELECT ContractNumber, AccountId, StartDate, EndDate, ContractTerm, Status, CustomerSignedId
                            FROM Contract
                            WHERE Id = :contractId];
        return result;
    }

    @HttpPost
    global static String createNewContract(String Name, String Status, Id AccountId, Date StartDate, Integer ContractTerm) {
        
        // Creation newContract
        Contract thisContract = new Contract(
            Name = Name,
            Status = Status,
            AccountId = AccountId,
            StartDate = StartDate,
            ContractTerm = ContractTerm);
        
        insert thisContract;
        
        
        return  'le contrat: '+thisContract.Name+' a été créé';
    }
    
   //Update a contract 
   @HttpPatch
   global static Contract updateContract() {
       RestRequest request = RestContext.request;
       String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
       Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
       
       // Deserialize the JSON string into name-value pairs
       Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
       
       // Iterate through each parameter field and value
       for(String fieldName : params.keySet()) {
           // Set the field and value on the Contract sObject
           thisContract.put(fieldName, params.get(fieldName));
       }
       update thisContract;
       return  thisContract;
   }
}
