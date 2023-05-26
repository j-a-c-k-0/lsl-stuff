integer animated0;
integer intLine1;
string  note_name;
key keyConfigQueryhandle;
key keyConfigUUID;

integer getLinkNum(string primName)
{
integer primCount = llGetNumberOfPrims();
integer i;
for (i=0; i<primCount+1;i++){  
if (llGetLinkName(i)==primName) return i;
}
return FALSE;
}
integer readnote(string notename)
{
  note_name = notename;
  if (llGetInventoryKey(note_name) == NULL_KEY){return 0; }else
  {
  intLine1 = 0;
  keyConfigQueryhandle = llGetNotecardLine(note_name, intLine1); 
  keyConfigUUID = llGetInventoryKey(note_name);
  return 1;
  }
}
default 
{ 
    changed(integer change)
    {
    if(change & CHANGED_INVENTORY){llResetScript();}
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry() 
    {
    animated0 = getLinkNum("gif1");
    llSetLinkPrimitiveParamsFast(animated0,[PRIM_DESC,"none"]);
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );}
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    list params = llParseString2List(msg, ["|"], []);
    if(llList2String(params, 0) == "fetch_note_rationed")
    {
        string nname = llDumpList2String(llList2ListStrided(params, 1, -1, 1), " ");
        if(readnote(nname) == 0)
        {
        llOwnerSay("error could not find notecard");
    } } }
    dataserver(key keyQueryId, string strData)
    {
    if (keyQueryId == keyConfigQueryhandle)
    {
          if (strData == EOF){llSetLinkPrimitiveParamsFast(animated0,[PRIM_DESC,""]); llMessageLinked(LINK_THIS,0,"music_changed","");}else
          {
             keyConfigQueryhandle = llGetNotecardLine(note_name, ++intLine1);
             llMessageLinked(LINK_THIS,0,"upload_note|" + strData,"");
    }  }  }  }
