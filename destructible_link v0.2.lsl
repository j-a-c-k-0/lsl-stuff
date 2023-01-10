float random_deformation_intensity = 0.2;
float link_breaking_limit = 1;
float Ve_durability = 50;
float damage = 150;
float event_timer = .01;
float durability = 20;
float health;

list destructible_parts 
=[
"21",
"23",
"24",
"25",
"28",
"32",
"34",
"36",
"37",
"39",
"40",
"43",
"44",
"45",
"47",
"48",
"trunk1",
"50",
"54",
"57",
"58",
"59",
"61",
"64"
];

vector smoke_color(integer A)
{
if(A> 500) return <0.867, 0.867, 0.867>;
if(A> 200) return <0.667, 0.667, 0.667>;
return <0,0,0>;
}
string object = "destroyed";
vector relativePosOffset = <0, 0.0,0>;
vector relativeVel = <0,0,2>;
rotation relativeRot = <0.707107, 0.0,0, 0.707107>;
integer startParam = 10;
explode() 
{
llLinkParticleSystem(11,[
PSYS_PART_FLAGS,( 1
|PSYS_PART_INTERP_COLOR_MASK
|PSYS_PART_INTERP_SCALE_MASK
|PSYS_PART_EMISSIVE_MASK ), 
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE ,
PSYS_PART_START_ALPHA,0.1,
PSYS_PART_END_ALPHA,0,
PSYS_PART_START_GLOW,0,
PSYS_PART_END_GLOW,0,   
PSYS_PART_START_COLOR,smoke_color((integer)health),
PSYS_PART_END_COLOR,smoke_color((integer)health),
PSYS_PART_START_SCALE,<3,3,0>,
PSYS_PART_END_SCALE,<0,0,0>,
PSYS_PART_MAX_AGE,3,
PSYS_SRC_MAX_AGE,0,
PSYS_SRC_ACCEL,<0,0,4>,
PSYS_SRC_TEXTURE, "006d9758-81da-38a9-9be3-b6c941cae931", 
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0,
PSYS_SRC_BURST_RATE,0,
PSYS_SRC_BURST_SPEED_MIN,0,
PSYS_SRC_BURST_SPEED_MAX,1,
PSYS_SRC_ANGLE_BEGIN,0,
PSYS_SRC_ANGLE_END,0,
PSYS_SRC_OMEGA,<0,0,0>]);
llLinkParticleSystem(22,[
PSYS_PART_FLAGS, 41,
PSYS_PART_START_COLOR, <1.000, 0.422, 0.006>,
PSYS_PART_END_COLOR,<0,0, 0>,
PSYS_PART_START_SCALE,<2,2,0>,
PSYS_PART_END_SCALE,<0,0,0>,
PSYS_PART_START_GLOW,0.2,
PSYS_PART_END_GLOW,0.0,   
PSYS_SRC_PATTERN,10,
PSYS_SRC_BURST_RATE,0.01,
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0.00,
PSYS_SRC_BURST_SPEED_MIN,0.1,
PSYS_SRC_BURST_SPEED_MAX,3,
PSYS_SRC_ANGLE_BEGIN, 1.65,
PSYS_SRC_ANGLE_END, 0.0,
PSYS_SRC_MAX_AGE, 0.0,
PSYS_PART_MAX_AGE,0.2,
PSYS_PART_START_ALPHA,1,
PSYS_PART_END_ALPHA, 0,
PSYS_SRC_TEXTURE, "3cc44c04-7381-20df-e4b0-a036ea51b301",
PSYS_SRC_ACCEL, <0,0,100>]); 
llSleep(5);
llLinkParticleSystem(LINK_ALL_OTHERS    ,[
PSYS_PART_FLAGS,           
PSYS_PART_FOLLOW_VELOCITY_MASK| 
PSYS_PART_INTERP_COLOR_MASK|   
PSYS_PART_INTERP_SCALE_MASK|   
PSYS_PART_EMISSIVE_MASK,       
PSYS_SRC_PATTERN,         
PSYS_SRC_PATTERN_ANGLE_CONE,      
PSYS_PART_START_COLOR, <1.000, 0.522, 0.106>,
PSYS_PART_END_COLOR,   <1,1,1>, 
PSYS_PART_START_GLOW,  1,     
PSYS_PART_END_GLOW,    0,     
PSYS_PART_START_ALPHA, 1,      
PSYS_PART_END_ALPHA,   0,     
PSYS_PART_START_SCALE, <.3,1,0>, 
PSYS_PART_END_SCALE,   <.01,.01,0>,
PSYS_SRC_BURST_RADIUS, 0,     
PSYS_PART_MAX_AGE,1,        
PSYS_SRC_MAX_AGE,1,          
PSYS_SRC_BURST_RATE,100, 
PSYS_SRC_BURST_PART_COUNT,1, 
PSYS_SRC_TEXTURE, "b0b9a3b2-e8c2-251a-7b22-90cc43736c42", 
PSYS_SRC_OMEGA, <0,0,0>,       
PSYS_SRC_BURST_SPEED_MIN, 10,   
PSYS_SRC_BURST_SPEED_MAX, 30,    
PSYS_SRC_ACCEL, <0,0,-5>,       
PSYS_SRC_ANGLE_BEGIN, 1,     
PSYS_SRC_ANGLE_END, 2       
] );   
llSleep(0.05);
llLinkParticleSystem(LINK_ALL_OTHERS,
[
PSYS_PART_FLAGS,( 1
|PSYS_PART_INTERP_COLOR_MASK
|PSYS_PART_INTERP_SCALE_MASK
|PSYS_PART_EMISSIVE_MASK ), 
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE ,
PSYS_PART_START_ALPHA,0.1,
PSYS_PART_END_ALPHA,0,
PSYS_PART_START_GLOW,0,
PSYS_PART_END_GLOW,0,   
PSYS_PART_START_COLOR,<0,0,0>,
PSYS_PART_END_COLOR,<0,0,0>,
PSYS_PART_START_SCALE,<20,20,0>,
PSYS_PART_END_SCALE,<0,0,0>,
PSYS_PART_MAX_AGE,4,
PSYS_SRC_MAX_AGE,0,
PSYS_SRC_ACCEL,<0,0,3>,
PSYS_SRC_TEXTURE, "006d9758-81da-38a9-9be3-b6c941cae931", 
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0,
PSYS_SRC_BURST_RATE,0,
PSYS_SRC_BURST_SPEED_MIN,0,
PSYS_SRC_BURST_SPEED_MAX,20,
PSYS_SRC_ANGLE_BEGIN,0,
PSYS_SRC_ANGLE_END,0,
PSYS_SRC_OMEGA,<0,0,0>]);
llSleep(0.05);
llLinkParticleSystem(LINK_ALL_OTHERS,[
PSYS_PART_FLAGS, 41,
PSYS_PART_START_COLOR, <1.000, 0.422, 0.006>,
PSYS_PART_END_COLOR,<0,0, 0>,
PSYS_PART_START_SCALE,<2,2,0>,
PSYS_PART_END_SCALE,<2,2,0>,
PSYS_PART_START_GLOW,0.2,
PSYS_PART_END_GLOW,0.0,   
PSYS_SRC_PATTERN,10,
PSYS_SRC_BURST_RATE,0.01,
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_BURST_RADIUS,0.00,
PSYS_SRC_BURST_SPEED_MIN,0.1,
PSYS_SRC_BURST_SPEED_MAX,2,
PSYS_SRC_ANGLE_BEGIN, 1.65,
PSYS_SRC_ANGLE_END, 0.0,
PSYS_SRC_MAX_AGE, 0.0,
PSYS_PART_MAX_AGE,0.3,
PSYS_PART_START_ALPHA,0.7,
PSYS_PART_END_ALPHA, 0,
PSYS_SRC_TEXTURE, "3cc44c04-7381-20df-e4b0-a036ea51b301",
PSYS_SRC_ACCEL, <0,0,1>]);
vector myPos = llGetPos();
rotation myRot = llGetRot();
vector rezPos = myPos+relativePosOffset*myRot;
vector rezVel = relativeVel*myRot;
rotation rezRot = relativeRot*myRot;
//llRezObject(object, rezPos, rezVel, rezRot, startParam);
llTriggerSound("a8eb7ef8-763e-b541-1e90-50089f4db717",1);
llTriggerSound("a8eb7ef8-763e-b541-1e90-50089f4db717",1);
llTriggerSound("a8eb7ef8-763e-b541-1e90-50089f4db717",1);
llTriggerSound("2745351b-bd82-1524-39f2-acb7613cfc26",1);
llTriggerSound("2745351b-bd82-1524-39f2-acb7613cfc26",1);
llTriggerSound("2745351b-bd82-1524-39f2-acb7613cfc26",1);
llTriggerSound("2745351b-bd82-1524-39f2-acb7613cfc26",1);
llSleep(0.1);
llDie();
}

create_position() 
{
    integer primCount = llGetNumberOfPrims();
    integer i;
    for (i=0; i<primCount+1;i++)
    { 
        vector agent = llGetAgentSize(llGetLinkKey(i));
        if(agent){ }else 
        {
        list target1 = llGetLinkPrimitiveParams(i,[PRIM_POS_LOCAL]);    
        llSetLinkPrimitiveParamsFast(i,[PRIM_DESC,llList2String(target1,0)]);  
        }
    }
}

collide_0(integer detect_link_collision,string name) 
{
       list target = llGetLinkPrimitiveParams(detect_link_collision,[PRIM_DESC,PRIM_POS_LOCAL,PRIM_ROT_LOCAL]);   
       float A = llFrand(random_deformation_intensity) + llFrand(-random_deformation_intensity);
       float B = llFrand(random_deformation_intensity) + llFrand(-random_deformation_intensity);
       float C = llFrand(random_deformation_intensity) + llFrand(-random_deformation_intensity);
       float dist=llVecDist(llList2Vector(target,0),llList2Vector(target,1)); 
       if(dist<link_breaking_limit)
       { 
       llSetLinkPrimitiveParamsFast(detect_link_collision, [ PRIM_POS_LOCAL,llList2Vector(target,1)+<A,B,C>]);
       }
       else
       {
       health = health - damage;       
       llSetLinkAlpha(detect_link_collision,0, ALL_SIDES); 
       llSetLinkPrimitiveParamsFast(detect_link_collision, [PRIM_SIZE,<0,0,0>,PRIM_POS_LOCAL,<0,0,0>,
       PRIM_PHYSICS_SHAPE_TYPE,PRIM_PHYSICS_SHAPE_NONE]);
       //llRezObject(name,llGetPos()+llList2Vector(target,1), ZERO_VECTOR,llList2Rot(target,2), 33);
       }
}
default
{
    on_rez(integer start_param)
    {
    create_position();
    llResetScript();
    }
    state_entry() 
    { 
    health = 1000;
    llSetTimerEvent(event_timer);
    llLinkParticleSystem(LINK_SET,[]);
    }
    collision_start(integer num_detected)
    {
    integer i;
    for (i = 0; i < num_detected; i++)
    {
    string C = llGetLinkName(llDetectedLinkNumber(i));
    if (~llListFindList(destructible_parts,[C])) 
    {
    integer detect_link_collision = llDetectedLinkNumber(i);
    list target =llGetLinkPrimitiveParams(detect_link_collision,[PRIM_POS_LOCAL]);
    list a=llGetObjectDetails(llDetectedKey(0),[OBJECT_VELOCITY]);
    list d=llGetObjectDetails(llGetKey(),[OBJECT_VELOCITY]);
    float fvel=llVecMag(llList2Vector(d,0)); 
    float fve=llVecMag(llList2Vector(a,0)); 
    if(fvel > durability)
    {
       vector agent = llGetAgentSize(llGetLinkKey(detect_link_collision));
       if(agent)
       {   
       return;
       }
       collide_0(detect_link_collision,C); 
    }
    if(fve > Ve_durability)
    { 
            vector agent = llGetAgentSize(llGetLinkKey(detect_link_collision));
            if(agent)
            {   
            return; 
            }
            collide_0(detect_link_collision,C);
            }  
        }    
        else
        {
 
        }
      }  
    }
    timer()
    { 
    if(health<=450)//smoke particle
    {
    llLinkParticleSystem(11,[
    PSYS_PART_FLAGS,( 1
    |PSYS_PART_INTERP_COLOR_MASK
    |PSYS_PART_INTERP_SCALE_MASK
    |PSYS_PART_EMISSIVE_MASK ), 
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE ,
    PSYS_PART_START_ALPHA,0.1,
    PSYS_PART_END_ALPHA,0,
    PSYS_PART_START_GLOW,0,
    PSYS_PART_END_GLOW,0,   
    PSYS_PART_START_COLOR,smoke_color((integer)health),
    PSYS_PART_END_COLOR,smoke_color((integer)health),
    PSYS_PART_START_SCALE,<1,1,0>,
    PSYS_PART_END_SCALE,<0,0,0>,
    PSYS_PART_MAX_AGE,2,
    PSYS_SRC_MAX_AGE,0,
    PSYS_SRC_ACCEL,<0,0,2>,
    PSYS_SRC_TEXTURE, "006d9758-81da-38a9-9be3-b6c941cae931", 
    PSYS_SRC_BURST_PART_COUNT,1,
    PSYS_SRC_BURST_RADIUS,0,
    PSYS_SRC_BURST_RATE,0,
    PSYS_SRC_BURST_SPEED_MIN,0,
    PSYS_SRC_BURST_SPEED_MAX,0.5,
    PSYS_SRC_ANGLE_BEGIN,0,
    PSYS_SRC_ANGLE_END,0,
    PSYS_SRC_OMEGA,<0,0,0>]);
    }
    if(health<=1)//boom
    {
    //llSetScriptState("sound_collision",FALSE);   
    llSleep(0.2);
    explode();
    }
  }  
}