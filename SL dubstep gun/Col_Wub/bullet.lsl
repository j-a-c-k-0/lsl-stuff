vector color(integer A)
{
if(A> 2){return <0.498, 0.859, 1.000>;} 
if(A> 1){return <0.941, 0.071, 0.745>;} 
return<0.498, 0.859, 1.000>;
}
particleGen() 
{ 
llSetStatus(STATUS_PHYSICS,FALSE);
llSetStatus(STATUS_PHANTOM,FALSE); 
llRezObject("proximity_damage", llGetPos()+<0,0,0>, ZERO_VECTOR, ZERO_ROTATION, 33);
vector Acolor = color((integer)llFrand(3));

llLinkParticleSystem(3,[
PSYS_PART_FLAGS,           
PSYS_PART_FOLLOW_VELOCITY_MASK| 
PSYS_PART_INTERP_COLOR_MASK|   
PSYS_PART_INTERP_SCALE_MASK|   
PSYS_PART_EMISSIVE_MASK,       
PSYS_SRC_PATTERN,         
PSYS_SRC_PATTERN_ANGLE_CONE,      
PSYS_PART_START_COLOR,Acolor,
PSYS_PART_END_COLOR,Acolor, 
PSYS_PART_START_GLOW,  .2,     
PSYS_PART_END_GLOW,    0,     
PSYS_PART_START_ALPHA, .3,      
PSYS_PART_END_ALPHA,   0,     
PSYS_PART_START_SCALE, <.05,1,0>, 
PSYS_PART_END_SCALE,   <0,1,0>,
PSYS_SRC_BURST_RADIUS, 0,     
PSYS_PART_MAX_AGE,5,        
PSYS_SRC_MAX_AGE,.2,          
PSYS_SRC_BURST_RATE, 0.1,    
PSYS_SRC_BURST_PART_COUNT,10, 
PSYS_SRC_TEXTURE,"d937c2a8-950d-54a5-9106-592e5044a9fa",     
PSYS_SRC_BURST_SPEED_MIN,5,   
PSYS_SRC_BURST_SPEED_MAX,10,    
PSYS_SRC_ACCEL, <0,0,-5>,
PSYS_SRC_ANGLE_BEGIN, 1,     
PSYS_SRC_ANGLE_END, 2       
]);


llLinkParticleSystem(2,[
PSYS_PART_FLAGS,           
PSYS_PART_FOLLOW_VELOCITY_MASK| 
PSYS_PART_INTERP_COLOR_MASK|   
PSYS_PART_INTERP_SCALE_MASK|   
PSYS_PART_EMISSIVE_MASK,       
PSYS_SRC_PATTERN,         
PSYS_SRC_PATTERN_ANGLE_CONE,      
PSYS_PART_START_COLOR,Acolor,
PSYS_PART_END_COLOR,Acolor, 
PSYS_PART_START_GLOW,  .2,     
PSYS_PART_END_GLOW,    0,     
PSYS_PART_START_ALPHA, .3,      
PSYS_PART_END_ALPHA,   0,     
PSYS_PART_START_SCALE, <.05,1,0>, 
PSYS_PART_END_SCALE,   <0,1,0>,
PSYS_SRC_BURST_RADIUS, 0,     
PSYS_PART_MAX_AGE,5,        
PSYS_SRC_MAX_AGE,.2,          
PSYS_SRC_BURST_RATE, 0.1,    
PSYS_SRC_BURST_PART_COUNT,10, 
PSYS_SRC_TEXTURE,"d937c2a8-950d-54a5-9106-592e5044a9fa",     
PSYS_SRC_BURST_SPEED_MIN,5,   
PSYS_SRC_BURST_SPEED_MAX,10,    
PSYS_SRC_ACCEL, <0,0,-5>,
PSYS_SRC_ANGLE_BEGIN, 1,     
PSYS_SRC_ANGLE_END, 2       
]);


llLinkParticleSystem(LINK_THIS,[
PSYS_PART_FLAGS,(20
|PSYS_PART_INTERP_COLOR_MASK
|PSYS_PART_INTERP_SCALE_MASK
|PSYS_PART_EMISSIVE_MASK ), 
PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
PSYS_PART_START_ALPHA,.5,
PSYS_PART_END_ALPHA,0,
PSYS_PART_START_GLOW,0.1,
PSYS_PART_END_GLOW,0,   
PSYS_PART_START_COLOR,Acolor,
PSYS_PART_END_COLOR,Acolor,
PSYS_PART_START_SCALE,<0,0,0>,
PSYS_PART_END_SCALE,<20,20,0>,
PSYS_PART_MAX_AGE,0.7,
PSYS_SRC_MAX_AGE,.2,    
PSYS_SRC_ACCEL,<0,0,0>,
PSYS_SRC_TEXTURE,"852ac415-72ef-eb0f-1e12-12ccd61d3ae6",
PSYS_SRC_BURST_PART_COUNT,10,
PSYS_SRC_BURST_RADIUS,0,
PSYS_SRC_BURST_RATE,1,
PSYS_SRC_BURST_SPEED_MIN,0.00,
PSYS_SRC_BURST_SPEED_MAX,0,
PSYS_SRC_ANGLE_BEGIN,0,
PSYS_SRC_ANGLE_END,0,
PSYS_SRC_OMEGA,<0,0,0>]);
    llSleep (0.03); 
}
default
{ 
    state_entry()
    {
    llCollisionSound("",0);
    llSetDamage(100);
    llSetStatus(0x002|0x004|0x008,0);
    }
    collision_start(integer num) 
    {
    particleGen(); 
    llDie();
    }
    land_collision_start(vector pos)
    {
    particleGen();   
    llDie();
    }
    moving_end()
    {
        if(llGetStatus(STATUS_PHYSICS))
        {

        }else{  
        particleGen();   
        llDie();
        }
    }
}
