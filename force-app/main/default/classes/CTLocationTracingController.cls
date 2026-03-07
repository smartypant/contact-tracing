public with sharing class CTLocationTracingController {
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        List<Location_Tracing__c> locTracList = new List<Location_Tracing__c>();
        if(locationId != null) {
            locTracList = [SELECT Name, Person__c, Location__c, Visit_Date__c, Id 
                            FROM Location_Tracing__c 
                            WHERE Location__c = :locationId
                            ORDER BY Visit_Date__c DESC NULLS LAST];
        }
        return locTracList;
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds (Set<Id> personIds) {
        List<Location_Tracing__c> locTracList = new List<Location_Tracing__c>();
        if(personIds != null) {
            locTracList = [SELECT Name, Person__c, Location__c, Visit_Date__c, Id 
                            FROM Location_Tracing__c 
                            WHERE Person__c in :personIds
                            AND Visit_Date__c = LAST_N_DAYS:10
                            ORDER BY Visit_Date__c DESC NULLS LAST];
        }
        return locTracList;        
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds (Set<Id> locationIds) {
        List<Location_Tracing__c> locTracList = new List<Location_Tracing__c>();
        if(locationIds != null) {
            locTracList = [SELECT Name, Person__c, Location__c, Visit_Date__c, Id 
                            FROM Location_Tracing__c 
                            WHERE Location__c in :locationIds 
                            AND Person__r.Health_Status__c = 'Green' 
                            AND Visit_Date__c = LAST_N_DAYS:10
                            ORDER BY Visit_Date__c DESC NULLS LAST];
        }
        return locTracList;        
    }

    public static List<Location_Tracing__c> checkDuplicates (List<Location_Tracing__c> newLocationTraces) {
        Set<Id> locationSetids = new Set<Id>();
        Set<Id> personSetIds = new Set<Id>();
        for(Location_Tracing__c locTrace: newLocationTraces) {
            locationSetids.add(locTrace.Location__c);
            personSetIds.add(locTrace.Person__c);
        }
        List<Location_Tracing__c> existingLocTracList = [SELECT Name, Person__c, Location__c, Visit_Date__c, Id 
                                                            FROM Location_Tracing__c 
                                                            WHERE Location__c in :locationSetids 
                                                            AND Person__c in :personSetIds];
        Map<Id, Set<Id>> locPersonMap = new Map<Id, Set<Id>>();
        for(Location_Tracing__c locTraceObj : existingLocTracList) {
            if(!locPersonMap.containsKey(locTraceObj.Location__c)) {
                locPersonMap.put(locTraceObj.Location__c, new Set<Id>());
            }
            locPersonMap.get(locTraceObj.Location__c).add(locTraceObj.Person__c);
        }
        List<Location_Tracing__c> duplicateLocTraceList = new List<Location_Tracing__c>();
        for(Location_Tracing__c locTraceObj: newLocationTraces) {
            if(locPersonMap.get(locTraceObj.Location__c) != null && locPersonMap.get(locTraceObj.Location__c).contains(locTraceObj.Person__c)){
                duplicateLocTraceList.add(locTraceObj);
            }
        }
        return duplicateLocTraceList;        
    }
}