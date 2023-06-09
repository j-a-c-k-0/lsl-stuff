integer long_clip_switch = FALSE;
integer start_over = FALSE;
integer gun_armed = FALSE;
integer gun_power = FALSE;
integer charging= 0;
integer animated0;
integer animated1;
integer particle1;
integer speaker;
integer starget;
integer slider1;
integer slider2;
integer slider3;
integer slider4;
integer meter;
integer vinyl;
integer turn1;
integer turn2;
integer turn3;
integer gun;

float runtime = 0.1;
float gun_shooting;
float glow = 0.2;

string shutdown_sound = "82822418-cce5-8bc6-a1cb-7449b40b005e";
string after_sound = "ba948a2d-84e3-f033-65f6-268512e6a0b1";
string animation_hold = "[Hold]";
string animation_aim = "[Aim]";
string shoot_sound;
string idle_music;
string start_fire;
float shoot_timing;

integer getLinkNum(string primName)
{
integer primCount = llGetNumberOfPrims();
integer i;
for (i=0; i<primCount+1;i++){  
if (llGetLinkName(i)==primName) return i;
}
return FALSE;
}
findlink() 
{
animated0 = getLinkNum("gif1");
animated1 = getLinkNum("gif2");  
gun = getLinkNum("DubStepGun");
starget = getLinkNum("starget");
meter = getLinkNum("meter");
vinyl = getLinkNum("vinyl");
turn1 = getLinkNum("turn1");
turn2 = getLinkNum("turn2");
turn3 = getLinkNum("turn3");
speaker = getLinkNum("speaker");
slider1 = getLinkNum("slider1");
slider2 = getLinkNum("slider2");
slider3 = getLinkNum("slider3");
slider4 = getLinkNum("slider4");
particle1 = getLinkNum("particle1");
}
stop_shoot() 
{
gun_shooting =0;
llSetTimerEvent(0);
llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,""]);
llMessageLinked(speaker,0,"play|"+after_sound,""); 
llSleep(.5);
if(long_clip_switch == TRUE){llMessageLinked(LINK_THIS,0,"long_sound_play",""); return;}
llMessageLinked(speaker,0,"play|"+idle_music,"");
}
start_shoot()
{
charging = 0;    
mouse_look_1();
if(long_clip_switch == TRUE){return;}
llMessageLinked(speaker,0,"play|"+start_fire,""); 
}
shutdown() 
{
llSetLinkPrimitiveParams(gun, [PRIM_GLOW,0,0,PRIM_FULLBRIGHT,0,FALSE]);   
llSetLinkAlpha(starget,0, ALL_SIDES);  
llSetLinkAlpha(animated0,0, ALL_SIDES);
llSetLinkAlpha(animated1,0, ALL_SIDES);
llSetLinkPrimitiveParamsFast(meter,[PRIM_ROT_LOCAL,<0.92388, 0.00000, 0.00000, 0.38268>,PRIM_GLOW,1,0,PRIM_FULLBRIGHT,1,FALSE]);
llSetLinkPrimitiveParams(starget, [PRIM_GLOW,ALL_SIDES,0,PRIM_FULLBRIGHT,ALL_SIDES,TRUE]); 
llSetLinkPrimitiveParams(animated0, [PRIM_GLOW,ALL_SIDES,0]);
llSetLinkPrimitiveParams(animated1, [PRIM_GLOW,ALL_SIDES,0]);
llSetLinkPrimitiveParamsFast(turn1,[PRIM_ROT_LOCAL,<0.00000, 0.00000, 0.00000, 1.00000>]);
llSetLinkPrimitiveParamsFast(turn2,[PRIM_ROT_LOCAL,<0.00000, 0.00000, 0.00000, 1.00000>]);
llSetLinkPrimitiveParamsFast(turn3,[PRIM_ROT_LOCAL,<0.00000, 0.00000, 0.00000, 1.00000>]);
llSetLinkPrimitiveParamsFast(speaker,[PRIM_POS_LOCAL,<-0.04538, -0.41595, -0.06606>]);
llSetLinkPrimitiveParamsFast(slider1,[PRIM_POS_LOCAL,<-0.00383, 0.25589, 0.03017>]);
llSetLinkPrimitiveParamsFast(slider2,[PRIM_POS_LOCAL,<-0.00383, 0.27893, 0.03018>]);
llSetLinkPrimitiveParamsFast(slider3,[PRIM_POS_LOCAL,<-0.00383, 0.30148, 0.01477>]);
llSetLinkPrimitiveParamsFast(slider4,[PRIM_POS_LOCAL,<-0.00383, 0.32526, 0.00815>]);
llSetLinkPrimitiveParams(vinyl,[PRIM_OMEGA, <0,0,0>,0,0]);
}
onpower() 
{
llSetLinkPrimitiveParams(vinyl,[PRIM_OMEGA,<1,0,0>,2,0.01]); 
llSetLinkPrimitiveParams(gun, [PRIM_GLOW,0,glow,PRIM_FULLBRIGHT,0,TRUE]);
llSetLinkAlpha(animated0,1, ALL_SIDES);
llSetLinkAlpha(animated1,1, ALL_SIDES);
llSetLinkAlpha(starget,1, ALL_SIDES);
llSetLinkPrimitiveParamsFast(meter,[PRIM_GLOW,1,glow,PRIM_FULLBRIGHT,1,TRUE]);
llSetLinkPrimitiveParams(starget, [PRIM_GLOW,ALL_SIDES,glow,PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
llSetLinkPrimitiveParams(animated0, [PRIM_GLOW,ALL_SIDES,glow]);
llSetLinkPrimitiveParams(animated1, [PRIM_GLOW,ALL_SIDES,glow]);
}
musicselection(string A) 
{
list items1 = llParseString2List(A, ["="], []);
if(llList2String(items1,0) == "idle_music"){long_clip_switch = FALSE; idle_music=llList2String(items1,1);}
if(llList2String(items1,0) == "shoot_sound"){long_clip_switch = FALSE; shoot_sound=llList2String(items1,1);}
if(llList2String(items1,0) == "start_fire"){long_clip_switch = FALSE; start_fire=llList2String(items1,1);}
if(llList2String(items1,0) == "shoot_timing"){shoot_timing=llList2Float(items1,1);}
}
rotation meter_animation(integer A)
{
if(A> 12){return<-0.92388, 0.00000, 0.00000, 0.38269>;}if(A> 11){return<-0.95694, 0.00000, 0.00000, 0.29029>;}
if(A> 10){return<-0.98078, 0.00000, 0.00000, 0.19510>;}if(A> 9){return<-0.99518, -0.00001, 0.00000, 0.09802>;} 
if(A> 8){return<-1.00000, 0.00000, 0.00000, 0.00000>;}if(A> 7){return<0.99519, 0.00000, 0.00000, 0.09801>;}   
if(A> 6){return<0.98079, 0.00000, 0.00000, 0.19508>;}if(A> 5){return<0.95694, 0.00001, 0.00000, 0.29028>;} 
if(A> 4){return<0.92389, 0.00000, 0.00000, 0.38265>;}if(A> 3){return<-1.00000, -0.00001, 0.00000, 0.00000>;}   
if(A> 2){return<0.98079, 0.00001, 0.00000, 0.19508>;}if(A> 1){return<0.95694, 0.00000, 0.00000, 0.29028>;}
return<0.92388, 0.00000, 0.00000, 0.38268>;
}
gun_animation() 
{
llSetLinkPrimitiveParamsFast(meter,[PRIM_ROT_LOCAL,meter_animation((integer)llFrand(3+(9*gun_shooting)))]);
llSetLinkPrimitiveParamsFast(turn1,[PRIM_ROT_LOCAL,<(0.05*llFrand(5+(8*gun_shooting))), 0.00000, 0.00000, 1.00000>]);
llSetLinkPrimitiveParamsFast(turn2,[PRIM_ROT_LOCAL,<(0.05*llFrand(5+(8*gun_shooting))), 0.00000, 0.00000, 1.00000>]);
llSetLinkPrimitiveParamsFast(turn3,[PRIM_ROT_LOCAL,<(0.05*llFrand(5+(8*gun_shooting))), 0.00000, 0.00000, 1.00000>]);
llSetLinkPrimitiveParamsFast(slider1,[PRIM_POS_LOCAL,<-0.00383, 0.25589, (0.01*llFrand(1+(1.7*gun_shooting)))+0.03017>]);
llSetLinkPrimitiveParamsFast(slider2,[PRIM_POS_LOCAL,<-0.00383, 0.27893, (0.01*llFrand(1+(1.7*gun_shooting)))+0.03017>]); 
llSetLinkPrimitiveParamsFast(slider3,[PRIM_POS_LOCAL,<-0.00383, 0.30148, (0.01*llFrand(1+(1.7*gun_shooting)))+0.01477>]);
llSetLinkPrimitiveParamsFast(slider4,[PRIM_POS_LOCAL,<-0.00383, 0.32526, (0.01*llFrand(1+(1.7*gun_shooting)))+0.00815>]);
llSetLinkPrimitiveParamsFast(speaker,[PRIM_POS_LOCAL,<-0.04538,(-(0.005*llFrand(1.5+gun_shooting)))+(-0.41595), -0.06606>]); 
}
mouse_look_1() 
{
list target =llGetLinkPrimitiveParams(turn2,[PRIM_DESC]);
list items0 = llParseString2List(llList2String(target,0), ["="], []);
llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1)]);
llStopAnimation(animation_hold);
llStartAnimation(animation_aim);
}
mouse_look_0() 
{
list target =llGetLinkPrimitiveParams(turn3,[PRIM_DESC]);
list items0 = llParseString2List(llList2String(target,0), ["="], []);
llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1)]);
llStartAnimation(animation_hold);
llStopAnimation(animation_aim);
}
reset()
{
shutdown();
llSetLinkPrimitiveParamsFast(meter,[PRIM_DESC,"trigger"]);
llMessageLinked(speaker,0,"stop","");
llResetScript();
}
default
{  
    changed(integer change)
    {
    if(change & CHANGED_INVENTORY){reset();}
    }
    on_rez(integer start_param) 
    {
    reset();
    }
    state_entry()
    {
    findlink(); gun_shooting =0;
    llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,""]);
    llSetLinkPrimitiveParamsFast(animated1,[PRIM_DESC,""]);
    llSetLinkTextureAnim(starget, ANIM_ON | LOOP, ALL_SIDES,4,4,0,64,11 );   
    llSetLinkTextureAnim(animated0, ANIM_ON | LOOP, ALL_SIDES,3,6,0,64,6.4 );
    llSetLinkTextureAnim(animated1, ANIM_ON | LOOP, ALL_SIDES,3,3,0,64,6.4 );
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION|PERMISSION_TRACK_CAMERA);
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llSetTimerEvent(runtime);llTakeControls(0|CONTROL_LBUTTON |CONTROL_ML_LBUTTON,TRUE,FALSE);}
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    if(msg == "holster")
    {
    gun_shooting =0; gun_armed = FALSE;    
    llStopAnimation(animation_hold); llStopAnimation(animation_aim);
    list target =llGetLinkPrimitiveParams(turn1,[PRIM_DESC]);
    list items0 = llParseString2List(llList2String(target,0), ["="], []);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1)]); 
    llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,""]);
    }
    if(msg == "drawn")
    {
    gun_shooting =0; gun_armed = TRUE;
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION|PERMISSION_TRACK_CAMERA);
    llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,""]);
    }
    list items1 = llParseString2List(msg, ["|"], []);
    if(llList2String(items1,1) == "long_clip"){long_clip_switch = TRUE;}
    if(llList2String(items1,0) == "upload_note"){musicselection(llList2String(items1,1));}
    if(msg == "[ Reset ]"){llStopAnimation(animation_hold);llStopAnimation(animation_aim);reset();}
    if(msg == "music_changed"){if(gun_power == TRUE)
    { 
    if(long_clip_switch == TRUE){llMessageLinked(LINK_THIS,0,"long_sound_play","");return;}
    llMessageLinked(speaker,0,"play|"+idle_music,"");}
    }
        llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,""]);
        if(msg == "[ Pause ]")
        {
          gun_shooting =0; gun_power = FALSE;
          llMessageLinked(speaker,0,"stop",""); llMessageLinked(speaker,0,"shutdown_sound|"+shutdown_sound,""); 
          if(long_clip_switch == TRUE){llMessageLinked(LINK_THIS,0,"long_sound_pause",""); shutdown(); return;}
          shutdown();
          }
          if(msg == "[ Play ]")
          { 
          gun_shooting =0; gun_power = TRUE; 
          if(long_clip_switch == TRUE){llMessageLinked(LINK_THIS,0,"long_sound_play",""); onpower(); return;}
          llMessageLinked(speaker,0,"play|"+idle_music,"");
          onpower();
        } }
        control(key id, integer pressed, integer change)
        { 
        if(gun_power == TRUE){if(gun_armed == TRUE)
        {
          if (pressed & ~~change & (CONTROL_ML_LBUTTON)){start_shoot();state shoot_gun;}  
          if (~pressed & change & (CONTROL_LBUTTON)){charging = 0; return;}
          if (pressed & ~change & (CONTROL_LBUTTON)){++charging; if(charging == 5){start_shoot();state shoot_gun;}}  
    }  }  }
    timer()
    {
    if(gun_power == TRUE){gun_animation();}if(gun_armed == TRUE)
    {
    if(llGetAgentInfo(llGetOwner()) & AGENT_MOUSELOOK){mouse_look_1();}else{mouse_look_0();
 }}}}
 state shoot_gun
 {
    changed(integer change)
    {
    if(change & CHANGED_INVENTORY){reset();}
    }
    on_rez(integer start_param) 
    {
    reset();
    }
    state_entry()
    {
    llSetTimerEvent(shoot_timing);
    llSensorRepeat("", "",AGENT,10, PI,runtime);
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION|PERMISSION_TRACK_CAMERA);
    llSetLinkPrimitiveParamsFast(animated1,[PRIM_DESC,"firing"]);  
    if(long_clip_switch == TRUE){llMessageLinked(speaker,0,"stop",""); llMessageLinked(LINK_THIS,0,"long_sound_play","");} 
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls(0|CONTROL_LBUTTON |CONTROL_ML_LBUTTON,TRUE,FALSE);}
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    list items1 = llParseString2List(msg, ["|"], []);
    if(llList2String(items1,0) == "start_over"){if(long_clip_switch == TRUE){llSetTimerEvent(llList2Float(items1,1));start_over = TRUE;}}
    if(msg == "[ Reset ]"){llStopAnimation(animation_hold);llStopAnimation(animation_aim);reset();}
    }
    control(key id, integer pressed, integer change)
    {
       list target =llGetLinkPrimitiveParams(meter,[PRIM_DESC]);   
       if(llList2String(target,0) == "toggle")
       {
       if (pressed & ~~change & (CONTROL_ML_LBUTTON)){stop_shoot();state default;}
       if (pressed & ~~change & (CONTROL_LBUTTON)){stop_shoot();state default;}
       }else{
       if (~pressed & change & (CONTROL_ML_LBUTTON)){stop_shoot();state default;}
       if (~pressed & change & (CONTROL_LBUTTON)){stop_shoot();state default;} 
     } } 
     no_sensor(){gun_animation();}
     sensor(integer a){gun_animation();}
     timer()
     {
     if(start_over == TRUE){llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,""]);llSetTimerEvent(shoot_timing);start_over = FALSE;gun_shooting =0;return;}
     if(long_clip_switch == TRUE)
     {
     llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,"shoot"]);  
     llSetTimerEvent(0);
     gun_shooting =1.5;
     }else{
     llMessageLinked(speaker,0,"play|"+shoot_sound,"");
     llSetLinkPrimitiveParamsFast(particle1,[PRIM_DESC,"shoot"]);
     llSetTimerEvent(0);
     gun_shooting =1.5;
 } } }
