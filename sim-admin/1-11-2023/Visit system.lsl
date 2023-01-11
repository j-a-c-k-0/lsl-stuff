integer flag = AGENT_LIST_REGION;
integer E = 3;
integer r;
list uuid;

list known_list = [""];

list send_message_list = [""];

string agent(string A)
{
if (~llListFindList(known_list,[A]))return"known_agent";  
return"unknown_agent";
}

integer D = 86400;
integer C = 43200;
integer H = 3600;
integer M = 60;
string getTime(integer secs)
{
    string timeStr;
    integer days;
    integer hours;
    integer minutes;
 
    if (secs>=86400)
    {
        days=llFloor(secs/86400);
        secs=secs%86400;
        timeStr+=(string)days+" day";
        if (days>1) 
        {
            timeStr+="s";
        }
        if(secs>0) 
        {
            timeStr+=", ";
        }
    }
    if(secs>=3600)
    {
        hours=llFloor(secs/3600);
        secs=secs%3600;
        timeStr+=(string)hours+" hour";
        if(hours!=1)
        {
            timeStr+="s";
        }
        if(secs>0)
        {
            timeStr+=", ";
        }
    }
    if(secs>=60)
    {
        minutes=llFloor(secs/60);
        secs=secs%60;
        timeStr+=(string)minutes+" minute";
        if(minutes!=1)
        {
            timeStr+="s";
        }
        if(secs>0)
        {
            timeStr+=", ";
        }
    }
    if (secs>0)
    {
        timeStr+=(string)secs+" second";
        if(secs!=1)
        {
            timeStr+="s";
        }
    }
    return timeStr;
}
send_message(string message) 
{    
        integer LengtX= llGetListLength(send_message_list);
        if (!LengtX){return;}else
        {
            integer x;
            for ( ; x < LengtX; x += 1)
            {  
            if((key)llList2String(send_message_list, x))
            {
                vector agent = llGetAgentSize(llList2String(send_message_list, x));
                if(agent)
                { 
                llRegionSayTo(llList2String(send_message_list, x),0,message);
                }      
            }
        }
    }
}
agententer() 
{
    list List = llGetAgentList(flag, []);
    integer Length= llGetListLength(List);     
    if (!Length){return;}else
    {
        integer x;
        for ( ; x < Length; x += 1)
        {  
            if (!~llListFindList(uuid, [llList2String(List, x)]))
            {
            send_message("secondlife:///app/agent/"+llList2String(List, x)+"/about"+" has entered the sim");    
            list details = llGetObjectDetails(llList2String(List, x), ([OBJECT_NAME,OBJECT_POS]));
            vector ovF = llList2Vector(details, 1); float a = ovF.x; float b = ovF.y; float c = ovF.z;
            string position = "("+ (string)((integer)a)+", "+(string)((integer)b)+", "+(string)((integer)c)+")";
            
            list target =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
            if(llList2String(target,0) == "mode_2")
            {  
            llMessageLinked(2, 0,
            llList2String(List, x)+"|"+
            "has entered the sim"+"|"+
            llList2String(details, 0)+"|"+
            "Spawn Position : "+position+"\n"+"Posted : <t:"+(string)llGetUnixTime()+":R>"+"|"+
            agent(llList2String(List, x)),"");
            }
            uuid += (list) llList2String(List, x)+[llList2String(details,0)+"|"+(string)llGetUnixTime()+"|"+position];
            }
            else
            { 

            }
        }
    }
}
agentleft() 
{    
    integer Length= llGetListLength(uuid);
    if (!Length){return;}else
    {
        integer x;
        for ( ; x < Length; x += 1)
        {  
            if((key)llList2String(uuid, x))
            {
                vector agent = llGetAgentSize(llList2String(uuid, x));
                if(agent){ }else
                { 
                r = llListFindList(uuid,[llList2String(uuid, x)]);
                list items = llParseString2List(llList2String(uuid, 1+r), ["|"], []);

                send_message("secondlife:///app/agent/"+llList2String(uuid, x)+"/about"+" has left the sim");
                integer time = (integer)llGetUnixTime() - llList2Integer(items,1);

                llMessageLinked(3, 0,"[ Name "+llList2String(items,0)+" ]"+"[ Uuid "+llList2String(uuid, x)+" ]"+"[ Visit Time "+getTime(time)+" ]","");
                
                list target =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
                if(llList2String(target,0) == "mode_1")
                {    
                llMessageLinked(2, 0,
                "Name : "+llList2String(items,0)+"\n"+
                "Uuid : "+llList2String(uuid, x)+"\n"+
                "Spawn Position : "+llList2String(items,2)+"\n"+
                "Visit Time : "+getTime(time)+"\n"+
                "Posted : <t:"+(string)llGetUnixTime()+":R>","");
                } 
                if(llList2String(target,0) == "mode_2")
                { 
                llMessageLinked(2, 0,
                llList2String(uuid, x)+"|"+
                "has left the sim"+"|"+
                llList2String(items,0)+"|"+
                "Visit Time : "+getTime(time)+"\n"+"Posted : <t:"+(string)llGetUnixTime()+":R>"+"|"+
                agent(llList2String(uuid, x)),"");
                }
                uuid = llDeleteSubList(uuid, r,1+r);
                }      
            }
        }
    }
}
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
    llSetLinkTextureAnim(LINK_THIS, ANIM_ON | LOOP, ALL_SIDES,4,2, 0, 64, 8 );    
    string region = llGetRegionName();
    llSetObjectName("["+region+"]");
    llSetTimerEvent(E);
    }
    timer()
    {
    agententer(); 
    agentleft();
    }
}
