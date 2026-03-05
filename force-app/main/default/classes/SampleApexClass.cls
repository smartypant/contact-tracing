public with sharing class SampleApexClass {
    public SampleApexClass() {

    }

    public String returnName(String firstName, String lastName) {
        string fullName = firstName + ' ' + lastName;
        return fullName;
    }
}