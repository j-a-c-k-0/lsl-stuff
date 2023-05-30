integer music_num; 
integer speaker;
float music_timing;
float rate = 0.1;
list music_song;

integer getLinkNum(string primName)
{
integer primCount = llGetNumberOfPrims();
integer i;
for (i=0; i<primCount+1;i++){  
if (llGetLinkName(i)==primName) return i;
}
return FALSE;
}
playmusic()
{
    if (music_num < llGetListLength(music_song))
    {
    list A = llParseString2List(llList2String(music_song, music_num), ["="], []);
    music_timing = llList2Float(A,0);llMessageLinked(speaker,0,"play_long|"+llList2String(A,1)+"|"+llList2String(A,0),""); music_num += 1;
    list B = llParseString2List(llList2String(music_song, music_num), ["="], []);
    if((key)llList2String(B,1)){ llPreloadSound(llList2String(B,1));
    }else{
    llMessageLinked(LINK_THIS,0,"start_over|"+(string)music_timing,""); music_num = 0;
} } }
default
{
    on_rez(integer start_param) 
    {
    llResetScript();
    }  
    changed(integer change)
    {
    if (change & CHANGED_INVENTORY){llResetScript();}
    }
    state_entry()
    {
    speaker = getLinkNum("speaker");
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );}
    }
    timer()
    {
    llSetTimerEvent(0); playmusic(); llSetTimerEvent(music_timing);
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    list items1 = llParseString2List(msg, ["|"], []);
    if(llList2String(items1,1) == "long_clip"){music_song += llList2String(items1,2);}
    if(msg == "erase_data"){music_num = 0; llSetTimerEvent(0); music_song = [];} 
    if(msg == "long_sound_play"){music_num = 0; llSetTimerEvent(rate);}
    if(msg == "long_sound_pause"){music_num = 0; llSetTimerEvent(0);}
    if(msg == "[ Reset ]"){llResetScript();}
  } }
