integer secondarymemory = 0;
integer ichannel = 10909;
integer cur_page = 1;
integer slist_size;
integer chanhandlr;
integer Length;
float volume = 1.0;
list music_song;
list songlist;
playmusic()
{ 
   if((key)llList2String(music_song,0))
   {  
   llLoopSound(llList2String(music_song,0),volume);
   }
   else
   {
   llOwnerSay("[ Error ] No Music Selected or (INVENTORY_SOUND) Permission Not Set");
   }
}
list list_inv(integer itype)
{
    list    InventoryList;
    integer count = llGetInventoryNumber(itype);  
    string  ItemName;
    while (count--)
    {
        ItemName = llGetInventoryName(itype, count);
        if (ItemName != llGetScriptName() )  
            InventoryList += ItemName;   
    }return InventoryList;
}
startup()
{
    llStopSound(); llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
    songlist = list_inv(INVENTORY_SOUND); integer value = llGetListLength(songlist); 
    slist_size = value; songlist = llListSort(songlist,1, TRUE);
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
lmsg(string msg)
{
    llMessageLinked(LINK_THIS, 0, msg, NULL_KEY);
}
dialog_topmenu()
{ 
llDialog(llGetOwner(),"Main Menu",["[ option ]","[ Songs ]","[ Random ]","[ Reset ]","[ Play ]", "[ Pause ]", "[ exit ]"],ichannel);
}
option_topmenu()
{
integer music_list = llGetListLength(songlist);    
integer free_memory = llGetFreeMemory();    
integer page= (music_list / 9) + 1 ;
llTextBox(llGetOwner(),
"
[ Status ]
"
+
"
"
+
"NotecardScript Memory = "+(string)secondarymemory
+
"
"
+
"MainScript Memory = "+(string)free_memory
+
"
"
+
"Volume = "+(string)volume
+
"
"
+
"Musics = "+(string)(music_list-1)
+
"
"
+
"Page = "+(string)page
+
"

[ Command Format ]

Search > ( s/music )
Volume > ( v/0.5 )
Page > ( p/1 )

"
,ichannel); 
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
    llDialog(llGetOwner(),"Choose an song:\n" + llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ Main ]", ">>>"]),ichannel);
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
        }
    }llOwnerSay("Could not find anything"); dialog_topmenu();    
}
upload_music(string music)
{
  if((key)music)
  { 
  music_song = []; music_song += (list)[music]; playmusic();   
  }
}
default
{
    on_rez(integer start_param) 
    {
    llResetScript();
    }  
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)         
        {
        llResetScript();
        }
    }  
    state_entry()
    {   
    startup();
    }
    run_time_permissions(integer perm)
    {
       if(PERMISSION_TAKE_CONTROLS & perm)
       {
       llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );
       }
    }
    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner()) 
        {
        dialog0(); 
        }
    }
    link_message(integer sender_num, integer num, string msg, key id)
    { 
        list item = llParseString2List(msg, ["|"], []);
        if(msg == "show_dialog")
        {
        dialog0();
        }
        if(llList2String(item, 0) == "memory_result")
        {
        secondarymemory = llList2Integer(item, 1);
        songlist = llListSort(songlist,1, TRUE);
        }
        if(llList2String(item, 0) == "add_music")
        { 
        songlist += llList2String(item, 1);
        integer value = llGetListLength(songlist);
        slist_size = value;
        }
        if(llList2String(item, 0) == "playmusic_notecard")
        { 
        upload_music(llList2String(item,1));
        }
        if(llList2String(item, 0) == "loop_music")
        { 
        upload_music(llList2String(item,1));
        }
    }
    listen(integer chan, string sname, key skey, string text)
    {  
    list items0 = llParseString2List(text, ["/"], []);
    if(skey == llGetOwner()) 
    { 
                if(llList2String(items0,0) == "s")
                {
                search_music(llList2String(items0,1));
                } 
                else if((string)llList2String(items0,0) == "p")
                {
                dialog_songmenu((integer)llList2String(items0,1));
                }    
                else if((string)llList2String(items0,0) == "v")
                {
                volume = llList2Float(items0,1); llStopSound(); llSleep(0.2); playmusic(); dialog_topmenu();
                } 
                else if(text == "[ Reset ]")
                {
                cur_page = 1; volume = 1.0; llStopSound(); llSleep(0.2); playmusic(); dialog_topmenu();
                }
                else if(text == "[ Main ]")
                {
                dialog_topmenu();
                }
                else if(text == "[ Songs ]")
                {
                dialog_songmenu(cur_page);
                }
                else if(text == "[ option ]")
                {
                option_topmenu();    
                }
                else if(text == "[ Random ]")
                {
                string Random = llList2String(songlist,llFloor(llFrand(llGetListLength(songlist))));    
                llMessageLinked(LINK_THIS, 0, "fetch_note_rationed|" + Random, NULL_KEY);
                dialog_topmenu();
                }
                else if(text == "[ Play ]")
                {
                playmusic(); dialog_topmenu();
                }
                else if(text == "[ Pause ]")
                {
                llStopSound(); dialog_topmenu();
                }
                else if(text == ">>>") dialog_songmenu(cur_page+1);
                else if(text == "<<<") dialog_songmenu(cur_page-1);
                else if(llToLower(llGetSubString(text,0,5)) == "play #")
                {
                integer pnum = (integer)llGetSubString(text, 6, -1);
                lmsg("fetch_note_rationed|" + llList2String(songlist, pnum));
                dialog_songmenu(cur_page);
                }
             }
          }
       }