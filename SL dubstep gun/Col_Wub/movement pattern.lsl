float rate = 0.01;
list pattern 
=[
<0,0,-1>,
<0,0,1>
];
integer patternnum = 0;
integer step_pattern = 5;
integer index_pattern = 0;
movement_pattern()
{
        float percent = (float)index_pattern / step_pattern;
        vector from = llList2Vector (pattern, patternnum - 1) * (1.0 - percent);
        vector to = llList2Vector (pattern, patternnum) * percent;
        llSetLinkPrimitiveParamsFast(LINK_ALL_OTHERS, [ PRIM_POS_LOCAL,from + to]);
        index_pattern = index_pattern + 1;
        if (index_pattern >= step_pattern)
        {
            index_pattern = 0;
            patternnum = patternnum + 1;
            if ( patternnum >= llGetListLength (pattern) )
            patternnum = 0;
        }    
}
default 
{
    state_entry()
    {
    llSetTimerEvent(rate);
    llSetLinkPrimitiveParamsFast(LINK_ALL_OTHERS, [ PRIM_POS_LOCAL,<0,0,0>]);
    }
    timer() 
    {
    movement_pattern();
    }
}