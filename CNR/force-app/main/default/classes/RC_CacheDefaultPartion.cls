public class RC_CacheDefaultPartion {
    @AuraEnabled
    public static void putSession(String key, String value) {
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.DefaulCache');
        orgPart.put(key,value);
    }
    @AuraEnabled
    public static String getSession(String key) {
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.DefaulCache');
        system.debug('orgPart.getKeys(): ' + orgPart.getKeys());
        if (orgPart.contains(key)) {
            String value = (String)orgPart.get(key);
            system.debug('value:' + value);
            return value;
        }              
        return '';
    }
}