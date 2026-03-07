public with sharing class CTPeopleTracingController {
    public static People_Tracing__c getTraces (Id recordId) {
        List<People_Tracing__c> peopTraceList = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, 
                                                    Person_1__r.Name, Person_2__r.Name FROM People_Tracing__c];
        if(peopTraceList != null && peopTraceList.size() > 0) {
            return peopTraceList[0];
        }
        return null;
    }

    public static List<People_Tracing__c> checkDuplicates (List<People_Tracing__c> newPeopleTracing) {
        Set<Id> personSetId1 = new Set<Id>();
        Set<Id> personSetId2 = new Set<Id>();
        List<People_Tracing__c> duplicateList = new List<People_Tracing__c>();
        for(People_Tracing__c people : newPeopleTracing) {
            personSetId1.add(people.Person_1__c);
            personSetId2.add(people.Person_2__c);
        }
        List<People_Tracing__c> existingPeopleTraceRecs = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, 
                                                            Person_1__r.Name, Person_2__r.Name FROM People_Tracing__c];
        Map<Id, People_Tracing__c> peoplMap = new Map<Id, People_Tracing__c>();
        for(People_Tracing__c peo : existingPeopleTraceRecs) {
            peoplMap.put(peo.Person_1__c, peo);
        }
        for(People_Tracing__c peo : newPeopleTracing) {
            if(peoplMap.containsKey(peo.Person_1__c) && peo.Person_2__c == peoplMap.get(peo.Person_1__c).Person_2__c ||
            peoplMap.containsKey(peo.Person_2__c) && peo.Person_1__c == peoplMap.get(peo.Person_2__c).Person_1__c) {
                duplicateList.add(peo);
            }
        }
        return duplicateList;
    }
}