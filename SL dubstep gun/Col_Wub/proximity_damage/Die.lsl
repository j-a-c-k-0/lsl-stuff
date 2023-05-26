default
{   on_rez(integer start_param)
    {   if (start_param)
        {   
        llSleep(1);
        llDie();
        }
    }
}
