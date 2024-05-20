public with sharing class ContactHelper extends TriggerHandler{
    
    private List<Contact> newContList;
    private List<Contact> oldContactList;
    private Map<Id, Contact> newContactMap;
    private Map<Id, Contact> oldContactMap;
    
    public ContactHelper() {
        this.newContList = (List<Contact>) Trigger.new;
        this.oldContactList = (List<Contact>) Trigger.old;
        this.newContactMap = (Map<Id, Contact>) Trigger.newMap;
        this.oldContactMap = (Map<Id, Contact>) Trigger.oldMap;

    }

    public override void beforeInsert(){
       setDummyJSONId(newContList);
       
       
    }

    public override void afterInsert(){
        dummyCalloutonContactInsert(newContList);
    }

   
    // public override void afterUpdate(){
    //     dummyCalloutonContactUpdate(newContList);
    // }



    public static List<Contact> setDummyJSONId(List<Contact> newContList){
        final Integer MIN = 0;
        final Integer MAX = 100;
        List<Contact> updatedContactList = new List<Contact>();
        List<Integer> randomNumbersList = new List<Integer>();
        for (Contact cont : newContList) {
            System.debug(cont.Name);
            System.debug(cont.DummyJSON_Id__c);
            if(String.isBlank(cont.DummyJSON_Id__c)){
                Integer randomNumber = MIN + (Integer)Math.floor(Math.random() * (MAX - MIN + 1));
                Boolean duplicateFound = randomNumbersList.contains(randomNumber);
                System.debug(duplicateFound);
                if(!duplicateFound){
                    cont.DummyJSON_Id__c = String.valueOf(randomNumber);
                    randomNumbersList.add(randomNumber);
                    updatedContactList.add(cont);
                    System.debug(randomNumbersList);
                    System.debug(cont.Name);
                    System.debug(cont.DummyJSON_Id__c);
                    
                    System.debug('Contact Index ' + updatedContactList.indexOf(cont));
                    continue;
                }

                
                
                
                
            }
        }
        System.debug(updatedContactList);
        return updatedContactList;
    }
    
    public static void dummyCalloutonContactInsert(List<Contact> newContList){
        DummyJSONCalloutQueueable.enqueueJob();
    }
    
    
    public static void dummyCalloutonContactUpdate(List<Contact> newContList){
        for(Contact cont :newContList){
            if(cont.DummyJSON_Id__c > String.valueOf(100)){
               DummyJSONCallout.postCreateDummyJSONUser(cont.Id);
            }
        }
    }
}