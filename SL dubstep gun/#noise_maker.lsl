check_valid_uuid(string A){if((key)A){ llLoopSound(A,(float)llGetObjectDesc()); }else{ llStopSound(); }}
default
{
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry()
    {
    llStopSound();
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );}
    }
    link_message(integer source, integer num, string str, key id)
    {
    list items = llParseString2List(str, ["|"], []);  
    if(str == "stop")
    { 
    llStopSound();
    }
    if(llList2String(items,0) == "play")
    { 
    check_valid_uuid(llList2String(items,1));
    }
  }
}
