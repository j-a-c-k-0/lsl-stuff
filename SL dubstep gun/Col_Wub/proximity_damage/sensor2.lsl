default
{
    state_entry()
    {
    llSensorRepeat("", "",( AGENT | ACTIVE ),10, PI,.1);
    }
    no_sensor()
    {
    llLinkParticleSystem(LINK_THIS,[]); 
    }
    sensor( integer detected )
    {
        integer i;
        for (i = 0; i < detected; i++)
        {
            key k = llDetectedKey(i);   
            if(k==llGetOwner()){}else
            {
            llRezObject("damage",llDetectedPos(i)+(llDetectedVel(i)*0.1)+<0,0,2>,<0,0,-100>,ZERO_ROTATION,1);
            }
        }
    }
}