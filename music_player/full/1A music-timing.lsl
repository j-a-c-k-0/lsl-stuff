integer safe_fail_trigger = FALSE;
integer music_num; 
float music_timing;
float volume = 1.0;
float rate = 0.1;
list music_song;
error_test()
{
  integer Length = llGetListLength(music_song);
  integer Y; for ( ; Y < Length; Y += 1)
  {
      list A = llParseString2List(llList2String(music_song, Y), ["="], []);
      if((key)llList2String(A,1)){ }else
      {
      safe_fail_trigger = TRUE;    
      llOwnerSay("Invalid uuid list "+(string)Y+" [ "+llList2String(A,1)+" ]"); 
      llSetTimerEvent(0);
      return;
      }
   }llSetTimerEvent(rate);
}
length_mode_sound(float a,string b)
{
if (a > 56) { llLoopSound(b,volume); }else{ llPlaySound(b,volume); }
}
playmusic()
{
   if(safe_fail_trigger == TRUE) 
   {
   llOwnerSay("could not play [ fail-safe triggered ]"); music_timing = 0; return;    
   }
   integer Length = llGetListLength(music_song);
   if (music_num < Length)
   {
   list A = llParseString2List(llList2String(music_song, music_num), ["="], []);
   music_timing = llList2Float(A,0); 
   length_mode_sound(llList2Float(A,0),llList2String(A,1)); music_num += 1;
   list B = llParseString2List(llList2String(music_song, music_num), ["="], []);
   if((key)llList2String(B,1)){ llPreloadSound(llList2String(B,1)); }else{ music_num = 0; }
   }
}
default
{
    on_rez(integer start_param) 
    {
    llResetScript();
    }  
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)         
        {
        llResetScript();
        }
    }
    state_entry()
    {   
    llStopSound();
    }
    run_time_permissions(integer perm)
    {
       if(PERMISSION_TAKE_CONTROLS & perm)
       {
       llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );
       }
    }
    timer()
    {
    llSetTimerEvent(0); playmusic(); llSetTimerEvent(music_timing);
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
        list items1 = llParseString2List(msg, ["|"], []);
        list items0 = llParseString2List(msg, ["/"], []);
        if(llList2String(items0,0) == "v")
        { 
        volume = llList2Float(items0,1); llStopSound(); llSleep(0.2); llSetTimerEvent(0.1);
        }
        if(msg == "[ Reset ]")
        {
        volume = 1.0; music_num = 0; llStopSound(); music_song = []; llSetTimerEvent(0);
        }
        if(msg == "[ Play ]")
        {
        llSetTimerEvent(0.1); 
        }
        if(msg == "[ Pause ]")
        {   
        llStopSound(); llSetTimerEvent(0);
        }
        if(msg == "erase")
        {   
        safe_fail_trigger = FALSE; music_num = 0; llStopSound(); music_song = []; llSetTimerEvent(0);
        }
        if(msg == "start")
        {   
        safe_fail_trigger = FALSE; music_num = 0; llStopSound(); llSetTimerEvent(0); error_test();
        }
        if(llList2String(items1,0) == "upload_note")
        {
        music_song += (list)[llList2String(items1,1)];
        }
    }
}
