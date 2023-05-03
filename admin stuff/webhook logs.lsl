string WEBHOOK_URL = "XXXX";
integer message_mode = 2; //1,2

string color(string A)
{
if(A == "known_agent")return"100000";
if(A == "unknown_agent")return"16744448";
if(A == "alert")return"16711680";
return"16777215";
}
send_message2(key AvatarID,string Message,string name,string description,string cho_color) 
{
list json =[ 
"username",llGetRegionName()+"","embeds", llList2Json(JSON_ARRAY,[
llList2Json(JSON_OBJECT,["color",color(cho_color),"title",name,
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
default
{
    changed(integer change)
    {
    if (change & CHANGED_REGION_START){send_message1("Region_Restart : "+llGetDate()+"\n"+"Posted : <t:"+(string)llGetUnixTime()+":R>"); llResetScript();}
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry()
    {
    llSetObjectDesc("mode_"+(string)message_mode);
    llSetObjectName("["+llGetRegionName()+"]");
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    list target =llGetLinkPrimitiveParams(LINK_THIS,[PRIM_DESC]);
    if(llList2String(target,0) == "mode_1")
    {
    send_message1(msg);
    } 
    if(llList2String(target,0) == "mode_2")
    {    
    list items = llParseString2List(msg, ["|"], []);
    send_message2(llList2Key(items,0),llList2String(items,1),llList2String(items,2),llList2String(items,3),llList2String(items,4)); 
} } }
