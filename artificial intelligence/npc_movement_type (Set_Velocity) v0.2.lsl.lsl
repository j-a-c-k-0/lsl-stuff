float radar_distance = 10;
float distance0 = 3;
float distance1 = 1;
float speed_walk = 3;
float speed_run = 5;
float sensor_timer = .01;
float event_timer = .01;
float durability = 50;
float despawn_timer = 3;
float health = 200;
float volume = 1.0;

integer there_threat = FALSE;

vector random_offset;

list threat;

list sounds_died 
=[
"f4b23371-ecde-ba09-eab4-0e570f064f35",
"473bd0ae-1baf-e746-eb95-48cf8d3f15a0",
"cfee9647-bf16-7b7e-5b0f-c206663577be"
];

list sounds_hurt 
=[
"f4b23371-ecde-ba09-eab4-0e570f064f35",
"473bd0ae-1baf-e746-eb95-48cf8d3f15a0",
"cfee9647-bf16-7b7e-5b0f-c206663577be"
];

list sounds 
=[
"271dde02-0c70-e952-b7ba-2668b138283e",
"b872a5b8-a342-dcc0-4259-598daac00a90",
"0b7a1b95-0b5f-fe9c-d378-225d09116229",
"cfee9647-bf16-7b7e-5b0f-c206663577be"
];

integer body;
integer hole;
integer backleg1;
integer backleg0;
integer frontleg1;
integer frontleg0;
integer earsL1;
integer earsL0;
integer earsR1;
integer earsR0;
integer mouth;
integer eye;
integer head1;
integer head0;
integer nose;
integer head2;

unsit_all()
{
    integer objectPrimCount = llGetObjectPrimCount(llGetKey());
    integer currentLinkNumber = llGetNumberOfPrims();
    for (; objectPrimCount < currentLinkNumber; --currentLinkNumber)
    {
    llUnSit(llGetLinkKey(currentLinkNumber));
    }    
}

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
body = getLinkNum("body");
hole = getLinkNum("hole");
backleg1 = getLinkNum("backleg1");
backleg0 = getLinkNum("backleg0");
frontleg1 = getLinkNum("frontleg1");
frontleg0 = getLinkNum("frontleg0");
earsL1 = getLinkNum("earsL1");
earsL0 = getLinkNum("earsL0");
earsR1 = getLinkNum("earsR1");
earsR0 = getLinkNum("earsR0");
eye = getLinkNum("eye");
nose = getLinkNum("nose");
mouth = getLinkNum("mouth");
head2 = getLinkNum("head2");
head1 = getLinkNum("head1");
head0 = getLinkNum("head0");
}

Dead()
{
rotation look=llGetRot()*llRotBetween(<0,0,1>*llGetRot(),(llGetPos()+<0,0,1000>)-llGetPos());
llRotLookAt(look,5,0.01);
string random0 = llList2String(sounds_died,llFloor(llFrand(llGetListLength(sounds_died)))); 
llStopSound(); 
llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"stop"]);
llSetStatus( STATUS_ROTATE_X | STATUS_ROTATE_Y,TRUE);
llTriggerSound(random0,volume);
llSleep(despawn_timer);  
llLinkParticleSystem(LINK_ALL_OTHERS,[
PSYS_PART_FLAGS,           
PSYS_PART_FOLLOW_VELOCITY_MASK| 
PSYS_PART_INTERP_COLOR_MASK|   
PSYS_PART_INTERP_SCALE_MASK|   
PSYS_PART_EMISSIVE_MASK,       
PSYS_SRC_PATTERN,         
PSYS_SRC_PATTERN_ANGLE_CONE,      
PSYS_PART_START_COLOR, llGetColor(ALL_SIDES),   
PSYS_PART_END_COLOR,llGetColor(ALL_SIDES),   
PSYS_PART_START_GLOW,0,     
PSYS_PART_END_GLOW,0,     
PSYS_PART_START_ALPHA, 1,      
PSYS_PART_END_ALPHA,1,     
PSYS_PART_START_SCALE, <0.5,0.5,0>, 
PSYS_PART_END_SCALE,   <0,0,0>,
PSYS_SRC_BURST_RADIUS, 0,     
PSYS_PART_MAX_AGE,.5,        
PSYS_SRC_MAX_AGE,.5,          
PSYS_SRC_BURST_RATE,100, 
PSYS_SRC_BURST_PART_COUNT,2, 
PSYS_SRC_TEXTURE, "d937c2a8-950d-54a5-9106-592e5044a9fa", 
PSYS_SRC_OMEGA, <0,0,0>,       
PSYS_SRC_BURST_SPEED_MIN,5,   
PSYS_SRC_BURST_SPEED_MAX,5,    
PSYS_SRC_ACCEL, <0,0,-10>,       
PSYS_SRC_ANGLE_BEGIN, 1,     
PSYS_SRC_ANGLE_END, 2       
] );
llSleep(0.05);
llLinkParticleSystem(LINK_ALL_OTHERS,[] );
llDie(); 
}

move_to(key avatar)
{
    list crux = llGetObjectDetails(avatar, ([OBJECT_POS, OBJECT_VELOCITY])); 
    float dist=llVecDist(llList2Vector(crux,0)+random_offset,llGetPos()); 
    if(dist>distance0)
    {  
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"walk"]);
    llSetVelocity(llVecNorm((llList2Vector(crux,0)+random_offset)-llGetPos())*speed_walk,0);   
    llRotLookAt(llRotBetween(<1,0,0>,llVecNorm((llList2Vector(crux,0)+random_offset)+(llList2Vector(crux,1)*0)-llGetPos()+(llGetVel()*0.2))),0.2,1.0);
    }
    else
    {
    float dist=llVecDist(llList2Vector(crux,0)+random_offset,llGetPos()); 
    if(dist>distance1)
    {
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"stop"]);
    llRotLookAt(llRotBetween(<1,0,0>,llVecNorm((llList2Vector(crux,0)+random_offset)+(llList2Vector(crux,1)*0)-llGetPos()+(llGetVel()*0.2))),0.2,1.0);
    }
    else
    {
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"walk"]);
    llSetVelocity(llVecNorm((llList2Vector(crux,0)+random_offset)-llGetPos())*-speed_walk,0);  
    llRotLookAt(llRotBetween(<1,0,0>,llVecNorm((llList2Vector(crux,0)+random_offset)+(llList2Vector(crux,1)*0)-llGetPos()+(llGetVel()*0.2))),0.2,1.0);
    }
  }
} 

Run(key avatar)
{
    list crux = llGetObjectDetails(avatar, ([OBJECT_POS, OBJECT_VELOCITY]));
    float dist=llVecDist(llList2Vector(crux,0),llGetPos());     
    dist=llVecDist(llList2Vector(crux,0),llGetPos()); 
    if(dist>radar_distance)
    {
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"stop"]);
    llRotLookAt(llRotBetween(<-1,0,0>,llVecNorm(llList2Vector(crux,0)+(llList2Vector(crux,1)*0)-llGetPos()+(llGetVel()*0.2))),0.2,1.0);
    }
    else
    {
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"walk"]);
    llSetVelocity(llVecNorm(llList2Vector(crux,0)-llGetPos())*-speed_run,0);  
    llRotLookAt(llRotBetween(<-1,0,0>,llVecNorm(llList2Vector(crux,0)-(llList2Vector(crux,1)*0)-llGetPos()+(llGetVel()*0.2))),0.2,1.0);
    }
}

go_home()
{
    float dist=llVecDist((vector)llGetObjectDesc()+random_offset,llGetPos());
    if(dist>1.5)
    {
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"walk"]);
    llSetVelocity(llVecNorm(((vector)llGetObjectDesc()+random_offset)-llGetPos())*speed_walk,0);  
    llRotLookAt(llRotBetween(<1,0,0>,llVecNorm(((vector)llGetObjectDesc()+random_offset)+(llGetVel()*0)-llGetPos()+(llGetVel()*0.2))),0.2,1.0);
    }
    else
    {
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"stop"]);
    }
}

integer channel = -122313;
startup()
{
    llStopSound();
    llListen(channel,"","","");
    llSetTimerEvent(event_timer);
    llSetObjectDesc((string)llGetPos());
    llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
    llSensorRepeat("","",AGENT,radar_distance,PI,sensor_timer);
    llSetLinkPrimitiveParamsFast(body,[PRIM_DESC,"stop"]);
    llSetStatus( STATUS_ROTATE_X | STATUS_ROTATE_Y, TRUE);
    llLinkParticleSystem(LINK_ALL_OTHERS,[] );
}
float timelimit = 150;
float counter;
random_sound()
{  
     if(counter>timelimit)
     { 
     string random0 = llList2String(sounds,llFloor(llFrand(llGetListLength(sounds))));
     llPlaySound(random0,volume);
     counter = 0;  
     }
     else
     {
     counter = counter + 1;     
     }       
}
float timelim = 200;
float coune;
forget_threat()
{  
   if(there_threat == TRUE) 
   {  
      if(coune>timelim)
      {
      threat = [];    
      there_threat = FALSE;
      coune = 0;  
      }
      else
      {
      coune = coune + 1;     
      } 
   }
}
float timeli = 60;
float coun;
generate_vector()
{  
    if(coun>timeli)
    {
    float A = llFrand(5) + llFrand(-5);
    float B = llFrand(5) + llFrand(-5);
    random_offset = <A,B,0>;
    coun = 0;  
    }
    else
    {
    coun = coun + 1;     
    } 
}
default
{
    changed(integer change)
    {
      if (change & CHANGED_LINK)
      {  
      llResetScript();
      }
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry() 
    { 
    llCollisionSound("",0);
    findlink();
    startup();
    }
    sensor(integer num_detected)
    { 
       if (~llListFindList(threat,[(string)llDetectedKey(0)])) 
       {
       Run(llDetectedKey(0));
       }
       else
       {  
       move_to(llDetectedKey(0));  
       }
    }
    listen(integer c,string n, key i, string m)
    { 
    if(llGetOwnerKey(i)==llGetOwner())
    {
        vector pos=llList2Vector(llGetObjectDetails(i,[OBJECT_POS]),0);
        float dist=llVecDist(pos,llGetPos());     
        dist=llVecDist(pos,llGetPos());
        if(dist>10)
        {  

        }
        else
        {
        list items = llParseString2List(m, ["|"], []);
        if(llList2String(items,0) == "thisguyhurtme")
        { 
            if (!~llListFindList(threat, [llList2String(items,1)]))
            {
            threat += (list)llList2String(items,1); 
            there_threat = TRUE;
            }
          }
        }
      } 
    } 
    collision_start(integer times)
    {
        float damage = llVecMag(llDetectedVel(0))+llVecMag(llGetVel());   
        if(damage > durability)
        {   
        string random0 = llList2String(sounds_hurt,llFloor(llFrand(llGetListLength(sounds_hurt))));
        string ree = llGetOwnerKey(llDetectedKey(0));
        llTriggerSound(random0,volume); 
        health = health - damage;
        if (!~llListFindList(threat, [ree]))
        {
        threat += (list)((string)ree);
        llRegionSay(channel,"thisguyhurtme"+"|"+ree); 
        there_threat = TRUE;
        }
      }
    }
    land_collision_start(vector where)
    {
        float damage = llVecMag(llDetectedVel(0))+llVecMag(llGetVel());   
        if(damage > durability)
        {
        string random0 = llList2String(sounds_hurt,llFloor(llFrand(llGetListLength(sounds_hurt))));    
        llTriggerSound(random0,volume); 
        health = health - damage;
        }
    }
    no_sensor()
    {      
    go_home();
    }
    timer()
    { 
      unsit_all(); 
      rotation look=llGetRot()*llRotBetween(<0,0,1>*llGetRot(),(llGetPos()+<0,0,1000>)-llGetPos());
      llRotLookAt(look,0.1,0.01);
      generate_vector(); 
      random_sound(); 
      forget_threat();
      if(health<=1)
      {
      Dead();
      }
   }
}