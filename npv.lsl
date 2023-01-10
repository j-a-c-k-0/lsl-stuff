list animations 
=[
"Flying Down",
"Flying Up",
"Walk",
"turning_left",
"turning_right"
];

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

string message_startup 
="\n
[ W+S+E = increase speed ]\n
[ W+S+C = reset speed ]\n
[ W+S = follower ]\n
[ E+C = off sim mode ]\n
[ A+D = teleport by look at ]
";

vector default_local_position = <0,0,1.5>;
vector movementDirection;
vector gPointerPos;
rotation gPointerRot;
integer target_confirm = FALSE;
integer switch_mode = FALSE;
integer permission = FALSE;
integer rotationDirection;
integer ichannel = 10909;
integer chanhandlr;
integer switch0;
float hover_offset=1;
float speed_rot=0.02;
float speed_Pos=0.2;
key target;
key agent;

list CastDaRay(vector start, rotation direction)
{
    list results = llCastRay(
        start,
        start+<255.0,0.0,0.0>*direction,
        [RC_REJECT_TYPES, RC_REJECT_AGENTS,
        RC_DETECT_PHANTOM,TRUE,
        RC_DATA_FLAGS,RC_GET_NORMAL,RC_MAX_HITS,1]);
    return results;
}
stop_animation() 
{    
    if(permission == TRUE)
    {
    integer Lengthx = llGetListLength(animations);
    integer x;
    for ( ; x < Lengthx; x += 1)
    {
      llStopAnimation(llList2String(animations, x));   
      }
    } 
    integer Lengthx = llGetListLength(animations_stand);
    integer x;
    for ( ; x < Lengthx; x += 1)
    {
    llStopAnimation(llList2String(animations_stand, x));
    }       
}
runtime()
{
    if(switch_mode == FALSE)
    {  
    list od = llGetObjectDetails(llGetKey(), [OBJECT_POS, OBJECT_ROT]);
    gPointerPos = llList2Vector(od, 0);
    gPointerRot = llList2Rot(od, 1);     
    gPointerPos += movementDirection * speed_Pos * 1 * gPointerRot;
    gPointerRot = llEuler2Rot(llRot2Euler(gPointerRot) + <0.0, 0.0, rotationDirection * speed_rot * PI>);
    llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POSITION,gPointerPos,PRIM_ROTATION,gPointerRot]);
    }
    else
    {
    gPointerPos += movementDirection * speed_Pos * 1 * gPointerRot;  
    gPointerRot = llEuler2Rot(llRot2Euler(gPointerRot) + <0.0, 0.0, rotationDirection * speed_rot * PI>);
    llSetLinkPrimitiveParamsFast(2, [PRIM_POS_LOCAL,gPointerPos,PRIM_ROT_LOCAL,gPointerRot]);
    }
}
follower()
{
    if(target_confirm == TRUE)
    {
    list details = llGetObjectDetails(target, ([OBJECT_POS]));   
    vector agent = llGetAgentSize(target);
    if(agent)
    {
    llSetRegionPos(llList2Vector(details,0));
    }
    else
    {
    target_confirm = FALSE;
    target = "";
    }
  }
}
unsit_all()
{
    integer objectPrimCount = llGetObjectPrimCount(llGetKey());
    integer currentLinkNumber = llGetNumberOfPrims();
    for (; objectPrimCount < currentLinkNumber; --currentLinkNumber)
    {
    if(llGetLinkKey(currentLinkNumber)==agent){ }else
    {
    llUnSit(llGetLinkKey(currentLinkNumber));
    }
  }    
}
float timelim = 200;
float coune;
self_destruct()
{
   if(coune>timelim)
   {
   llDie();
   }
   else
   {
   coune = coune + 1;     
   } 
}
default
{
    on_rez(integer start_param)
    {
    llResetScript();
    }
    state_entry()
    {
    llSitTarget(<0,0,hover_offset>,llGetLocalRot());
    llSetAlpha(1, ALL_SIDES);
    llVolumeDetect(TRUE);
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TAKE_CONTROLS)
        {

        llSetCameraParams(
        [
        CAMERA_ACTIVE,TRUE,
        CAMERA_BEHINDNESS_ANGLE,5.0,
        CAMERA_BEHINDNESS_LAG,0.1,
        CAMERA_DISTANCE,7.0,CAMERA_FOCUS_LAG,0.0,
        CAMERA_FOCUS_OFFSET,<0.0,0.0,1.0>,
        CAMERA_FOCUS_THRESHOLD,0.5,
        CAMERA_PITCH,5.0
        ]);

        llTakeControls(
        CONTROL_BACK |
        CONTROL_FWD |
        CONTROL_LEFT |
        CONTROL_RIGHT |
        CONTROL_ROT_LEFT |
        CONTROL_ROT_RIGHT |
        CONTROL_DOWN |
        CONTROL_UP,TRUE,
        FALSE
        );

        llRegionSayTo(agent,0,message_startup);
        llStopAnimation("sit");
        llSetTimerEvent(0.01);
        llSetAlpha(0, ALL_SIDES);
        llSetScale(<0,0,0>);
        permission = TRUE;
        stop_animation();
        llStartAnimation(llList2String(animations_stand,(integer)llFrand(llGetListLength(animations_stand))));
        }
    }
    changed(integer change)
    { 
        if(permission == FALSE)
        {
            if (change & CHANGED_LINK)
            {
                agent = llAvatarOnSitTarget();
                if (agent)
                {
                llRequestPermissions(agent,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION
                | PERMISSION_CONTROL_CAMERA |  PERMISSION_TRACK_CAMERA);
                }
            }
        }
    }
    listen(integer c,string n, key i, string m)
    {
    if(llGetOwnerKey(i)==agent)
    {
        vector agent = llGetAgentSize(m);
        if(agent)
        {
        target_confirm = TRUE;    
        target = m;
        }
      }  
    }
    control(key name, integer levels, integer edges)
    {
      movementDirection = ZERO_VECTOR;
      rotationDirection = 0;
      if (levels == 768) 
      {
         list results = CastDaRay(llGetCameraPos(), llGetCameraRot());
         vector hit_pos = llList2Vector(results, 1);
         if(hit_pos != ZERO_VECTOR)
         {
         llSetRegionPos(hit_pos);
         return;
         }
      }
      if (levels == 19) 
      {
         speed_Pos = speed_Pos+1;
         llRegionSayTo(agent,0,"set speed "+(string)speed_Pos);
         llSleep(0.5);
         return;
      }
      if (levels == 48) 
      {
         switch0 = !switch0;
         if (switch0)
         {
         switch_mode = TRUE;
         llRegionSayTo(agent,0,"off sim mode");
         llSleep(0.5);
         gPointerPos = default_local_position;
         return;
         }
         else
         { 
         llSetLinkPrimitiveParamsFast(2, [PRIM_POS_LOCAL,default_local_position]);
         llRegionSayTo(agent,0,"normal mode");
         switch_mode = FALSE;
         llSleep(0.5);
         return;
         }
      } 
      if (levels == 35) 
      {
         speed_Pos =0.2;
         llRegionSayTo(agent,0,"reset speed");
         llSleep(0.5);
         return;
      }     
      if (levels == 3) 
      { 
         if(target_confirm == FALSE)
         {     
         ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); 
         chanhandlr = llListen(ichannel, "", NULL_KEY, "");
         llTextBox(agent,"enter uuid",ichannel);
         llSleep(0.6);
         }
         else
         {
         target_confirm = FALSE;
         target = "";
         llSleep(0.6);
         return;
         }
      }
      vector agent = llGetAgentSize(agent);
      if(agent)
      {
      if (~levels & edges)
      {
         stop_animation();
         llStartAnimation(llList2String(animations_stand,(integer)llFrand(llGetListLength(animations_stand))));
         llSetLinkPrimitiveParamsFast(2, [PRIM_ROT_LOCAL,llEuler2Rot(<0 * DEG_TO_RAD,0* DEG_TO_RAD,0 * DEG_TO_RAD>)]);
         return;
      }
      if (levels & CONTROL_FWD) 
      {
         movementDirection.x++; 
         llStartAnimation("Walk");
      }
      if (levels & CONTROL_BACK) 
      {
         movementDirection.x--;  
         llStartAnimation("Walk");
         if(switch_mode == FALSE)
         {
         llSetLinkPrimitiveParamsFast(2, [PRIM_ROT_LOCAL,llEuler2Rot(<0 * DEG_TO_RAD,0* DEG_TO_RAD, 180.0000 * DEG_TO_RAD>)]);
         }
      }
      if (levels & CONTROL_DOWN)
      {
         movementDirection.z--; 
         llStartAnimation("Flying Down"); 
      }
      if (levels & CONTROL_UP)
      {
         movementDirection.z++; 
         llStartAnimation("Flying Up"); 
      }
      if (levels & CONTROL_LEFT)
      {
         rotationDirection++; 
         llStartAnimation("turning_left");
      }
      if (levels & CONTROL_RIGHT)
      {
         rotationDirection--;
         llStartAnimation("turning_right");
      }
      if (levels & CONTROL_ROT_LEFT)
      {
         rotationDirection++;
         llStartAnimation("turning_left");
      }
      if (levels & CONTROL_ROT_RIGHT)
      {
         rotationDirection--; 
         llStartAnimation("turning_right");
      }
     } 
    }
    timer()
    {
    if(permission == TRUE)
    {   
        if(llGetAgentInfo(agent) & AGENT_SITTING)
        { 
        unsit_all();
        follower();
        runtime();
        coune = 0; 
        }
        else
        {
        self_destruct();  
        }
      }     
    } 
  }