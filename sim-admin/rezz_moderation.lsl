key owner = "fe61e4d8-e195-4166-a7f7-ba163964b992";
string encryption_password = "12";
string ReturnObjectByAgentAbsence;
string ReturnObjectByRezzCount;
string WEBHOOK_URL = "XXXX";
integer dialog_channel = 1;
integer rely_channel = 2;
integer rezzwarning = 1800;
integer rezzlimit = 2000;
integer event_time = 3;
integer chanhandlr;
float banned_time_hour = 1.0;
list users =[];
list temp_whitelist;
list whitelist =[];
send_log(string Message)
{
key http_request_id = llHTTPRequest(WEBHOOK_URL,[HTTP_METHOD,"POST",HTTP_MIMETYPE,
"application/json",HTTP_VERIFY_CERT, TRUE,HTTP_VERBOSE_THROTTLE,TRUE,
HTTP_PRAGMA_NO_CACHE,TRUE],llList2Json(JSON_OBJECT,
["username",llGetRegionName()+"","content",Message]));
}
rezz_limiter(key id,integer count,string crypt) 
{ 
  if(count> rezzwarning && (integer)count< rezzlimit )
  {
  llRegionSay(rely_channel,crypt); 
  llRegionSayTo(id,0,"Warning Don't go rezz over "+(string)rezzlimit); 
  }
  if((integer)count> rezzlimit)
  {
  list details = llGetObjectDetails(id, ([OBJECT_NAME]));  
  llRegionSay(rely_channel,crypt);
  llRegionSayTo(id,0,"You had been banned for "+(string)((integer)banned_time_hour)+" hour Reason [ Rezzcount > "+(string)count+" ]");
  llTeleportAgentHome(id);
  llAddToLandBanList(id,banned_time_hour);
  send_log(
  "Name : "+llList2String(details,0)+"\n"+
  "Uuid : "+(string)id+"\n"+
  "REZZCOUNT > "+(string)count+"\n"+
  "Posted <t:"+(string)llGetUnixTime()+":R>");
  }
}
Object_Moderation() 
{    
  list TempList = llGetParcelPrimOwners(llGetPos());
  integer Length = llGetListLength(TempList);
  if (!Length){ return; }else
  {
    integer z;
    for ( ; z < Length; z += 2)
    {
      if (~llListFindList(whitelist,[llList2String(TempList, z)])){ }else
      {       
        if (~llListFindList(temp_whitelist,[llList2String(TempList, z)])){ }else
        {
          string crypt = llXorBase64(llStringToBase64("return_object_by_owner"+"|"+llList2String(TempList, z)),llStringToBase64(encryption_password)); 
          vector agent = llGetAgentSize(llList2String(TempList,z));
          if(agent)
          { 
            if(ReturnObjectByRezzCount == "active")
            {
            rezz_limiter(llList2Key(TempList,z),llList2Integer(TempList,z+1),crypt);
            }
          }
          else
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
llDialog(id,"\n"+
"[1] ReturnObjectByAgentAbsence Status : " + ReturnObjectByAgentAbsence
+"\n"+
"[2] ReturnObjectByRezzCount Status : " + ReturnObjectByRezzCount
,["[1] on/off","[2] on/off","Whitelist","close"], dialog_channel);
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
       llResetScript();    
       }
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry()
    {
    random_channel();   
    llSetTimerEvent(event_time); 
    status_startup(); 
    } 
    touch_start(integer num_detected)
    {
       if (~llListFindList(users,[(string)llDetectedKey(0)]))
       {
       show_dialog(llDetectedKey(0)); 
       return;
       }
    }
    listen(integer channel, string name, key id, string message)
    {
    if (~llListFindList(users,[(string)id]))
    {
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
      if(message == "Whitelist")
      {
      random_channel();    
      llTextBox(id, "Please insert a uuid to be added."+"\n"+"\n"+
      "please be aware this is only temporary.", dialog_channel);
      return;
      }
      if((key)message)
      {
        if (!~llListFindList(temp_whitelist, [message]))
        {
        llRegionSayTo(id,0,"secondlife:///app/agent/"+message+"/about"+" added"); temp_whitelist += message;    
        llInstantMessage(owner,"secondlife:///app/agent/"+(string)id+"/about has added : " +
        "secondlife:///app/agent/"+message+"/about on whitelist"); random_channel();
        show_dialog(id);
        return;
        }
        else
        { 
        random_channel();
        llTextBox(id,"\n"+"\n"+"uuid already existed.", dialog_channel);
        }
      }
    }
  }
  timer()
  {
  Object_Moderation(); 
  }
}