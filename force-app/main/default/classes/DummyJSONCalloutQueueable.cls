public with sharing class DummyJSONCalloutQueueable implements Queueable, Database.AllowsCallouts{
    
    private List<Contact> contactList;
    private static final Integer MAX_JOBS = 5;
    
    
    public DummyJSONCalloutQueueable(List<Contact> contactList) {
        this.contactList = contactList;


    }

    public static void enqueueJob(){
        List<Contact> queryList = [SELECT Id,DummyJSON_Id__c FROM Contact WHERE DummyJSON_Id__c != null AND Email = null];
        List<Contact> validContactsList = new List<Contact>();
        for(Contact cont :queryList){
            Integer dummyJSONIdInteger = Integer.valueOf(cont.DummyJSON_Id__c);
            if(dummyJSONIdInteger <= 100){
                validContactsList.add(cont);
            }
        }
        
        if(!validContactsList.isEmpty()){
         System.enqueueJob(new DummyJSONCalloutQueueable(validContactsList));
        }
        
        
    }

    public void execute(QueueableContext queueable){
        for(Contact cont :contactList){
            DummyJSONCallout.getDummyJSONUserFromId(cont.DummyJSON_Id__c);
        }

        Boolean reachedMaxDepth = AsyncInfo.getMaximumQueueableStackDepth() == MAX_JOBS;
        if(!reachedMaxDepth){
            NextStepQueueable.enqueueJob();
        }
    }


}