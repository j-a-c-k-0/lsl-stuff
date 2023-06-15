list bullet_option_list=["Default_Wub","Collision_Wub","ExLarge_Shockwave","Large_Shockwave","Medium_Shockwave","Small_Shockwave","None"];
list texturelist;
string default_positions1 = "<-0.00056, 0.15325, -0.32694>=<0.65328, 0.27060, 0.65329, -0.27057>";
string default_positions2 = "<-0.18765, 0.44787, 0.44810>=<-0.70712, 0.00000, -0.00002, 0.70709>";
string default_positions3 = "<-0.08573, -0.05066, 0.34594>=<-0.31935, 0.08553, 0.17530, 0.92735>";
string default_texture = "e4db4e44-4ba5-a7c3-051f-6ea3f880ce85";
string message_adjustment = "move me and click to apply pos";
string animation_hold = "[Hold]";
string animation_aim = "[Aim]";
integer dialog_select_switch = FALSE;
integer gun_power_state = FALSE;
integer gun_firing_mode = FALSE;
integer gun_holster = FALSE;
integer texture_cur_page = 1;
integer cur_page_bullet = 1;
integer ichannel = 978461;
integer texture_slist_size;
integer slist_size_bullet;
integer adjust_time = 60;
integer state_position;
integer radius_link;
integer chanhandlr;
integer particle0;
integer particle1;
integer particle2;
integer animated0;
integer animated1;
integer counter;
integer slider1;
integer slider2;
integer slider3;
integer slider4;
integer speaker;
integer meter;
integer vinyl;
integer turn1;
integer turn2;
integer turn3;
integer gun;

find_link()
{
meter = getLinkNum("meter"); 
vinyl = getLinkNum("vinyl");
turn1 = getLinkNum("turn1");
turn2 = getLinkNum("turn2");
turn3 = getLinkNum("turn3");
gun = getLinkNum("DubStepGun");
slider1 = getLinkNum("slider1");
slider2 = getLinkNum("slider2");
slider3 = getLinkNum("slider3");
slider4 = getLinkNum("slider4");
animated0 = getLinkNum("gif1"); 
animated1 = getLinkNum("gif2"); 
speaker = getLinkNum("speaker");
radius_link = getLinkNum("starget");
particle0 = getLinkNum("particle0");
particle1 = getLinkNum("particle1");
particle2 = getLinkNum("particle2");
}
startup()
{
gun_power_state = FALSE; gun_holster = FALSE;
llSetLinkPrimitiveParamsFast(meter,[PRIM_DESC,"trigger"]);
llSetLinkPrimitiveParamsFast(animated1,[PRIM_DESC,""]);
llSetLinkPrimitiveParamsFast(animated0,[PRIM_DESC,"none"]);
list target =llGetLinkPrimitiveParams(turn1,[PRIM_DESC]);
list items0 = llParseString2List(llList2String(target,0),["="],[]);
llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL
,(rotation)llList2String(items0,1),PRIM_TEXT,"",llGetColor(ALL_SIDES),0,PRIM_SIZE,<0,0,0>]);
llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);
texturelist = list_inv(INVENTORY_TEXTURE); texture_slist_size = llGetInventoryNumber(INVENTORY_TEXTURE);
}
list list_inv(integer itype)
{
list    InventoryList;integer count = llGetInventoryNumber(itype);  string  ItemName;
while (count--)
{
  ItemName = llGetInventoryName(itype, count);
  if(ItemName != llGetScriptName() )  
  InventoryList += ItemName;   
  }return InventoryList;
}
dialog0()
{
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); 
chanhandlr = llListen(ichannel, "", NULL_KEY, ""); dialog_topmenu();
}
reset()
{
apply_texture(default_texture);
llMessageLinked(LINK_THIS, 0,"[ Reset ]","");
llSetLinkPrimitiveParamsFast(speaker,[PRIM_DESC,"1"]);
llSetLinkPrimitiveParamsFast(meter,[PRIM_DESC,"trigger"]);
llSetLinkPrimitiveParamsFast(animated1,[PRIM_DESC,""]);
llSetLinkPrimitiveParamsFast(animated0,[PRIM_DESC,"none"]);
llSetLinkPrimitiveParamsFast(turn1,[PRIM_DESC,default_positions1]);
llSetLinkPrimitiveParamsFast(turn2,[PRIM_DESC,default_positions2]);
llSetLinkPrimitiveParamsFast(turn3,[PRIM_DESC,default_positions3]);
llSetLinkPrimitiveParamsFast(particle0,[PRIM_DESC,"Default_Wub"]);
llSetLinkPrimitiveParamsFast(radius_link,[PRIM_DESC,"OFF"]);
list items0 = llParseString2List(default_positions1, ["="], []);
llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1)]);
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
list order_buttons(list buttons)
{
return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) +
llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}
list numerizelist(list tlist, integer start, string apnd)
{
    list newlist; integer lsize = llGetListLength(tlist); integer i;
    for(; i < lsize; i++)
    {
    newlist += [(string)(start + i) + apnd + llList2String(tlist, i)];
    }return newlist;
}
string firing_option(){if(gun_firing_mode == FALSE){return"[ ⌥ trigger ]";}else{return"[ ⎇ toggle ]";}}
string gun_holster_D(){if(gun_holster == FALSE){return"[ ⚠️ drawn ]";}else{return"[ ⛔ holster ]";}}
string gun_power()
{
list target =llGetLinkPrimitiveParams(animated0,[PRIM_DESC]);
if(llList2String(target,0) == "none"){return"[ P̶l̶a̶y̶ ]";}   
if(gun_power_state == FALSE){return"[ Play ]";}else{return"[ Pause ]";}
}
dialog_topmenu()
{ 
list target0 =llGetLinkPrimitiveParams(particle0,[PRIM_DESC]);
list target1 =llGetLinkPrimitiveParams(particle2,[PRIM_DESC]);
list items0 = llParseString2List(llList2String(target1,0), ["="], []);
llDialog(llGetOwner(),
"main menu"+"\n"+"\n"+
"Memory = "+llList2String(items0,1)+"\n"+
"Bullet = "+llList2String(target0,0)+"\n"+
"Music = "+llList2String(items0,0),
["[ ⚙ setting ]","[ ♫ songs ]","[ ♫ random ]","[ 🛠️️ option ]",gun_power(),gun_holster_D(),"[ exit ]","[ ⦿ wub ]",firing_option()],ichannel);
}
dialog_option()
{ 
list target0 =llGetLinkPrimitiveParams(particle0,[PRIM_DESC]);
list target1 =llGetLinkPrimitiveParams(particle2,[PRIM_DESC]);
list items0 = llParseString2List(llList2String(target1,0), ["="], []);
llDialog(llGetOwner(),
"option"+"\n"+"\n"
,["[ 🖌️ texture ]","[ 🔧 adjust ]","[ ⟳ reset ]","[ main ]","[ exit ]"],ichannel);
}
bullet_option_dialog()
{
slist_size_bullet = llGetListLength(bullet_option_list); 
dialog_bullet_option(cur_page_bullet);
}
dialog_bullet_option(integer page)
{
integer pag_amt = llCeil((float)slist_size_bullet / 9.0);
if(page > pag_amt) page = 1;
if(page < 1) page = pag_amt;
cur_page_bullet = page; integer destinationsonpage;
if(page == pag_amt)
destinationsonpage = slist_size_bullet % 9;
if(destinationsonpage == 0)
destinationsonpage = 9; integer fspnum = (page*9)-9; list dbuf; integer i;
for(; i < destinationsonpage; ++i)
{
dbuf += ["Choo #" + (string)(fspnum+i)];
}
list target =llGetLinkPrimitiveParams(particle0,[PRIM_DESC]);
list snlist = numerizelist(llList2List(bullet_option_list, fspnum, (page*9)-1), fspnum, ". ");
llDialog(llGetOwner(),"Bullet = "+llList2String(target,0)+"\n\n"+ llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ main ]", ">>>"]),ichannel);
}
dialog_texturemenu(integer page)
{
    integer pag_amt = llCeil((float)texture_slist_size / 9.0);
    if(page > pag_amt) page = 1;
    else if(page < 1) page = pag_amt;
    texture_cur_page = page; integer texturesonpage;
    if(page == pag_amt)
    texturesonpage = texture_slist_size % 9;
    if(texturesonpage == 0)
    texturesonpage = 9; integer fspnum = (page*9)-9; list dbuf; integer i;
    for(; i < texturesonpage; ++i)
    {
    dbuf += ["Text #" + (string)(fspnum+i)];
    }
    list snlist = numerizelist(llList2List(texturelist, fspnum, (page*9)-1), fspnum, ". ");
    llDialog(llGetOwner(),"Choose an theme:\n" + llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ main ]", ">>>"]),ichannel);
}
apply_texture(string msg)
{
llSetLinkPrimitiveParamsFast(gun,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(vinyl,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(turn1,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(turn2,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(turn3,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(turn3,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(speaker,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(slider1,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(slider2,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(slider3,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(slider4,[PRIM_TEXTURE,ALL_SIDES,msg,<1,1,0>,ZERO_VECTOR,0,PRIM_ALPHA_MODE,ALL_SIDES,PRIM_ALPHA_MODE_NONE,0]);
llSetLinkPrimitiveParamsFast(meter,[PRIM_TEXTURE,1,msg,<0,.005,0>,<-0.7,-0.738,0>,90* DEG_TO_RAD,PRIM_ALPHA_MODE,1,PRIM_ALPHA_MODE_NONE,0]);
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
    find_link();
    startup();
    }
    run_time_permissions(integer perm)
    {
      if(PERMISSION_TAKE_CONTROLS & perm)
      {
      llStopAnimation(animation_hold); llStopAnimation(animation_aim);    
      llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );
      }
    }
    touch_start(integer total_number)
    {
    list target1 =llGetLinkPrimitiveParams(particle1,[PRIM_DESC]); if(llList2String(target1,0) == "shoot"){return;}  
    if(llDetectedKey(0) == llGetOwner()){dialog0();}
    }
    link_message(integer source, integer num, string str, key id)
    {
    if(str == "mainmenu_request"){dialog0();}
    }
    listen(integer chan, string sname, key skey, string text)
    {
    list target1 =llGetLinkPrimitiveParams(animated1,[PRIM_DESC]); if(llList2String(target1,0) == "firing"){return;}
    if(skey == llGetOwner())
    {
       if(text == "[ ⌥ trigger ]"){gun_firing_mode = TRUE;llSetLinkPrimitiveParamsFast(meter,[PRIM_DESC,"toggle"]);dialog_topmenu();}
       if(text == "[ ⎇ toggle ]"){gun_firing_mode = FALSE;llSetLinkPrimitiveParamsFast(meter,[PRIM_DESC,"trigger"]);dialog_topmenu();}
       if(text == "[ Play ]"){gun_power_state = TRUE; llMessageLinked(LINK_THIS, 0,"[ Play ]",""); dialog_topmenu();} 
       if(text == "[ Pause ]"){gun_power_state = FALSE; llMessageLinked(LINK_THIS, 0,"[ Pause ]",""); dialog_topmenu();} 
       if(text == "[ ⛔ holster ]"){gun_holster = FALSE; llMessageLinked(LINK_THIS, 0,"holster",""); dialog_topmenu();}   
       if(text == "[ ⚠️ drawn ]"){gun_holster = TRUE; llMessageLinked(LINK_THIS, 0,"drawn",""); dialog_topmenu();}
       if(text == "[ ⚙ setting ]"){llMessageLinked(LINK_THIS, 0,"option_request","");}
       if(text == "[ ♫ random ]"){llMessageLinked(LINK_THIS, 0,"random_request","");}
       if(text == "[ ♫ songs ]"){llMessageLinked(LINK_THIS, 0,"song_request","");}
       if(text == "[ ⟳ reset ]"){reset(); llResetScript();}
       if(text == "[ 🔧 adjust ]"){state adjust_position;} 
       if(text == "[ 🖌️ texture ]"){dialog_select_switch = TRUE; dialog_texturemenu(texture_cur_page);}
       if(text == "[ ⦿ wub ]"){dialog_select_switch = FALSE; bullet_option_dialog();}
       if(text == "[ 🛠️️ option ]"){dialog_option();}
       if(text == "[ main ]"){dialog_topmenu();}
       if(text == "[ P̶l̶a̶y̶ ]"){dialog_topmenu();}
       if(dialog_select_switch == FALSE)
       {
       if(text == ">>>") dialog_bullet_option(cur_page_bullet+1);
       if(text == "<<<") dialog_bullet_option(cur_page_bullet-1);
       if(llToLower(llGetSubString(text,0,5)) == "choo #")
       {
       integer pnum = (integer)llGetSubString(text, 6, -1);
       llSetLinkPrimitiveParamsFast(particle0,[PRIM_DESC,llList2String(bullet_option_list,pnum)]);
       dialog_bullet_option(cur_page_bullet);
       } }
       if(dialog_select_switch == TRUE)
       {  
       if(text == ">>>") dialog_texturemenu(texture_cur_page+1);
       if(text == "<<<") dialog_texturemenu(texture_cur_page-1);
       if(llToLower(llGetSubString(text,0,5)) == "text #")
       {
       integer pnum = (integer)llGetSubString(text, 6, -1);
       apply_texture(llList2String(texturelist, pnum));
       dialog_texturemenu(texture_cur_page);
 } } } } }
 state adjust_position
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
    counter = 0; state_position =1; llSetTimerEvent(1);
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXT,message_adjustment+"\n"+"time : "+(string)(adjust_time-counter)+"\n|"+"\nV",
    llGetColor(ALL_SIDES),1,PRIM_SIZE,<0.33775, 1.00000, 0.55493>]);
    }
    run_time_permissions(integer perm)
    {
      if(PERMISSION_TAKE_CONTROLS & perm)
      {
      llMessageLinked(LINK_THIS, 0,"[ Reset ]",""); llSleep(1);
      list items0 = llParseString2List(default_positions1, ["="], []);
      llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1)]);
      }
    }
    touch_start(integer total_number)
    {
    if(llDetectedKey(0) == llGetOwner())
    {
        counter = 0;
        if(state_position == 1)
        {
        llOwnerSay("position1 : "+(string)llGetLocalPos()+"="+(string)llGetLocalRot());  
        llStopAnimation(animation_hold); llStartAnimation(animation_aim); 
        llSetLinkPrimitiveParamsFast(turn1,[PRIM_DESC,(string)llGetLocalPos()+"="+(string)llGetLocalRot()]); state_position =2;
        list items0 = llParseString2List(default_positions2, ["="], []);
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1)]);
        return;
        }
        if(state_position == 2)
        {
        llOwnerSay("position2 : "+(string)llGetLocalPos()+"="+(string)llGetLocalRot());  
        llStartAnimation(animation_hold); llStopAnimation(animation_aim); 
        llSetLinkPrimitiveParamsFast(turn2,[PRIM_DESC,(string)llGetLocalPos()+"="+(string)llGetLocalRot()]); state_position =3;
        list items0 = llParseString2List(default_positions3, ["="], []);
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1)]);
        return;
        }
        if(state_position == 3)
        {
        llOwnerSay("position3 : "+(string)llGetLocalPos()+"="+(string)llGetLocalRot()); 
        llStopAnimation(animation_hold); llStopAnimation(animation_aim); 
        llSetLinkPrimitiveParamsFast(turn3,[PRIM_DESC,(string)llGetLocalPos()+"="+(string)llGetLocalRot()]);
        llSetTimerEvent(0); state_position =1;
        state default;
    } } }
    timer()
    {
    if(counter>adjust_time)
    {  
    counter = 0; llSetTimerEvent(0);
    llStopAnimation(animation_hold); llStopAnimation(animation_aim);
    list items0 = llParseString2List(default_positions1, ["="], []);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POS_LOCAL,(vector)llList2String(items0,0),PRIM_ROT_LOCAL,(rotation)llList2String(items0,1),
    PRIM_TEXT,"", llGetColor(ALL_SIDES),0,PRIM_SIZE,<0,0,0>]); state default;
    }else{
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_TEXT,message_adjustment+"\n"+"time : "+(string)(adjust_time-counter)+"\n|"+"\nV", llGetColor(ALL_SIDES),1]);
    counter = counter + 1;
} } }
