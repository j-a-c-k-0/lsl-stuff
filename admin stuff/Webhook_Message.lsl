string WEBHOOK_URL = "XXXX";
integer webhook_message = FALSE;
integer message_mode = 2;

message_mode1(string Message)
{
key http_request_id = llHTTPRequest(WEBHOOK_URL,[HTTP_METHOD,"POST",HTTP_MIMETYPE,
"application/json",HTTP_VERIFY_CERT, TRUE,HTTP_VERBOSE_THROTTLE,TRUE,
HTTP_PRAGMA_NO_CACHE,TRUE],llList2Json(JSON_OBJECT,
["username",llGetRegionName()+"","content",Message]));
}
message_mode2(key AvatarID,string Message,string name,string description) 
{
list json =[
"username",llGetRegionName()+"","embeds", llList2Json(JSON_ARRAY,[
llList2Json(JSON_OBJECT,["color","16711680","title",name,
"description",description,"url","https://world.secondlife.com/resident/" + (string)AvatarID,
"author",llList2Json(JSON_OBJECT,["name",Message,"",""]),
"footer",llList2Json(JSON_OBJECT,["",""])])]),"",""];
key http_request_id = llHTTPRequest(WEBHOOK_URL,[HTTP_METHOD,"POST",HTTP_MIMETYPE,
"application/json",HTTP_VERIFY_CERT, TRUE,HTTP_VERBOSE_THROTTLE,TRUE,
HTTP_PRAGMA_NO_CACHE,TRUE],llList2Json(JSON_OBJECT,json));
}
Message(string id,integer count,string name) 
{
  if(webhook_message == FALSE) { return; }
  if(message_mode == 1)
  {
  message_mode1("Name : "+name+"\n"+"Uuid : "+id+"\n"+"HighRezzCount : "+(string)count+"\n"+"Posted : <t:"+(string)llGetUnixTime()+":R>");
  }
  if(message_mode == 2)
  {
  message_mode2(id,"HIGH REZZ_COUNT > "+(string)count,name,"Uuid : "+id+"\n"+"Posted : <t:"+(string)llGetUnixTime()+":R>"); 
} }
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
    link_message(integer sender_num, integer num, string msg, key id)
    {
    list items = llParseString2List(msg, ["|"], []);
    Message(llList2Key(items,0),llList2Integer(items,1),llList2String(items,2));
  } }