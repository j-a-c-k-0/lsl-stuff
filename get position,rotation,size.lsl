integer counter = 1;
show_position() 
{
    integer primCount = llGetNumberOfPrims();
    integer i;
    for (i=0; i<primCount+1;i++)
    {  
    list A =llGetLinkPrimitiveParams(i,[PRIM_ROT_LOCAL,PRIM_POS_LOCAL,PRIM_SIZE]);
    llOwnerSay("llSetLinkPrimitiveParamsFast("+llGetLinkName(i)+",[PRIM_POS_LOCAL,"+llList2String(A,1)+",PRIM_SIZE,"+llList2String(A,2)+",PRIM_ROT_LOCAL,"+llList2String(A,0)+"]);");
    counter = counter + 1;
    }
}
default
{
    on_rez(integer start_param)
    {
    llResetScript();
    }
    state_entry() 
    { 
    show_position();
    llSleep(0.2);
    llRemoveInventory(llGetScriptName());
    }
}
