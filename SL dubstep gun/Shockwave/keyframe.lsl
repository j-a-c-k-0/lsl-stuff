default
{
    on_rez(integer start_param)
    {
      if (start_param)
      {
      llSetKeyframedMotion([llRot2Fwd(llGetRot())*9999,200], [KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_FORWARD]);
      llSetTimerEvent(.01);
      }
   }
   collision(integer num_detected)
   {
   integer i;
   for (i = 0; i < num_detected; i++)
   {
        key k = llDetectedKey(i);
        if(k==llGetOwner())
        { 
        llSetStatus(STATUS_PHANTOM,TRUE); llSetTimerEvent(.1); return; 
        }
      }
    }
    timer() 
    {  
    llSetTimerEvent(0);
    llSetStatus(STATUS_PHANTOM,FALSE);
    }
  }