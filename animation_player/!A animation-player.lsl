integer permission = FALSE;
integer ichannel = 10909;
integer timer_run = 1;
integer cur_page = 1;
integer slist_size;
integer chanhandlr;
integer Length;
list anim_temp;
list animlist;
playanim()
{ 
    if(permission == TRUE)
    {
    stop_animation(); 
    llStartAnimation(llList2String(anim_temp,0));
    }
}
stop_animation() 
{    
    if(permission == TRUE)
    {
        integer Lengthx = llGetListLength(animlist);
        if (!Lengthx)
        {     
        return;
        }
        else
        {
            integer x;
            for ( ; x < Lengthx; x += 1)
            {
            llStopAnimation(llList2String(animlist, x));   
            }
        }   
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
    }
    return InventoryList;
}
startup()
{
    llStopSound();llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);
    animlist = list_inv(INVENTORY_ANIMATION); slist_size = llGetInventoryNumber(INVENTORY_ANIMATION);
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
    }
    return newlist;
}
lmsg(string msg)
{
llMessageLinked(LINK_THIS, 0, msg, NULL_KEY);
}
dialog_topmenu()
{ 
llDialog(llGetOwner(),"Main Menu",["[ option ]","[ Anim ]","[ Random ]","[ Reset ]","[ Play ]", "[ Pause ]","[ exit ]"],ichannel);
}
option_topmenu()
{
integer anim_list = llGetListLength(animlist);    
integer free_memory = llGetFreeMemory();    
integer page= (anim_list / 9) + 1 ;
llTextBox(llGetOwner(),
"
[ Status ]
"
+
"
"
+
"Memory = "+(string)free_memory
+
"
"
+
"Anims = "+(string)(anim_list-1)
+
"
"
+
"Page = "+(string)page
+
"

[ Command Format ]

Search > ( s/anim )
Page > ( p/1 )

"
,ichannel); 
}
dialog_animmenu(integer page)
{
    integer pag_amt = llCeil((float)slist_size / 9.0);
    if(page > pag_amt) page = 1;
    else if(page < 1) page = pag_amt;
    cur_page = page; integer animsonpage;
    if(page == pag_amt)
    animsonpage = slist_size % 9;
    if(animsonpage == 0)
    animsonpage = 9; integer fspnum = (page*9)-9; list dbuf; integer i;
    for(; i < animsonpage; ++i)
    {
    dbuf += ["Play #" + (string)(fspnum+i)];
    }
    list snlist = numerizelist(llList2List(animlist, fspnum, (page*9)-1), fspnum, ". ");
    llDialog(llGetOwner(),"Choose an animation:\n" + llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ Main ]", ">>>"]),ichannel);
}
dialog0()
{
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, ""); dialog_topmenu();
}
search_anim(string search)
{
        integer Lengthx = llGetListLength(animlist); integer x;
        for ( ; x < Lengthx; x += 1)
        {
        string A = llToLower(search); string B = llToLower(llList2String(animlist, x));
        integer search_found = ~llSubStringIndex(B,A);
        if (search_found)
        {
        integer index = llListFindList(animlist,[llList2String(animlist, x)]);     
        list sublist = llList2List(animlist, index, index + 1); integer Division= index / 9 ;
        llOwnerSay("[ "+llList2String(sublist,0)+" ] [ page = "+(string)(Division+1)+" list = "+(string)index+" ]");
        dialog_animmenu(Division+1);  
        return;
        }
        else
        { 

        }
    }llOwnerSay("Could not find anything");     
}
default
{
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)         
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
    startup();
    }
    run_time_permissions(integer perm)
    {
       if(PERMISSION_TAKE_CONTROLS & perm)
       {
       llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );
       llSetTimerEvent(timer_run);    
       permission = TRUE; 
       stop_animation();
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
        list params = llParseString2List(msg, ["|"], []);
        if(llList2String(params, 0) == "play_anim")
        { 
        anim_temp = []; anim_temp += (list)[llList2String(params,1)];
        }
    }
    attach(key id)
    {
    if(permission == TRUE)
    {   
        if (id){}else
        {
        stop_animation();
        }
      }  
    }
    timer() 
    {  
       if (~llListFindList(animlist,[llList2String(anim_temp,0)]))
       {
       playanim();
       }  
    }
    listen(integer chan, string sname, key skey, string text)
    {  
    list items0 = llParseString2List(text, ["/"], []);
    if(skey == llGetOwner()) 
    { 
                if(llList2String(items0,0) == "s")
                {
                search_anim(llList2String(items0,1));
                } 
                else if((string)llList2String(items0,0) == "p")
                {
                dialog_animmenu((integer)llList2String(items0,1));
                }
                else if(text == "[ Reset ]")
                {    
                llResetScript();
                }
                else if(text == "[ Main ]")
                {
                dialog_topmenu();
                }
                else if(text == "[ Anim ]")
                {
                dialog_animmenu(cur_page);
                }
                else if(text == "[ option ]")
                {
                option_topmenu();    
                }
                else if(text == "[ Random ]")
                {
                string Random = llList2String(animlist,llFloor(llFrand(llGetListLength(animlist))));    
                llMessageLinked(LINK_THIS, 0, "fetch_note_rationed|" + Random, NULL_KEY);
                llSetTimerEvent(timer_run);
                dialog_topmenu();
                }
                else if(text == "[ Play ]")
                {
                llSetTimerEvent(timer_run); 
                dialog_topmenu();
                }
                else if(text == "[ Pause ]")
                { 
                llSetTimerEvent(0);      
                stop_animation(); 
                dialog_topmenu();
                }
                else if(text == ">>>") dialog_animmenu(cur_page+1);
                else if(text == "<<<") dialog_animmenu(cur_page-1);
                else if(llToLower(llGetSubString(text,0,5)) == "play #")
                {
                integer pnum = (integer)llGetSubString(text, 6, -1);
                lmsg("fetch_note_rationed|" + llList2String(animlist, pnum));
                llSetTimerEvent(timer_run);
                dialog_topmenu();
                }
             }
          }
       }