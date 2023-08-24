public class RC_Logger {
    
    public static RC_Logger__c CREATELOG(String Message, String MessageDetail, String ExStackTrace, String ClassName, String FunctionName, String ComponentName, String relatedObjectId, String logType){
        RC_Logger__c logItem = new RC_Logger__c(
            RC_Message__c = Message,
            RC_Message_Detail__c = MessageDetail,
            RC_StackTrace__c = ExStackTrace,
            RC_LogLevel__c = 'INFO',
            CreateDate__c = DateTime.now(),
            RC_ClassName__c = ClassName,
            RC_FunctionName__c = FunctionName,
            RC_ComponentName__c = ComponentName,
            RC_RelatedDataId__c = relatedObjectId,
            RC_LogType__c = logType
        );
        
        return logItem;
    }
    
    public static void LOG(RC_Logger__c log){
        RC_Logger__c logItem; 
        try{
            logItem = new RC_Logger__c(
                RC_Message__c = log.RC_Message__c,
                RC_Message_Detail__c = log.RC_Message_Detail__c,
                RC_StackTrace__c = log.RC_StackTrace__c,
                RC_LogLevel__c = log.RC_LogLevel__c,
                CreateDate__c = DateTime.now(),
                RC_ClassName__c = log.RC_ClassName__c,
                RC_FunctionName__c = log.RC_FunctionName__c,
                RC_ComponentName__c = log.RC_ComponentName__c            
            );
            DataBase.insert(logItem);
        }
        catch(Exception ex){
            System.debug(ex.getMessage());     
            String result = Json.serialize(logItem);
            LOG_EXCEPTION(ex.getMessage(),result,ex.getStackTraceString(),'RC_Logger','LOG','');
        }
    }
    
    public static void LOG_EXCEPTION(String ExMessage, String MessageDetail, String ExStackTrace, String ClassName, String FunctionName, String ComponentName){        
        RC_Logger__c logItem; 
        try{
            logItem = new RC_Logger__c(
                RC_Message__c = ExMessage,
                RC_Message_Detail__c = MessageDetail,
                RC_StackTrace__c = ExStackTrace,
                RC_LogLevel__c = 'EXCEPTION',
                CreateDate__c = DateTime.now(),
                RC_ClassName__c = ClassName,
                RC_FunctionName__c = FunctionName,
                RC_ComponentName__c = ComponentName            
            );
            DataBase.insert(logItem);
        }
        catch(Exception ex){
            System.debug(ex.getMessage());     
            String result = Json.serialize(logItem);
            LOG_EXCEPTION(ex.getMessage(), result,ex.getStackTraceString(),'RC_Logger','LOG_EXCEPTION','');
        }
    }
    
    public static void LOG_DMLEXCEPTION(DmlException e, String MessageDetail, String ClassName, String FunctionName, String ComponentName)
    {  
        List<RC_Logger__c> listoflogger= new List<RC_Logger__c>();
        try{
            RC_Logger__c logItem;
            for (Integer i = 0; i < e.getNumDml(); i++) {
                logItem = new RC_Logger__c(
                    RC_Message__c = e.getDmlMessage(i),
                    RC_Message_Detail__c = MessageDetail,
                    RC_StackTrace__c = e.getStackTraceString(),
                    RC_LogLevel__c = 'DMLEXCEPTION',
                    CreateDate__c = DateTime.now(),
                    RC_ClassName__c = ClassName,
                    RC_FunctionName__c = FunctionName,
                    RC_ComponentName__c = ComponentName
                );
                listoflogger.add(logItem);
            }
            DataBase.insert(listoflogger);
        }
        catch(Exception ex){
            System.debug(ex.getMessage());     
            String result = Json.serialize(listoflogger);
            LOG_EXCEPTION(ex.getMessage(),result,ex.getStackTraceString(),'RC_Logger','LOG_DMLEXCEPTION','');
        }
    }
    @future(callout=true)
    public static void LOG_INFO(String Message, String MessageDetail, String ClassName, String FunctionName, String ComponentName){
        RC_Logger__c logItem; 
        try{
            logItem = new RC_Logger__c(
                RC_Message__c = Message,
                RC_Message_Detail__c = MessageDetail,
                RC_LogLevel__c = 'INFO',
                CreateDate__c = DateTime.now(),
                RC_ClassName__c = ClassName,
                RC_FunctionName__c = FunctionName,
                RC_ComponentName__c = ComponentName            
            );
            DataBase.insert(logItem);
        }
        catch(Exception ex){
            System.debug(ex.getMessage());     
            String result = Json.serialize(logItem);
            LOG_EXCEPTION(ex.getMessage(), result,ex.getStackTraceString(),'RC_Logger','LOG_INFO','');
        }
    }
    
    @future(callout=true)
    public static void LOG_INFO2(String Message, String MessageDetail, String ClassName, String FunctionName, String ComponentName){
        RC_Logger__c logItem; 
        try{
            logItem = new RC_Logger__c(
                RC_Message__c = Message,
                RC_Message_Detail__c = MessageDetail,
                RC_LogLevel__c = 'INFO',
                CreateDate__c = DateTime.now(),
                RC_ClassName__c = ClassName,
                RC_FunctionName__c = FunctionName,
                RC_ComponentName__c = ComponentName            
            );
            DataBase.insert(logItem);
        }
        catch(Exception ex){
            System.debug(ex.getMessage());     
            String result = Json.serialize(logItem);
            LOG_EXCEPTION(ex.getMessage(), result,ex.getStackTraceString(),'RC_Logger','LOG_INFO','');
        }
    }
       @future(callout=true)
        public static void LOG_EXCEPTION2(String ExMessage, String MessageDetail, String ExStackTrace, String ClassName, String FunctionName, String ComponentName){        
        RC_Logger__c logItem; 
        try{
            logItem = new RC_Logger__c(
                RC_Message__c = ExMessage,
                RC_Message_Detail__c = MessageDetail,
                RC_StackTrace__c = ExStackTrace,
                RC_LogLevel__c = 'EXCEPTION',
                CreateDate__c = DateTime.now(),
                RC_ClassName__c = ClassName,
                RC_FunctionName__c = FunctionName,
                RC_ComponentName__c = ComponentName            
            );
            DataBase.insert(logItem);
        }
        catch(Exception ex){
            System.debug(ex.getMessage());     
            String result = Json.serialize(logItem);
            LOG_EXCEPTION(ex.getMessage(), result,ex.getStackTraceString(),'RC_Logger','LOG_EXCEPTION','');
        }
    }
    
}