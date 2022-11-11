/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-06-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/Contact/*')
global with sharing class HandlerContactManager 
{
  
    @HttpGet
    global static Contact getContactById() {
        RestRequest request = RestContext.request;
        // récupère l'Id à la fin de l'URL
        String contactId =  request.requestURI.substring(
                            request.requestURI.lastIndexOf('/')+1);
        Contact result =  [SELECT Salutation, FirstName, LastName, Email, Phone, Name
                           FROM Contact
                           WHERE Id = :contactId];
        return result;
    } 
    /*
    @HttpGet
    global static List<Contact> getContact() 
    {
        RestRequest request = RestContext.request;
        List<Contact> result =  [SELECT Salutation, FirstName, LastName, Email, Phone
                           FROM Contact];
        return result;
    }
*/



   //Create contact 
   @HttpPost
   global static String createContact(String lastName, String firstName, String email, String phone) {
       List<Contact> contacts = [SELECT Id FROM Contact WHERE Email=:email];
       if (contacts.size() != 0) {
           return contacts[0].Id;
       } else {
           Contact thisContact = new Contact();
           thisContact.LastName = lastName;
           thisContact.FirstName = firstName;
           thisContact.Email = email;
           thisContact.Phone = phone;
           
           insert thisContact;
           return 'le contact a été bien créé : '+thisContact.LastName+'-'+thisContact.LastName;
       }
   }



   @HttpPatch
   global static Contact updateContact() {
       RestRequest request = RestContext.request;
       String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
       Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
       // Deserialize the JSON string into name-value pairs
       Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
       // Iterate through each parameter field and value
       for(String fieldName : params.keySet()) {
           // Set the field and value on the Contact sObject
           thisContact.put(fieldName, params.get(fieldName));
           
       }
       update thisContact;
       return thisContact;
   }


    @HttpDelete
    global static String deactivateContact(){
        
        
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        // Récupère la valeur du champ Active__c en fonction de l'Id
        Contact result = [SELECT Active__c 
                          FROM Contact 
                          WHERE Id = :id
                        ];

        Contact contact = new Contact(); 
        contact.Id = id; 
        contact.Active__c = false;  
        
        
        update contact;
        return 'le contact '+contact.Id+' a été désactivé';
    }

    
}

