public with sharing class CTPersonController {

    public static String getToken(String mobileNo) {
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);
        return EncodingUtil.base64Encode(hash);
    }

    public static List<Person__c> getRecentHealthChanges() {
        return [SELECT Id, OwnerId, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    public static List<Person__c> searchPeople(String searchTerm) {
        List<Person__c> personList = new List<Person__c>();
        if(searchTerm != null) {
            String searchString = '%'+ searchTerm +'%';
            personList = [SELECT Id, OwnerId, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                            FROM Person__c 
                            WHERE Name LIKE :searchString OR 
                            Mobile__c LIKE :searchString OR
                            Token__c LIKE :searchString];
        }
        return personList;
    }

    public Person__c getPersonById(String personId) {
        List<Person__c> personList = new List<Person__c>();
        if(personId != null) {
            personList = [SELECT Id, OwnerId, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                            FROM Person__c 
                            WHERE Id = :personId];
        }
        if(personList != null && personList.size() > 0) {
            return personList[0];
        }
        return null;
    }
}