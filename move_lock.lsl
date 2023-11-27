integer power=1;
integer collision_break;
integer toggle = 1;
float strength = 0x7FFFFFFF;
float event_run = 0.001;
string region;
vector tpos;
texture(integer tog)
{
    if(tog)
    {
    toggle=1; llOwnerSay("ON");
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE,0,"ce043f3a-dca1-19ef-da7d-a1cda751bfaa",<0.5,1,0>,<0.75,0,0>,90*DEG_TO_RAD]);
    }
    else
    {
    toggle=0; llOwnerSay("OFF");
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE,0,"ce043f3a-dca1-19ef-da7d-a1cda751bfaa",<0.5,1,0>,<0.25,0,0>,90*DEG_TO_RAD]);
    }set_position(toggle); 
}
set_position(integer on)
{
if(on){ llStopMoveToTarget(); tpos=llGetPos()+(llGetAgentSize(llGetOwner())*.01); llMoveToTarget(tpos,0.05); llSetTimerEvent(event_run); }
if(!on){ llMoveToTarget(tpos+<0,0,0>,0); llSetTimerEvent(0); }
}
teleport_position()
{
llSetTimerEvent(0);
set_position(toggle);
}
default
{
    on_rez(integer rez)
    {
    llResetScript();
    }
    state_entry()
    {
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
       if (PERMISSION_TAKE_CONTROLS & perm)
       {
       llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXTURE,0,"ce043f3a-dca1-19ef-da7d-a1cda751bfaa",<0.5,1,0>,<0.75,0,0>,90*DEG_TO_RAD]);
       toggle=1; llTakeControls(63,TRUE,TRUE); set_position(1);
    }  }
    touch_start(integer total_number)
    {
    if (llDetectedKey(0) == llGetOwner()){ power = !power; texture(power); }  
    }
    control(key id,integer held,integer change)
    {
      integer ifoo; 
      if(change) 
      {
      if(!held){ ifoo=1; } if(held){ ifoo=0; } if(toggle){ set_position(ifoo); }
    } }
    changed(integer cng)
    {
      if(cng&CHANGED_REGION){if(llVecDist(llGetPos(),tpos) > 5){ teleport_position(); }}
      if(cng&CHANGED_TELEPORT)
      {
      if(cng&CHANGED_REGION){teleport_position();}
      if(region!=llGetRegionName()){ teleport_position(); set_position(FALSE); set_position(toggle); }
    } }
    collision(integer num)
    {   
      if(collision_break==TRUE)if(llVecDist(llGetPos(),tpos)>1)
      {
        if(llDetectedType(0)&PASSIVE|llDetectedType(0)&SCRIPTED) 
        { 
        llSetTimerEvent(0);
        llSetForce(strength*llVecNorm(tpos-llGetPos()),FALSE);
        llMoveToTarget(llGetPos()+(llVecNorm(((llDetectedPos(0)-llGetPos())))*30),0.05);
        llSetTimerEvent(event_run); 
    } } }
    timer()
    {
        if(llGetAgentInfo(llGetOwner())&AGENT_SITTING){teleport_position();}
        if(toggle)
        {
        if(llVecDist(llGetPos(),tpos)>4){ collision_break=TRUE; llSetForce(strength*llVecNorm(tpos-llGetPos()),FALSE); }
        if(llVecDist(llGetPos(),tpos)<=4){ collision_break=FALSE; llSetForce(<0,0,0>,FALSE); }
        if(llVecDist(llGetPos(),tpos)<=5){ llMoveToTarget(tpos,.05); }
        if(llVecDist(llGetPos(),tpos)>5){ llMoveToTarget(llGetPos()+(llVecNorm(tpos-llGetPos())*59),0.05); }
    } } }
