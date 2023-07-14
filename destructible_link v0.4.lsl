integer self_velocity_durability = 5;
float self_deformation_intensity = .01;

integer velocity_durability = 100;
float deformation_intensity = .0003;

float link_breaking_limit = 0.2;
float event_timer = 50;

list destructible_parts =["1"];

destroyed_link(integer detect_link_collision,string name,vector velocity_hit,float H)
{
  llSetTimerEvent(0);  
  list Q = llGetLinkPrimitiveParams(detect_link_collision,[PRIM_DESC,PRIM_POS_LOCAL]);  
  float dist=llVecDist((vector)llList2String(Q,0),llList2Vector(Q,1) );
  if(dist<link_breaking_limit)
  { 
  llSetLinkPrimitiveParamsFast(detect_link_collision,[PRIM_POS_LOCAL,llList2Vector(Q,1)+(velocity_hit*H)]);
  }else{
  list A = llGetLinkPrimitiveParams(detect_link_collision,[PRIM_POSITION,PRIM_ROTATION]);
  llSetLinkAlpha(detect_link_collision,0, ALL_SIDES);
  llSetLinkPrimitiveParamsFast(detect_link_collision,[PRIM_PHYSICS_SHAPE_TYPE,PRIM_PHYSICS_SHAPE_NONE,PRIM_POS_LOCAL,(vector)llList2String(Q,0)]);
  llRezObject(name,llList2Vector(A,0), ZERO_VECTOR,llList2Rot(A,1), 33);
  }
  llSetTimerEvent(event_timer);
}
create_position() 
{
  integer primCount = llGetNumberOfPrims();
  integer i;
  for (i=0; i<primCount+1;i++)
  {
    if(llGetAgentSize(llGetLinkKey(i))){ }else 
    {
      string linked_object = llGetLinkName(i);
      if (~llListFindList(destructible_parts,[linked_object])) 
      {
      list target1 = llGetLinkPrimitiveParams(i,[PRIM_POS_LOCAL]);    
      llSetLinkPrimitiveParamsFast(i,[PRIM_DESC,llList2String(target1,0)]);  
} } } }
repair()
{
  integer primCount = llGetNumberOfPrims();
  integer i;
  for (i=0; i<primCount+1;i++)
  {  
    if(llGetAgentSize(llGetLinkKey(i))){ }else 
    { 
      string linked_object = llGetLinkName(i);
      if (~llListFindList(destructible_parts,[linked_object])) 
      {
      llSetLinkAlpha(i,1, ALL_SIDES); 
      list A = llGetLinkPrimitiveParams(i,[PRIM_DESC]);  
      llSetLinkPrimitiveParamsFast(i,[PRIM_POS_LOCAL,(vector)llList2String(A,0),PRIM_PHYSICS_SHAPE_TYPE,PRIM_PHYSICS_SHAPE_PRIM]);
} } } }
default
{
    on_rez(integer start_param)
    {
    llResetScript();
    }
    changed(integer change)
    {
    if(change & CHANGED_REGION_START){llResetScript();} 
    } 
    state_entry() 
    {
    //repair();
    create_position();
    //run create positions first and remove the double slash on repair and put the double slash in create.
    }
    collision_start(integer num_detected)
    {
    integer i;
    for (i = 0; i < num_detected; i++)
    {
        integer detect_link_collision = llDetectedLinkNumber(i);
        string linked_object = llGetLinkName(llDetectedLinkNumber(i));
        if(llGetAgentSize(llGetLinkKey(detect_link_collision))){return;}
        if (~llListFindList(destructible_parts,[linked_object])) 
        {
            list d=llGetObjectDetails(llGetKey(),[OBJECT_VELOCITY]);
            float fvel=llVecMag(llList2Vector(d,0));
            if(fvel > self_velocity_durability)
            {
            destroyed_link(detect_link_collision,linked_object,(llList2Vector(d,0)*llGetLocalRot()),self_deformation_intensity);
            return;
            }
            float fve = llVecMag(llDetectedVel(i))+llVecMag(llGetVel());   
            if(fve > velocity_durability)
            {
            destroyed_link(detect_link_collision,linked_object,(llDetectedVel(i)*llGetLocalRot()),deformation_intensity); 
            return;
      } } } }
      timer()
      {
      repair();
      llSetTimerEvent(0);
    } }
