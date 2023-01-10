string WEBHOOK_URL = "XXXX";

send_log(string Message) 
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
    string region = llGetRegionName();
    llSetObjectName("["+region+"]");
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    send_log(msg); 
    }
}