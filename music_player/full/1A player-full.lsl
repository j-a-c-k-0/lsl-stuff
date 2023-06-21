string music_selection = "none";
integer ichannel = 46195;
integer cur_page = 1;
integer slist_size;
integer chanhandlr;
integer Length;
float default_sound_radius = 0;
float default_volume = 1;
list songlist;
startup()
{
llStopSound(); llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS); 
songlist = list_inv(INVENTORY_NOTECARD); integer value = llGetListLength(songlist); 
slist_size = value; songlist = llListSort(songlist,1, TRUE);
}
list list_inv(integer itype)
{
  list InventoryList;
  integer count = llGetInventoryNumber(itype);  
  string  ItemName;
  while (count--)
  {
  ItemName = llGetInventoryName(itype, count);
  if (ItemName != llGetScriptName() )  
  InventoryList += ItemName;   
}return InventoryList; }
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
}return newlist;}
dialog_topmenu()
{ 
llDialog(llGetOwner(),"Music = "+music_selection+"\n",
["[ 🛠️️ option ]","[ ♫ songs ]","[ ♫ random ]","[ ⟳ reset ]","[ Play ]", "[ Pause ]", "[ exit ]"],ichannel);
}
dialog_songmenu(integer page)
{
    integer pag_amt = llCeil((float)slist_size / 9.0);
    if(page > pag_amt) page = 1;
    else if(page < 1) page = pag_amt;
    cur_page = page; integer songsonpage;
    if(page == pag_amt)
    songsonpage = slist_size % 9;
    if(songsonpage == 0)
    songsonpage = 9; integer fspnum = (page*9)-9; list dbuf; integer i;
    for(; i < songsonpage; ++i)
    {
    dbuf += ["Play #" + (string)(fspnum+i)];
    }
    list snlist = numerizelist(llList2List(songlist, fspnum, (page*9)-1), fspnum, ". ");
    llDialog(llGetOwner(),"Music = "+music_selection+"\n\n"+llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ Main ]", ">>>"]),ichannel);
}
dialog0()
{
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, ""); dialog_topmenu();
}
search_music(string search)
{
integer Lengthx = llGetListLength(songlist); integer x;
for ( ; x < Lengthx; x += 1)
{
string A = llToLower(search); string B = llToLower(llList2String(songlist, x));
integer search_found = ~llSubStringIndex(B,A);
if (search_found)
{
integer index = llListFindList(songlist,[llList2String(songlist, x)]);     
list sublist = llList2List(songlist, index, index + 1); integer Division= index / 9 ;
llOwnerSay("[ "+llList2String(sublist,0)+" ] [ page = "+(string)(Division+1)+" list = "+(string)index+" ]");
dialog_songmenu(Division+1);  
return;
}}llOwnerSay("Could not find anything"); dialog_topmenu();}
string check_output(float A){if(.01<=A){return(string)A;}return"OFF";}
option_topmenu()
{
list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
list items = llParseString2List(llList2String(a,0),["="],[]);
integer music_list = llGetListLength(songlist);    
integer page= (music_list / 9) + 1 ;
llTextBox(llGetOwner(),
"\n"+"[ Status ]"+"\n\n"+
"Memory = "+(string)llGetFreeMemory()+"\n"+
"Sound Radius = "+(string)llDeleteSubString(check_output(llList2Float(items,1)),4,100)+"\n"+
"Volume = "+(string)llDeleteSubString(check_output(llList2Float(items,0)),4,100)+"\n"+
"Musics = "+(string)(music_list-1)+"\n"+
"Page = "+(string)page+"\n\n"+
"[ Command Format ]"+"\n\n"+
"Search > ( s/music )"+"\n"+
"Volume > ( v/0.5 )"+"\n"+
"Radius > ( r/0 )"+"\n"+
"Page > ( p/1 )"+"\n",ichannel);
}
default
{
    on_rez(integer start_param)
    {
    llResetScript();
    }  
    changed(integer change)
    {
    if (change & CHANGED_INVENTORY){llResetScript();}
    }  
    state_entry()
    {
    startup();
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );}
    }
    touch_start(integer total_number)
    {
    if(llDetectedKey(0) == llGetOwner()) {dialog0();}
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    if(msg == "show_dialog"){dialog0();}
    }
    listen(integer chan, string sname, key skey, string text)
    {  
    list items0 = llParseString2List(text, ["/"], []);
    if(skey == llGetOwner()) 
    {
      if(text == "[ Main ]"){dialog_topmenu();}
      if(text == "[ 🛠️️ option ]"){option_topmenu();}
      if(text == "[ ♫ songs ]"){dialog_songmenu(cur_page);}
      if(text == "[ Play ]")
      {
      llMessageLinked(LINK_THIS, 0,"[ Play ]",""); dialog_topmenu();
      }
      if(text == "[ Pause ]")
      {
      llMessageLinked(LINK_THIS, 0,"[ Pause ]",""); dialog_topmenu();    
      }
      if(llList2String(items0,0) == "s"){search_music(llList2String(items0,1));}
      if((string)llList2String(items0,0) == "p"){dialog_songmenu((integer)llList2String(items0,1));}
      if((string)llList2String(items0,0) == "v")
      {
      list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
      list items = llParseString2List(llList2String(a,0),["="],[]);
      llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,(string)llList2Float(items0,1)+"="+llList2String(items,1)]);
      llMessageLinked(LINK_THIS, 0,"v/"+(string)llList2Float(items0,1),""); llSleep(0.2); dialog_topmenu();
      }
      if((string)llList2String(items0,0) == "r")
      {
      list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
      list items = llParseString2List(llList2String(a,0),["="],[]);
      llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,llList2String(items,0)+"="+(string)llList2Float(items0,1)]);
      llMessageLinked(LINK_THIS, 0,"r/"+(string)llList2Float(items0,1),""); llSleep(0.2); dialog_topmenu();
      }
      if(text == "[ ♫ random ]")
      {
      string Random = llList2String(songlist,llFloor(llFrand(llGetListLength(songlist))));    
      music_selection = Random;llMessageLinked(LINK_THIS, 0, "fetch_note_rationed|" + Random, NULL_KEY);dialog_topmenu();
      }
      if(text == "[ ⟳ reset ]")
      {
      llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,(string)default_volume+"="+(string)default_sound_radius]);
      music_selection = "none"; cur_page = 1; llStopSound();llSleep(0.2); dialog_topmenu();
      llMessageLinked(LINK_THIS, 0,"[ Reset ]","");
      }
      else if(text == ">>>") dialog_songmenu(cur_page+1);
      else if(text == "<<<") dialog_songmenu(cur_page-1);
      else if(llToLower(llGetSubString(text,0,5)) == "play #")
      {
      integer pnum = (integer)llGetSubString(text, 6, -1);
      llMessageLinked(LINK_THIS, 0,"fetch_note_rationed|" + llList2String(songlist, pnum), NULL_KEY);
      music_selection = llList2String(songlist, pnum); dialog_songmenu(cur_page);
} } } }
