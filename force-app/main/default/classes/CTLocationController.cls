public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChange () {
        return [SELECT Name, Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c 
                ORDER BY Status_Update_Date__c DESC NULLS FIRST LIMIT 100];
    }

    public static List<Location__c> searchLocation (String searchTerm) {
        String searchString = searchTerm + '%';
        List<Location__c> locationList = new List<Location__c>();
        locationList = [SELECT Name, Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                        FROM Location__c 
                        WHERE Name LIKE :searchString OR 
                        Address__c LIKE :searchString OR 
                        Pincode__c LIKE :searchString
                        ORDER BY Status_Update_Date__c DESC NULLS FIRST];
        return locationList;
    }

    public static Location__c getLocationById (String locationId) {
        List<Location__c> locationList = new List<Location__c>();
        if(locationId != null) {
            locationList = [SELECT Name, Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                            FROM Location__c 
                            WHERE Id = :locationId];
        }
        if(locationList != null && locationList.size() > 0) {
            return locationList[0];
        }
        return null;
    }
}