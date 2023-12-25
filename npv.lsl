list animations_stand 
=[
"stand0",
"stand1",
"stand2",
"stand3",
"stand4",
"stand5",
"stand6",
"stand7",
"stand8",
"stand9",
"stand10"
];

list animations
=[
"Flying Down",
"Flying Up",
"Walk",
"turning_left",
"turning_right"
];

rotation gPointerRot;

vector avoid_offset = <0,20,0>;
vector movementDirection;
vector avatar_offset;
vector gPointerPos;

integer target_confirm = FALSE;
integer switch_mode = FALSE;
integer permission = FALSE;
integer avoid_mode = FALSE;
integer rotationDirection;
integer ichannel = 10909;
integer chanhandlr;
integer a = FALSE;

float timelim = 200;
float speed_rot = 0.02;
float speed_Pos = 0.2;
float event_timer = .01;
float coune;

key target;
key agent;

string message_startup 
="\n
[ W+S+E = increase speed ]\n
[ W+S+C = reset speed ]\n
[ E+C+W = deflection ]\n
[ W+S = follower ]\n
[ E+C = off sim mode ]\n
[ A+D = teleport by look at ]
";

random()
{
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, "");
}
list CastDaRay(vector start, rotation direction)
{
list results = llCastRay(start,start+<255.0,0.0,0.0>*direction,
[RC_REJECT_TYPES, RC_REJECT_AGENTS,RC_DETECT_PHANTOM,TRUE,
RC_DATA_FLAGS,RC_GET_NORMAL,RC_MAX_HITS,1]);
return results;
}
stop_animation() 
{    
if(permission == TRUE)
{
integer Lengthx = llGetListLength(animations);
integer x;
for ( ; x < Lengthx; x += 1){llStopAnimation(llList2String(animations, x));}
} 
integer Lengthx = llGetListLength(animations_stand);
integer x;
for ( ; x < Lengthx; x += 1){llStopAnimation(llList2String(animations_stand, x));}       
}
runtime()
{ 
    if(avoid_mode == TRUE){if(switch_mode == FALSE){switch_mode = TRUE; gPointerPos = avoid_offset;return;}}
    if(switch_mode == FALSE)
    {
    list od = llGetObjectDetails(llGetKey(), [OBJECT_POS, OBJECT_ROT]);
    gPointerPos = llList2Vector(od, 0);gPointerRot = llList2Rot(od, 1);     
    gPointerPos += movementDirection * speed_Pos * 1 * gPointerRot;
    gPointerRot = llEuler2Rot(llRot2Euler(gPointerRot) + <0.0, 0.0, rotationDirection * speed_rot * PI>);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION,gPointerPos,PRIM_ROTATION,gPointerRot]);
    }else{
    gPointerPos += movementDirection * speed_Pos * 1 * gPointerRot;  
    gPointerRot = llEuler2Rot(llRot2Euler(gPointerRot) + <0.0, 0.0, rotationDirection * speed_rot * PI>);
    llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,gPointerPos,PRIM_ROT_LOCAL,gPointerRot]);
}   } 
reset()
{
llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,avatar_offset]);
llTargetOmega(<0,0,0>,TWO_PI,0);
llSleep(1);  
llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROTATION,<0,0,0,0>]); 
}
avoid()
{
llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROTATION,<0,0,0,0>]); 
llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,<0,0,0>]);
llSleep(1); 
llTargetOmega(<0,0,.5>,TWO_PI,1.0);
llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,avoid_offset]);
llSleep(1);
if(target_confirm == FALSE){llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION,gPointerPos-avoid_offset]);}
llTargetOmega(<0,0,0>,TWO_PI,0);
}
follower()
{
  if(target_confirm == TRUE)
  {  
    list a = llGetObjectDetails(target, ([OBJECT_POS,OBJECT_PRIM_COUNT]));   
    if(llList2Integer(a,1) == 0){ }else
    {
    if(avoid_mode == TRUE){vector ovF = gPointerPos; llSetRegionPos((llList2Vector(a,0)-(<ovF.x,ovF.y,0>*llGetLocalRot())));}     
    if(avoid_mode == FALSE){llSetRegionPos(llList2Vector(a,0));} 
} } }
pilot()
{
  a = FALSE;  
  integer objectPrimCount = llGetObjectPrimCount(llGetKey());
  integer currentLinkNumber = llGetNumberOfPrims();
  for (; objectPrimCount < currentLinkNumber; --currentLinkNumber)
  {
  if(llGetLinkKey(currentLinkNumber)==agent){a = TRUE;}else{llUnSit(llGetLinkKey(currentLinkNumber));}
  }
  if(a == TRUE){coune = 0;return;}
  if(a == FALSE){if(coune>timelim){llDie();}else{coune = coune + 1;}}
}
default
{
    on_rez(integer start_param)
    {
    llResetScript();
    }
    state_entry()
    {
    llSitTarget(<0,1,0>,llGetLocalRot());
    llSetAlpha(1, ALL_SIDES);
    llVolumeDetect(TRUE);
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TAKE_CONTROLS)
        {
        vector  size = llGetAgentSize(agent)*0.65;    
        llSetCameraParams([CAMERA_ACTIVE,TRUE,CAMERA_BEHINDNESS_ANGLE,5.0,CAMERA_BEHINDNESS_LAG,0.1,CAMERA_DISTANCE,7.0,
        CAMERA_FOCUS_LAG,0.0,CAMERA_FOCUS_OFFSET,<0.0,0.0,1.0>,CAMERA_FOCUS_THRESHOLD,0.5,CAMERA_PITCH,5.0]);
        llTakeControls(CONTROL_BACK|CONTROL_FWD|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_DOWN|CONTROL_UP,TRUE,FALSE);
        llRegionSayTo(agent,0,message_startup);
        avatar_offset = <0,0,size.z>;      
        llStopAnimation("sit");
        llSetAlpha(0, ALL_SIDES);
        llSetScale(<0,0,0>);
        permission = TRUE;
        stop_animation();
        llStartAnimation(llList2String(animations_stand,(integer)llFrand(llGetListLength(animations_stand))));
        llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,avatar_offset]);
        llSetTimerEvent(event_timer);  
        }
    }
    changed(integer change)
    { 
    if(permission == FALSE){if (change & CHANGED_LINK)
    {
       agent = llAvatarOnSitTarget();
       if (agent)
       {
       llRequestPermissions(agent,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION
       | PERMISSION_CONTROL_CAMERA |  PERMISSION_TRACK_CAMERA);
    }}}}
    listen(integer c,string n, key i, string m)
    {
      if(llGetOwnerKey(i)==agent)
      {
      if((key)m){target_confirm = TRUE; target = m;}
      if(avoid_mode == TRUE){gPointerPos = avoid_offset;}
      if(avoid_mode == FALSE){llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,avatar_offset]);}
      }  
    }
    control(key name, integer levels, integer edges)
    {
      movementDirection = ZERO_VECTOR;
      rotationDirection = 0;
      if(levels == 49) 
      {
        if(avoid_mode == TRUE)
        {
        stop_animation();
        llStartAnimation(llList2String(animations_stand,(integer)llFrand(llGetListLength(animations_stand))));   
        llRegionSayTo(agent,0,"exiting deflection mode"); 
        switch_mode = FALSE;
        avoid_mode = FALSE;
        reset();llSleep(1);
        }else{
        stop_animation();
        llStartAnimation(llList2String(animations_stand,(integer)llFrand(llGetListLength(animations_stand))));  
        llRegionSayTo(agent,0,"starting deflection mode"); 
        avoid_mode = TRUE; 
        avoid();llSleep(1);
        }return;
      }
      rotationDirection = 0;
      if(levels == 768) 
      {
        list results = CastDaRay(llGetCameraPos(), llGetCameraRot());
        vector hit_pos = llList2Vector(results, 1);
        if(hit_pos != ZERO_VECTOR)
        {
        llSetRegionPos(hit_pos);
        }return;
      }
      if(levels == 48) 
      {
         if(switch_mode == FALSE)
         {
         switch_mode = TRUE;
         llRegionSayTo(agent,0,"off sim mode");
         gPointerPos = avatar_offset;
         llSleep(1);
         return;
         }else{
         llSetLinkPrimitiveParamsFast(2, [PRIM_POS_LOCAL,avatar_offset]);
         llRegionSayTo(agent,0,"normal mode");
         switch_mode = FALSE;
         avoid_mode = FALSE;
         llSleep(1);
         }return;
      }  
      if(levels == 3) 
      { 
         if(target_confirm == FALSE)
         {
         random(); llTextBox(agent,"enter uuid",ichannel);
         llSleep(1);
         }else{
         target_confirm = FALSE;
         target = "";
         llSleep(1);
         }return;
      }
      if(levels == 19)
      {
        speed_Pos = speed_Pos+1;llRegionSayTo(agent,0,"set speed "+(string)speed_Pos);llSleep(0.2);return;
      }
      if(levels == 35)
      {
        speed_Pos =0.2;llRegionSayTo(agent,0,"reset speed");llSleep(0.2);return;
      }
      if(~levels & edges)
      {
        stop_animation();
        llStartAnimation(llList2String(animations_stand,(integer)llFrand(llGetListLength(animations_stand))));
        llSetLinkPrimitiveParamsFast(2, [PRIM_ROT_LOCAL,llEuler2Rot(<0 * DEG_TO_RAD,0* DEG_TO_RAD,0 * DEG_TO_RAD>)]);
        return;
      }
      if(levels & CONTROL_BACK)
      {
        movementDirection.x--; llStartAnimation("Walk");
        if(switch_mode == FALSE){llSetLinkPrimitiveParamsFast(2, [PRIM_ROT_LOCAL,llEuler2Rot(<0 * DEG_TO_RAD,0* DEG_TO_RAD, 180.0000 * DEG_TO_RAD>)]);}
        return;
      }
      if(levels & CONTROL_FWD){movementDirection.x++; llStartAnimation("Walk");}
      if(levels & CONTROL_DOWN){movementDirection.z--; llStartAnimation("Flying Down");}
      if(levels & CONTROL_UP){movementDirection.z++; llStartAnimation("Flying Up");}
      if(levels & CONTROL_LEFT){rotationDirection++; llStartAnimation("turning_left");}
      if(levels & CONTROL_RIGHT){rotationDirection--; llStartAnimation("turning_right");}
      if(levels & CONTROL_ROT_LEFT){rotationDirection++; llStartAnimation("turning_left");}
      if(levels & CONTROL_ROT_RIGHT){rotationDirection--; llStartAnimation("turning_right");}    
      } 
      timer()
      {
        if(permission == TRUE)
        {
        pilot();
        follower();
        runtime();
    } } }
