integer fire = FALSE;
integer switch = FALSE;
integer particle0;
integer particle1;
integer particle2;
float event_timer = .01;

integer getLinkNum(string primName)
{
integer primCount = llGetNumberOfPrims();
integer i;
for (i=0; i<primCount+1;i++){  
if (llGetLinkName(i)==primName) return i;
} 
return FALSE;
}
vector color(integer A)
{
if(A> 2){return <0.498, 0.859, 1.000>;} 
if(A> 1){return <0.941, 0.071, 0.745>;} 
return<0.498, 0.859, 1.000>;
}
barrel0()
{
llLinkParticleSystem(particle1,[ 
PSYS_PART_FLAGS,(123
|PSYS_PART_INTERP_COLOR_MASK
|PSYS_PART_INTERP_SCALE_MASK
|PSYS_PART_EMISSIVE_MASK ), 
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
PSYS_PART_START_ALPHA,1,
PSYS_PART_END_ALPHA,.8,
PSYS_PART_START_GLOW,1,
PSYS_PART_END_GLOW,.5,   
PSYS_PART_START_COLOR,<0.498, 0.859, 1.000>,
PSYS_PART_END_COLOR,<0.498, 0.859, 1.000>,
PSYS_PART_START_SCALE,<0,0,0>,
PSYS_PART_END_SCALE,<.5+llFrand(1),.5+llFrand(1),0>,
PSYS_PART_MAX_AGE,0.1,
PSYS_SRC_MAX_AGE,.1,
PSYS_SRC_ACCEL,<0,0,0>,
PSYS_SRC_TEXTURE,"9b2328f7-29a7-4d67-2c6c-b6f489ab133e",
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0,
PSYS_SRC_BURST_RATE,0.2,
PSYS_SRC_BURST_SPEED_MIN,0.00,
PSYS_SRC_BURST_SPEED_MAX,0,
PSYS_SRC_ANGLE_BEGIN,0,
PSYS_SRC_ANGLE_END,0,
PSYS_SRC_OMEGA,<0,0,0>]);
}
barrel1()
{
llLinkParticleSystem(particle2,[ 
PSYS_PART_FLAGS,(123
|PSYS_PART_INTERP_COLOR_MASK
|PSYS_PART_INTERP_SCALE_MASK
|PSYS_PART_EMISSIVE_MASK ), 
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
PSYS_PART_START_ALPHA,1,
PSYS_PART_END_ALPHA,.8,
PSYS_PART_START_GLOW,1,
PSYS_PART_END_GLOW,.5, 
PSYS_PART_START_COLOR,<0.941, 0.071, 0.745>,
PSYS_PART_END_COLOR,<0.941, 0.071, 0.745>,
PSYS_PART_START_SCALE,<0,0,0>,
PSYS_PART_END_SCALE,<.5+llFrand(1),.5+llFrand(1),0>,
PSYS_PART_MAX_AGE,0.1,
PSYS_SRC_MAX_AGE,.1,
PSYS_SRC_ACCEL,<0,0,0>,
PSYS_SRC_TEXTURE,"9b2328f7-29a7-4d67-2c6c-b6f489ab133e",
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0,
PSYS_SRC_BURST_RATE,0.2,
PSYS_SRC_BURST_SPEED_MIN,0.00,
PSYS_SRC_BURST_SPEED_MAX,0,
PSYS_SRC_ANGLE_BEGIN,0,
PSYS_SRC_ANGLE_END,0,
PSYS_SRC_OMEGA,<0,0,0>]);
}
plasma_wave()
{
vector color = color((integer)llFrand(3));
llLinkParticleSystem(particle0,[ 
PSYS_PART_FLAGS,(20
|PSYS_PART_INTERP_COLOR_MASK
|PSYS_PART_INTERP_SCALE_MASK
|PSYS_PART_EMISSIVE_MASK ), 
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
PSYS_PART_START_ALPHA,1,
PSYS_PART_END_ALPHA,.8,
PSYS_PART_START_GLOW,0.7,
PSYS_PART_END_GLOW,.2,   
PSYS_PART_START_COLOR,color,
PSYS_PART_END_COLOR,color,
PSYS_PART_START_SCALE,<0,0,0>,
PSYS_PART_END_SCALE,<1.5,1.5,0>,
PSYS_PART_MAX_AGE,.1,
PSYS_SRC_MAX_AGE,.1,
PSYS_SRC_ACCEL,<0,0,0>,
PSYS_SRC_TEXTURE,"852ac415-72ef-eb0f-1e12-12ccd61d3ae6",
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0,
PSYS_SRC_BURST_RATE,0.2,
PSYS_SRC_BURST_SPEED_MIN,0.00,
PSYS_SRC_BURST_SPEED_MAX,0,
PSYS_SRC_ANGLE_BEGIN,0,
PSYS_SRC_ANGLE_END,0,
PSYS_SRC_OMEGA,<0,0,0>]);
}
shockwave()
{
llLinkParticleSystem(particle0,[ 
PSYS_PART_FLAGS,(20
|PSYS_PART_INTERP_COLOR_MASK
|PSYS_PART_INTERP_SCALE_MASK
|PSYS_PART_EMISSIVE_MASK ), 
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
PSYS_PART_START_ALPHA,.1,
PSYS_PART_END_ALPHA,0,
PSYS_PART_START_GLOW,0.05,
PSYS_PART_END_GLOW,0,   
PSYS_PART_START_COLOR,<1,1,1>,
PSYS_PART_END_COLOR,<1,1,1>,
PSYS_PART_START_SCALE,<0,0,0>,
PSYS_PART_END_SCALE,<1,1,0>,
PSYS_PART_MAX_AGE,0.3,
PSYS_SRC_MAX_AGE,.1,
PSYS_SRC_ACCEL,<0,0,0>,
PSYS_SRC_TEXTURE,"3afeacc3-1ba7-eaf1-9d3c-de222eec147e",
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0,
PSYS_SRC_BURST_RATE,0.2,
PSYS_SRC_BURST_SPEED_MIN,0.00,
PSYS_SRC_BURST_SPEED_MAX,0,
PSYS_SRC_ANGLE_BEGIN,0,
PSYS_SRC_ANGLE_END,0,
PSYS_SRC_OMEGA,<0,0,0>]);
}
float limit = 2;
float count;
Collision_bullet() 
{
list d=llGetObjectDetails(llGetOwner(),[OBJECT_POS,OBJECT_VELOCITY]);
rotation rot = llGetRot(); 
vector   fwd = llRot2Fwd(rot);
vector  size = llGetAgentSize(llGetOwner())*0.4;
float fvel=llVecMag(llList2Vector(d,1)); 
vector rezVel = <110+fvel+fvel, 0.0, 0.0>*rot;
if(count>limit)
{
plasma_wave();llRezAtRoot("Col_Wub2",llGetPos()+<0.0,0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),rezVel,rot,12); switch = FALSE;
count = 0; 
}else{
count = count + 1;
}
if(switch == FALSE)
{
barrel1();llRezAtRoot("Col_Wub1",llGetPos()+<0.0,0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),rezVel,rot,12); switch = TRUE;
}else{
barrel0();llRezAtRoot("Col_Wub0",llGetPos()+<0.0,0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),rezVel,rot,12); switch = FALSE;
}}
float limi = 2;
float coun;
default_bullet() 
{
rotation rot = llGetRot(); 
vector   fwd = llRot2Fwd(rot);
vector  size = llGetAgentSize(llGetOwner())*0.4;
if(coun>limi)
{
plasma_wave();llRezAtRoot("Wub1",llGetPos()+<0.0, 0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),fwd,rot,12); switch = FALSE;
coun = 0; 
}else{
coun = coun + 1;
}
if(switch == FALSE)
{
barrel1();llRezAtRoot("Wub0",llGetPos()+<0.0, 0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),fwd,rot,12); switch = TRUE;
}else{
barrel0();llRezAtRoot("Wub2",llGetPos()+<0.0, 0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),fwd,rot,12); switch = FALSE;
}}
bullet_0() 
{
rotation rot = llGetRot(); 
vector   fwd = llRot2Fwd(rot);
vector  size = llGetAgentSize(llGetOwner())*0.4;            
llRezAtRoot("Small_Shockwave",llGetPos()+<0.0, 0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),fwd,rot,12);
}
bullet_1() 
{
rotation rot = llGetRot(); 
vector   fwd = llRot2Fwd(rot);
vector  size = llGetAgentSize(llGetOwner())*0.4;            
llRezAtRoot("Medium_Shockwave",llGetPos()+<0.0, 0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),fwd,rot,12);
}
bullet_2() 
{
rotation rot = llGetRot(); 
vector   fwd = llRot2Fwd(rot);
vector  size = llGetAgentSize(llGetOwner())*0.4;            
llRezAtRoot("Large_Shockwave",llGetPos()+<0.0, 0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),fwd,rot,12);
}
bullet_3() 
{
rotation rot = llGetRot(); 
vector   fwd = llRot2Fwd(rot);
vector  size = llGetAgentSize(llGetOwner())*0.4;            
llRezAtRoot("ExLarge_Shockwave",llGetPos()+<0.0, 0.0, size.z>+fwd*(llVecMag(llGetVel()*0.0)+1.0),fwd,rot,12);
}
default
{
    changed(integer change)
    {
    if(change & CHANGED_INVENTORY){llResetScript();}
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry()
    {
    llSetTimerEvent(event_timer);
    llLinkParticleSystem(LINK_SET,[]);
    particle0 = getLinkNum("particle0");
    particle1 = getLinkNum("particle1");
    particle2 = getLinkNum("particle2");
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );}
    }
    timer() 
    {
    list target0 =llGetLinkPrimitiveParams(particle0,[PRIM_DESC]);
    list target1 =llGetLinkPrimitiveParams(particle1,[PRIM_DESC]);
    if(llList2String(target1,0) == "shoot"){if(fire == FALSE){fire = TRUE;}}else{if(fire == TRUE){llLinkParticleSystem(LINK_SET,[]); fire = FALSE;}}
    if(llList2String(target0,0) == "Collision_Wub"){if(llList2String(target1,0) == "shoot"){Collision_bullet();}}
    if(llList2String(target0,0) == "Default_Wub"){if(llList2String(target1,0) == "shoot"){default_bullet();}}
    if(llList2String(target0,0) == "Small_Shockwave"){if(llList2String(target1,0) == "shoot"){shockwave();bullet_0();}}
    if(llList2String(target0,0) == "Medium_Shockwave"){if(llList2String(target1,0) == "shoot"){shockwave();bullet_1();}}
    if(llList2String(target0,0) == "Large_Shockwave"){if(llList2String(target1,0) == "shoot"){shockwave();bullet_2();}}
    if(llList2String(target0,0) == "ExLarge_Shockwave"){if(llList2String(target1,0) == "shoot"){shockwave();bullet_3();}}
  } }
