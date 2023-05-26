
default
{
    state_entry()
    {        
    llCollisionSound("",0);
    llSetDamage(100);
    llSetStatus(0x002|0x004|0x008,0);
    }
    collision_start(integer num) 
    {
    llLinkParticleSystem(LINK_THIS,[]);  
    llDie();
    }
    land_collision_start(vector pos)
    {
    llLinkParticleSystem(LINK_THIS,[]);    
    llDie();
    }
}