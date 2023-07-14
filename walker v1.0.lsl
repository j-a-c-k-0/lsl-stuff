float trigger_time = 1;
float T_event = 0.1;
float input = 0.1;
float value;
sound_increase()
{   
   llLoopSound(llGetInventoryName(INVENTORY_SOUND,llFloor(llFrand(llGetInventoryNumber(INVENTORY_SOUND)))),0);
   float i=0;
   for (i=0; i<1; i+=input) 
   {
   if(llGetAgentInfo(llGetOwner()) & AGENT_WALKING){value=i; llAdjustSoundVolume(i);}else{llAdjustSoundVolume(0);return;}    
   }
}
sound_reduce()
{
   float i=0;
   for (i=0; i<value; i+=input) 
   {
   llAdjustSoundVolume(value-i);   
   }
   llStopSound();
}
default 
{  
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry() 
    {
    llStopSound();
    llSetTimerEvent(trigger_time);
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
    if (PERMISSION_TAKE_CONTROLS& perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );} 
    }
    timer()
    { 
        if(llGetAgentInfo(llGetOwner()) & AGENT_WALKING)
        {  
        llSetTimerEvent(0);
        sound_increase();
        state stop_loop;
        }
    }
}
state stop_loop
{
        state_entry()
        { 
        llSetTimerEvent(T_event); 
        llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);   
        } 
        run_time_permissions(integer perm)
        {
        if (PERMISSION_TAKE_CONTROLS& perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );} 
        }             
        timer()
        {
        if(llGetAgentInfo(llGetOwner()) & AGENT_WALKING){}else 
        {
        llSetTimerEvent(0);
        sound_reduce();
        state default;
        }
    }
}