public with sharing class DummyJSONPOSTCalloutQueueable implements Queueable,Database.AllowsCallouts{

    private List<Contact> contactList;
    private static final Integer MAX_JOBS = 5;

    public DummyJSONPOSTCalloutQueueable(List<Contact> contactList) {
        this.contactList = contactList;

    }

    public static void enqueueJob(){
        List<Contact> queryList = [SELECT Id,DummyJSON_Id__c FROM Contact WHERE DummyJSON_Id__c != null];
        List<Contact> validContacts = new List<Contact>();
        for(Contact cont :queryList){
            Integer dummyJSONIdInteger = Integer.valueOf(cont.DummyJSON_Id__c);
            if(dummyJSONIdInteger > 100){
                validContacts.add(cont);
            }
        }

        if(!validContacts.isEmpty()){
            System.enqueueJob(new DummyJSONPOSTCalloutQueueable(validContacts));
        }
    }

    public void execute(QueueableContext queueable){
        for(Contact cont :contactList){
            DummyJSONCallout.postCreateDummyJSONUser(cont.Id);
        }

        Boolean reachedMaxDepth = AsyncInfo.getMaximumQueueableStackDepth() == MAX_JOBS;
        if(!reachedMaxDepth){
            NextStepQueueable.enqueueJob();
        }
    }
}