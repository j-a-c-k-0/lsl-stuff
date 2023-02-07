readnote(string animationname)
{
    if (llGetInventoryKey(animationname) == NULL_KEY)
    {
    llOwnerSay("error could not find animation");        
    return; 
    }
    llMessageLinked(LINK_THIS, 0, "play_anim|" +(string)animationname, NULL_KEY); 
    llOwnerSay("Playing [ " + animationname+" ]");
    return;
}
default 
{
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)         
        {
        llResetScript();
        }
    } 
    on_rez(integer start_param) 
    {
    llResetScript();
    }  
    run_time_permissions(integer perm)
    {
          if(PERMISSION_TAKE_CONTROLS & perm)
          {
          llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );
          }
    }
    state_entry() 
    {
    llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS); 
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(num == 0)
        {
            list params = llParseString2List(msg, ["|"], []);
            string cmd = llList2String(params, 0);
            string param1 = llList2String(params, 1);
            if(cmd == "fetch_note_rationed")
            {
            string nname = llDumpList2String(llList2ListStrided(params, 1, -1, 1), " ");
            readnote(nname);
            }
         }
      }
   }