public class RC_ListSlider {
    private list<Object> olist;
    
    public RC_ListSlider(list<Object> olist){
        this.olist = olist;
    }   
    
    public list<Object> slice(){
        
        return olist.clone();
    }   
    
    public list<Object> slice(Decimal x_begin){
        Integer start = x_begin == NULL ? 0 : (Integer) x_begin.round(System.RoundingMode.CEILING);
        
        return commonSlice(start,olist.size());
    }   
    
    public list<Object> slice(Decimal x_begin, Decimal x_end){
        Integer start  = x_begin == NULL ? 0            : (Integer) x_begin.round(System.RoundingMode.CEILING);
        Integer finish = x_end   == NULL ? olist.size() : (Integer) x_end.round(System.RoundingMode.CEILING);
        
        return commonSlice(start, finish);
    }   
    
    private list<Object> commonSlice(Integer x_begin, Integer x_end){
        list<Object> ret = new list<Object>();
        
        x_begin = x_begin < 0 ? olist.size() + x_begin : x_begin ;
        x_end   = x_end   < 0 ? olist.size() + x_end   : x_end   ; 
        
        Integer maxIndex = olist.size();
        while (x_begin < maxIndex && x_begin < x_end){
            ret.add(olist[x_begin]);
            x_begin++;
        }
        
        return ret;
    }   
}