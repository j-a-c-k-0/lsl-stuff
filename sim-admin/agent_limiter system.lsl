list only_once1;
list only_once0;
list whitelist 
=[
"fe61e4d8-e195-4166-a7f7-ba163964b992"//jack
];
integer flag = AGENT_LIST_REGION;
integer streaminglimit = 3500;
integer scriptlimit = 500;
integer event_timer = 3;
integer relay = 678445;

message(string message)
{
    list TempList = llGetAgentList(flag, []);
    integer Length= llGetListLength(TempList);
    if (!Length){ return; }else
    {
    integer x;
    for ( ; x < Length; x += 1)
    {  
    llRegionSayTo(llList2String(TempList, x),0,message);   
} } }
graphics_agentleft() 
{    
    integer Length = llGetListLength(only_once1);     
    if (!Length){ return; }else
    {
               integer x;
               for ( ; x < Length; x += 1)
               {  
               list items = llParseString2List(llList2String(only_once1,x), ["|"], []);
               vector agent = llGetAgentSize(llList2String(items,0));
               if(agent){ }else
               { 
               integer r = llListFindList(only_once1,[llList2String(only_once1,x)]);
               only_once1 = llDeleteSubList(only_once1, r,r);                
} } } }
graphics_check(key id,integer value)
{
    integer Length = llGetListLength(only_once1);     
    if (!Length){ return; }else
    {
          integer x;
          for ( ; x < Length; x += 1)
          { 
          list items = llParseString2List(llList2String(only_once1,x), ["|"], []);
          if(id == llList2String(items,0))
          {
          if(value == llList2Integer(items,1)){ }else
          {
          integer r = llListFindList(only_once1,[llList2String(only_once1,x)]); 
          only_once1 = llDeleteSubList(only_once1,r,r);
} } } } }
graphics() 
{    
        graphics_agentleft();
        list TempList = llGetAgentList(flag, []);
        integer Length= llGetListLength(TempList);     
        if (!Length){ return; }else
        {
             integer x;
             for ( ; x < Length; x += 1)
             {  
             list details = llGetObjectDetails(llList2String(TempList, x), ([OBJECT_STREAMING_COST,OBJECT_TOTAL_SCRIPT_COUNT,OBJECT_NAME]));
             graphics_check(llList2String(TempList, x),llList2Integer(details,0)); 
             if (~llListFindList(whitelist,[llList2String(TempList, x)])){ }else
             {
             if((integer)llList2String(details,0)> streaminglimit)
             {
             if (~llListFindList(only_once1,[llList2String(TempList, x)+"|"+llList2String(details,0)])){ }else
             {    
             only_once1 += llList2String(TempList, x)+"|"+llList2String(details,0);
             message("secondlife:///app/agent/"+llList2String(TempList, x)+"/about"+" [ HIGH STREAMING_COST > "+(string)llList2Integer(details,0)+" ]");

             llMessageLinked(2, 0,
             "Name : "+llList2String(details,2)+"\n"+
             "Uuid : "+llList2String(TempList, x)+"\n"+
             "HIGH STREAMING_COST > "+(string)llList2Integer(details,0)+"\n"+
             "Posted <t:"+(string)llGetUnixTime()+":R>","");

             llMessageLinked(3, 0,"[ Name "+llList2String(details,2)+" ]"+"[ Uuid "+llList2String(TempList,x)+" ]"+
             "[ HIGH STREAMING_COST > "+(string)llList2Integer(details,0)+" ]","");
             llRegionSay(relay,"kick|"+llList2String(TempList, x));           
} } } } } }
script_agentleft() 
{    
    integer Length = llGetListLength(only_once0);     
    if (!Length){ return; }else
    {
               integer x;
               for ( ; x < Length; x += 1)
               {  
               list items = llParseString2List(llList2String(only_once0,x), ["|"], []);
               vector agent = llGetAgentSize(llList2String(items,0));
               if(agent){ }else
               { 
               integer r = llListFindList(only_once0,[llList2String(only_once0,x)]);
               only_once0 = llDeleteSubList(only_once0, r,r);                
} } } }
script_check(key id,integer value)
{
    integer Length = llGetListLength(only_once0);     
    if (!Length){ return; }else
    {
          integer x;
          for ( ; x < Length; x += 1)
          { 
          list items = llParseString2List(llList2String(only_once0,x), ["|"], []);
          if(id == llList2String(items,0))
          {
          if(value == llList2Integer(items,1)){ }else
          {
          integer r = llListFindList(only_once0,[llList2String(only_once0,x)]); 
          only_once0 = llDeleteSubList(only_once0,r,r);
} } } } }
script() 
{       
        script_agentleft();
        list TempList = llGetAgentList(flag, []);
        integer Length= llGetListLength(TempList);     
        if (!Length){ return; }else
        {
             integer x;
             for ( ; x < Length; x += 1)
             {   
             list details = llGetObjectDetails(llList2String(TempList, x), ([OBJECT_STREAMING_COST,OBJECT_TOTAL_SCRIPT_COUNT,OBJECT_NAME]));
             script_check(llList2String(TempList, x),llList2Integer(details,1)); 
             if (~llListFindList(whitelist,[llList2String(TempList, x)])){ }else
             {
             if((integer)llList2String(details,1)> scriptlimit)
             {
             if (~llListFindList(only_once0,[llList2String(TempList, x)+"|"+llList2String(details,1)])){ }else
             {
             only_once0 += llList2String(TempList, x)+"|"+llList2String(details,1);
             message("secondlife:///app/agent/"+llList2String(TempList, x)+"/about"+" [ HIGH SCRIPT_COUNT > "+(string)llList2Integer(details,1)+" ]");

             llMessageLinked(2, 0,
             "Name : "+llList2String(details,2)+"\n"+
             "Uuid : "+llList2String(TempList, x)+"\n"+
             "HIGH SCRIPT_COUNT > "+(string)llList2Integer(details,1)+"|"+
             "Posted <t:"+(string)llGetUnixTime()+":R>","");

             llMessageLinked(3, 0,"[ Name "+llList2String(details,2)+" ]"+"[ Uuid "+llList2String(TempList,x)+" ]"+
             "[ HIGH SCRIPT_COUNT > "+(string)llList2Integer(details,1)+" ]","");
             llRegionSay(relay,"kick|"+llList2String(TempList, x));
} } } } } }
default
{
    changed(integer change)
    {
      if (change & CHANGED_REGION_START)         
      {
      llResetScript();    
      }
    } 
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry()
    {
    llSetTimerEvent(event_timer);  
    }
    timer()
    {   
    graphics();
    script();
    }
}