/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-05-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@RestResource(urlMapping='/Account/*')
global with sharing class HandlerAccountManager 
{
    

   //Creation d'un nouveau compte
   @HttpPost
   global static Id createAccount(String name) 
   {   
        Account newAcc = new Account( Name = name );
        insert newAcc;
        return newAcc.Id;       
   }

    @HttpGet
    global static Account getAccountById() 
    {
        RestRequest request = RestContext.request;
        
         // récupère l'Id à la fin de l'URL
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account result =  [
                            SELECT Id, Name 
                            FROM Account 
                            WHERE Id = :accountId
                        ];    

        return result;
        
    } 

   //Update account 
   @HttpPatch
   global static Account updateAccount() 
   {
       RestRequest request = RestContext.request;
       String getId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
       Account account = [SELECT Id FROM Account WHERE Id = :getId];
       
       // Désérialisation de la chaîne JSON en paires nom-valeur.
       Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
       
       for(String fieldName : params.keySet()) {
           // Définir le champ et la valeur sur le compte sObject
           account.put(fieldName, params.get(fieldName));
       }
       update account;
       return account;
   }





   
}
