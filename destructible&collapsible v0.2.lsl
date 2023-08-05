integer physics_type = PRIM_PHYSICS_SHAPE_PRIM;
integer deformation = FALSE;

float self_velocity_durability = 1.0;
float self_deformation_intensity = .01;

float velocity_durability = 1.0;
float deformation_intensity = .001;

float link_breaking_limit = 0.1;
float check_support_timer = 1;

float repair_timer = 50;
float count;

list destructible_parts = ["1"];

integer getLinkNum(string primName)
{
integer primCount = llGetNumberOfPrims();
integer i;
for (i=0; i<primCount+1;i++){  
if (llGetLinkName(i)==primName) return i;
} 
return FALSE;
}
check_support()
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
    integer link = getLinkNum(linked_object);
    list V = llGetLinkPrimitiveParams(link,[PRIM_DESC]);   
    list X = llParseString2List(llList2String(V,0),["="],[]);
    if (!llGetListLength(X)){return;}else
    {
      integer h;
      for ( ; h < llGetListLength(X); h += 1)
      {
      list M = llGetLinkPrimitiveParams(getLinkNum(llList2String(X,h)),[PRIM_DESC,PRIM_PHYSICS_SHAPE_TYPE]);
      list I = llGetLinkPrimitiveParams(link,[PRIM_DESC,PRIM_PHYSICS_SHAPE_TYPE]);
      if((integer)llList2String(I,1) == 1){ }else{if((integer)llList2String(M,1) == 1)
      {
      list A = llGetLinkPrimitiveParams(link,[PRIM_POSITION,PRIM_ROTATION]);
      llSetLinkAlpha(link,0, ALL_SIDES);
      list Q = llGetLinkPrimitiveParams(link,[PRIM_DESC,PRIM_POS_LOCAL,PRIM_PHYSICS_SHAPE_TYPE]);
      llSetLinkPrimitiveParamsFast(link,[PRIM_POS_LOCAL,(vector)llList2String(Q,0),PRIM_PHYSICS_SHAPE_TYPE,PRIM_PHYSICS_SHAPE_NONE]);
      llRezObject(linked_object,llList2Vector(A,0),ZERO_VECTOR,llList2Rot(A,1), 33);
      deformation = TRUE;
      count = 0;
}}}}}}}}
destroyed_link(integer detect_link_collision,string name,vector velocity_hit,float H)
{ 
  count = 0;
  deformation = TRUE;
  list Q = llGetLinkPrimitiveParams(detect_link_collision,[PRIM_DESC,PRIM_POS_LOCAL,PRIM_PHYSICS_SHAPE_TYPE]);
  list X = llParseString2List(llList2String(Q,0),["="],[]); 
  if(llGetAgentSize(llGetLinkKey(detect_link_collision))){return;}
  if((integer)llList2String(Q,2) == 1){return;}
  float dist=llVecDist((vector)llList2String(X,0),llList2Vector(Q,1));
  if(dist<link_breaking_limit)
  { 
  llSetLinkPrimitiveParamsFast(detect_link_collision,[PRIM_POS_LOCAL,(vector)llList2String(X,0)+(velocity_hit*H)]);
  }else{
  list A = llGetLinkPrimitiveParams(detect_link_collision,[PRIM_POSITION,PRIM_ROTATION]);
  llSetLinkAlpha(detect_link_collision,0, ALL_SIDES);
  llSetLinkPrimitiveParamsFast(detect_link_collision,[PRIM_POS_LOCAL,(vector)llList2String(X,0),PRIM_PHYSICS_SHAPE_TYPE,PRIM_PHYSICS_SHAPE_NONE]);
  llRezObject(name,llList2Vector(A,0),ZERO_VECTOR,llList2Rot(A,1),33);
} }
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
      list A = llGetLinkPrimitiveParams(i,[PRIM_POS_LOCAL]);    
      llSetLinkPrimitiveParamsFast(i,[PRIM_DESC,llList2String(A,0)]);  
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
      list X = llParseString2List(llList2String(A,0),["="],[]); 
      llSetLinkPrimitiveParamsFast(i,[PRIM_POS_LOCAL,(vector)llList2String(X,0),PRIM_PHYSICS_SHAPE_TYPE,physics_type]);
} } } }
repair_time()
{
if(deformation == TRUE)
{   
    if(count>repair_timer)
    { 
    repair();
    count = 0;
    deformation = FALSE;  
    }else{
    count = count + 1;
} } }
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
    llSetTimerEvent(check_support_timer);
    //run create positions first and remove the double slash on repair and put the double slash in create.    
    }
    collision_start(integer num_detected)
    {
    integer i;
    for (i = 0; i < num_detected; i++)
    {
        integer detect_link_collision = llDetectedLinkNumber(i);
        string linked_object = llGetLinkName(llDetectedLinkNumber(i));
        if (~llListFindList(destructible_parts,[linked_object])) 
        {
            list x=llGetLinkPrimitiveParams(detect_link_collision,[PRIM_ROT_LOCAL]); 
            list d=llGetObjectDetails(llGetKey(),[OBJECT_VELOCITY]);
            float fvel=llVecMag(llList2Vector(d,0));
            if(fvel > self_velocity_durability)
            {
            destroyed_link(detect_link_collision,linked_object,(-llList2Vector(d,0)/llGetLocalRot()),self_deformation_intensity);
            }
            float fve = llVecMag(llDetectedVel(i))+llVecMag(llGetVel());   
            if(fve > velocity_durability)
            {
            destroyed_link(detect_link_collision,linked_object,(llDetectedVel(i)/llGetLocalRot()),deformation_intensity); 
      } } } }
      timer()
      {
      check_support();
      repair_time();
    } }