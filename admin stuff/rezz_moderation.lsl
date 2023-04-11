list users =[""];
list temp_whitelist;
list whitelist;

integer dialog_channel = 1;
integer rely_channel = 2;
string encryption_password = "12";
key owner = "XXXX";

integer rezzwarning = 1000;
integer rezzlimit = 2000;
float banned_time_hour = 1.0;

string WEBHOOK_URL = "XXXX";
integer webhook_message = TRUE;
integer message_mode = 2;

integer safe_fail_trigger = TRUE;
integer event_time = 3;
integer notecardLine;
integer chanhandlr;
string notecardName = "whitelist";
string ReturnObjectByAgentAbsence;
string ReturnObjectByRezzCount;
string error_message;
string memory_result;
key notecardQueryId;
key notecardKey;

ReadNotecard()
{
    if (llGetInventoryKey(notecardName) == NULL_KEY)
    {
    llSetTimerEvent(0);   
    safe_fail_trigger = TRUE;
    error_message = "notecard_exception";     
    llSetText("Notecard '" + notecardName + "' missing or unwritten.",<1,0,0>,1);
    return;
    }
    else if (llGetInventoryKey(notecardName) == notecardKey) return;
    notecardKey = llGetInventoryKey(notecardName);
    notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
    llSetText("reading notecard...",<1,0,1>,1); 
}


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
string get_username(key id)
{
list details = llGetObjectDetails(id, ([OBJECT_NAME])); 
vector agent = llGetAgentSize(id);
if(agent){ return llList2String(details,0); }else{ return id;} 
}
rezz_limiter(key id,integer count,string crypt) 
{ 
    if(count> rezzwarning && (integer)count< rezzlimit )
    {
    llRegionSay(rely_channel,crypt); 
    llInstantMessage(id,"Warning Don't go rezz over "+(string)rezzwarning); 
    }
    if((integer)count> rezzlimit)
    {
    llRegionSay(rely_channel,crypt);
    llInstantMessage(id,"You had been banned for "+(string)((integer)banned_time_hour)+" hour Reason [ Rezzcount > "+(string)count+" ]");
    llTeleportAgentHome(id);
    llAddToLandBanList(id,banned_time_hour);
    if(webhook_message == FALSE) 
    {
    return;
    }
    if(message_mode == 1)
    {
    message_mode1(
    "Name : "+get_username(id)+"\n"+
    "Uuid : "+(string)id+"\n"+
    "HighRezzCount : "+(string)count+"\n"+
    "Posted : <t:"+(string)llGetUnixTime()+":R>");
    }
    if(message_mode == 2)
    {
    message_mode2(id,"HIGH REZZ_COUNT > "+(string)count,get_username(id),"Posted : <t:"+(string)llGetUnixTime()+":R>"); 
    }
  }
}
Object_Moderation() 
{    
  list TempList = llGetParcelPrimOwners(llGetPos()); 
  integer Length = llGetListLength(TempList); if (!Length){ return; }else
  {
    integer z; for ( ; z < Length; z += 2)
    {
      if (~llListFindList(whitelist,[llList2String(TempList, z)])){ }else
      {       
        if (~llListFindList(temp_whitelist,[llList2String(TempList, z)])){ }else
        {
          string crypt = llXorBase64(llStringToBase64("return_object_by_owner"+"|"+llList2String(TempList, z)),llStringToBase64(encryption_password)); 
          if(ReturnObjectByRezzCount == "active")
          {
          rezz_limiter(llList2Key(TempList,z),llList2Integer(TempList,z+1),crypt);
          }          
          vector agent = llGetAgentSize(llList2String(TempList,z));
          if(agent){ }else
          {
            if(ReturnObjectByAgentAbsence == "active")
            {
            llRegionSay(rely_channel,crypt);
            }
          }
        }
      }
    }
  }
}
random_channel() 
{
dialog_channel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); 
chanhandlr = llListen(dialog_channel, "", NULL_KEY, "");
}
show_dialog(key id)
{
random_channel();
llDialog(id,"memory : "+memory_result+"\n\n"+
"[1] ReturnObjectByAgentAbsence Status : " + ReturnObjectByAgentAbsence
+"\n"+
"[2] ReturnObjectByRezzCount Status : " + ReturnObjectByRezzCount
,["[1] on/off","[2] on/off","add-temp","close"," ","erase-temp"], dialog_channel);
llSleep(.2);
}
status_startup() 
{
list target0 =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
if("1"== llList2String(target0,0)){ ReturnObjectByAgentAbsence = "active"; }else{ ReturnObjectByAgentAbsence = "deactivate";}
list target1 =llGetLinkPrimitiveParams(3,[PRIM_DESC]);
if("1"== llList2String(target1,0)) { ReturnObjectByRezzCount = "active"; }else{ ReturnObjectByRezzCount = "deactivate"; }
}
default
{
    changed(integer change)
    {
       if (change & CHANGED_REGION_START)
       {
       temp_whitelist = [];
       return;
       }
       if (change & CHANGED_INVENTORY)
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
    llSetText("",<0,0,0>,0);     
    ReadNotecard();
    } 
    touch_start(integer num_detected)
    {
    if (~llListFindList(users,[(string)llDetectedKey(0)]))
    {
        if(safe_fail_trigger == FALSE) 
        {   
        show_dialog(llDetectedKey(0)); 
        return;
        }
        else
        {
        llDialog(llDetectedKey(0),"\n"+error_message+"\n",["error :("], dialog_channel);
        llSleep(.2);
        return;
        }
    }
}
listen(integer channel, string name, key id, string message)
{
if(safe_fail_trigger == FALSE) 
{  
    if(llGetOwnerKey(id)==owner){ if(message == "safe_fail")
    {
    error_message ="safe_fail_trigger";     
    safe_fail_trigger = TRUE;
    llSetTimerEvent(0);
    llSetText("safe_fail_trigger",<1,0,0>,1);
    }
  }
  if (~llListFindList(users,[(string)id]))
  {
      if(message == " "){ show_dialog(id); return; }
      if(message == "close"){ return; }
      if(message == "erase-temp")
      {
      temp_whitelist = [];    
      show_dialog(id); 
      return;
      } 
      if(message == "[1] on/off")
      {
        if(ReturnObjectByAgentAbsence == "deactivate")
        {
        llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,"1"]);   
        ReturnObjectByAgentAbsence = "active";
        }
        else
        {
        llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,"0"]); 
        ReturnObjectByAgentAbsence = "deactivate";
        }
        show_dialog(id); 
        return;
      }   
      if(message == "[2] on/off")
      {
        if(ReturnObjectByRezzCount == "deactivate")
        {
        llSetLinkPrimitiveParamsFast(3,[PRIM_DESC,"1"]); 
        ReturnObjectByRezzCount = "active";
        }
        else
        {
        llSetLinkPrimitiveParamsFast(3,[PRIM_DESC,"0"]);   
        ReturnObjectByRezzCount = "deactivate";
        }
        show_dialog(id); 
        return;
      } 
      if(message == "add-temp")
      {
      llTextBox(id, "Please insert a uuid to be added."+"\n"+"\n"+
      "please be aware this is only temporary.", dialog_channel);
      return;
      }
      if((key)message)
      {
         if (!~llListFindList(temp_whitelist, [message]))
         {
         llRegionSayTo(id,0,"secondlife:///app/agent/"+message+"/about"+" added"); temp_whitelist += message;
         show_dialog(id);
         return;
         }
         else
         {
         llTextBox(id,"\n"+"\n"+"uuid already existed.", dialog_channel);
         }
      }
      else
      {
      llTextBox(id,"\n"+"\n"+"invalid uuid.", dialog_channel);
      }
    }
  }
}
dataserver(key query_id, string data)
{
        if (query_id == notecardQueryId)
        {
            if (data == EOF)
            {
            llSetText("",<0,0,0>,0);  
            memory_result =(string)llGetFreeMemory();    
            llListen(rely_channel,"","","");
            llSetTimerEvent(event_time); 
            safe_fail_trigger = FALSE;
            status_startup();
            }
            else
            {
                list params = llParseString2List(data, ["="], []);
                if((key)llList2String(params, 0))
                {
                whitelist += llList2String(params, 0); ++notecardLine;
                notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
                }
                else
                {
                llSetTimerEvent(0);
                safe_fail_trigger = TRUE;
                error_message ="invalid_uuid_configuration";
                llSetText("Invalid uuid list "+(string)(1+notecardLine)+" = "+llList2String(params, 0),<1,0,0>,1);
                return;
                }
            }
        }
    } 
    timer()
    {
    if(safe_fail_trigger == FALSE) 
    {
    memory_result =(string)llGetFreeMemory();
    Object_Moderation();
    }
  }  
}
