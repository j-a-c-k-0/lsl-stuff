length_mode_sound(float a,string b){if((key)b){if(a>56){llLoopSound(b,(float)llGetObjectDesc());}else{llPlaySound(b,(float)llGetObjectDesc());}}else{llStopSound();}}
check_valid_uuid(string A){if((key)A){llLoopSound(A,(float)llGetObjectDesc());}else{llStopSound();}}
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
  if(llList2String(items,0) == "shutdown_sound"){llPlaySound(llList2String(items,1),(float)llGetObjectDesc());}
  if(llList2String(items,0) == "volume_change"){llAdjustSoundVolume(llList2Float(items,1));}
  if(llList2String(items,0) == "play_long"){length_mode_sound(llList2Float(items,2),llList2String(items,1));}
  if(llList2String(items,0) == "play"){check_valid_uuid(llList2String(items,1));}
  if(str == "stop"){llStopSound();}
} }
