string WEBHOOK_URL = "XXXX";
integer flag = AGENT_LIST_REGION;
integer message_mode = 2; //1,2
integer r;
integer E = 3;
integer D = 86400;
integer C = 43200;
integer H = 3600;
integer M = 60;

list uuid;

list known_list = [""];

list send_message_list = [""];

string agent(string A)
{
if (~llListFindList(known_list,[A]))return"100000";
return"16744448";
}
send_message2(key AvatarID,string Message,string name,string description,string cho_color) 
{
list json =[ 
"username",llGetRegionName()+"","embeds", llList2Json(JSON_ARRAY,[
llList2Json(JSON_OBJECT,["color",cho_color,"title",name,
"description",description,"url","https://world.secondlife.com/resident/" + (string)AvatarID,
"author",llList2Json(JSON_OBJECT,["name",Message,"",""]),
"footer",llList2Json(JSON_OBJECT,["",""])])]),"",""];
key http_request_id = llHTTPRequest(WEBHOOK_URL,[HTTP_METHOD,"POST",HTTP_MIMETYPE,
"application/json",HTTP_VERIFY_CERT, TRUE,HTTP_VERBOSE_THROTTLE,TRUE,
HTTP_PRAGMA_NO_CACHE,TRUE],llList2Json(JSON_OBJECT,json));
}
send_message1(string Message)
{
key http_request_id = llHTTPRequest(WEBHOOK_URL,[HTTP_METHOD,"POST",HTTP_MIMETYPE,
"application/json",HTTP_VERIFY_CERT, TRUE,HTTP_VERBOSE_THROTTLE,TRUE,
HTTP_PRAGMA_NO_CACHE,TRUE],llList2Json(JSON_OBJECT,
["username",llGetRegionName()+"","content",Message]));
}
send_message(string message) 
{    
integer LengtX= llGetListLength(send_message_list);
if (!LengtX){return;}else{integer x;for ( ; x < LengtX; x += 1){  
if((key)llList2String(send_message_list, x)){
vector agent = llGetAgentSize(llList2String(send_message_list, x));
if(agent){ 
llRegionSayTo(llList2String(send_message_list, x),0,message);
}}}}}
string getTime(integer secs)
{
string timeStr;integer days;integer hours;integer minutes;
if (secs>=86400){days=llFloor(secs/86400);secs=secs%86400;timeStr+=(string)days+" day";if (days>1) {timeStr+="s";}if(secs>0) {timeStr+=", ";}}
if(secs>=3600){hours=llFloor(secs/3600);secs=secs%3600;timeStr+=(string)hours+" hour";if(hours!=1){timeStr+="s";}if(secs>0){timeStr+=", ";}}
if(secs>=60){minutes=llFloor(secs/60);secs=secs%60;timeStr+=(string)minutes+" minute";if(minutes!=1){timeStr+="s";}if(secs>0){timeStr+=", ";}}
if (secs>0){timeStr+=(string)secs+" second";if(secs!=1){timeStr+="s";}}
return timeStr;
}
agententer() 
{
list List = llGetAgentList(flag, []);
integer Length= llGetListLength(List);     
if (!Length){return;}else{integer x;for ( ; x < Length; x += 1){  
if (!~llListFindList(uuid, [llList2String(List, x)])){
send_message("secondlife:///app/agent/"+llList2String(List, x)+"/about"+" has entered the sim");    
list details = llGetObjectDetails(llList2String(List, x), ([OBJECT_NAME,OBJECT_POS]));
vector ovF = llList2Vector(details, 1); float a = ovF.x; float b = ovF.y; float c = ovF.z;
string position = "("+ (string)((integer)a)+", "+(string)((integer)b)+", "+(string)((integer)c)+")";
if("mode_"+(string)message_mode == "mode_2"){  
send_message2(
llList2String(List, x),
"has entered the sim",
llList2String(details, 0),
"Spawn Position : "+position+"\n"+"Posted : <t:"+(string)llGetUnixTime()+":R>",
agent(llList2String(List, x)));}
uuid += (list) llList2String(List, x)+[llList2String(details,0)+"|"+(string)llGetUnixTime()+"|"+position];}else{ 
}}}}
agentleft() 
{   
integer Length= llGetListLength(uuid);
if (!Length){return;}else{integer x;for ( ; x < Length; x += 1){  if((key)llList2String(uuid, x)){
vector agent = llGetAgentSize(llList2String(uuid, x));if(agent){ }else{ 
r = llListFindList(uuid,[llList2String(uuid, x)]);
list items = llParseString2List(llList2String(uuid, 1+r), ["|"], []);
send_message("secondlife:///app/agent/"+llList2String(uuid, x)+"/about"+" has left the sim");
integer time = (integer)llGetUnixTime() - llList2Integer(items,1);
//llMessageLinked(2, 0,"[ Name "+llList2String(items,0)+" ]"+"[ Uuid "+llList2String(uuid, x)+" ]"+"[ Visit Time "+getTime(time)+" ]","");
if("mode_"+(string)message_mode == "mode_1"){    
send_message1(
"Name : "+llList2String(items,0)+"\n"+
"Uuid : "+llList2String(uuid, x)+"\n"+
"Spawn Position : "+llList2String(items,2)+"\n"+
"Visit Time : "+getTime(time)+"\n"+
"Posted : <t:"+(string)llGetUnixTime()+":R>");} 
if("mode_"+(string)message_mode == "mode_2"){
send_message2(
llList2String(uuid, x),
"has left the sim",
llList2String(items,0),
"Visit Time : "+getTime(time)+"\n"+"Posted : <t:"+(string)llGetUnixTime()+":R>",
agent(llList2String(uuid, x)));}uuid = llDeleteSubList(uuid, r,1+r);
}}}}}
default
{
    changed(integer change)
    {
    if (change & CHANGED_REGION_START){llResetScript();}
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry()
    {
    llSetTimerEvent(E);
    }
    timer()
    {
    agententer(); 
    agentleft();
    }
  }