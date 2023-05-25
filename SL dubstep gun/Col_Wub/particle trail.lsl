default
{
    state_entry()
    {
          llParticleSystem(
                [
                PSYS_PART_FLAGS,(1 |PSYS_PART_EMISSIVE_MASK |PSYS_PART_INTERP_COLOR_MASK
                |PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_RIBBON_MASK ), 
                PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE ,
     PSYS_PART_START_COLOR,llGetColor(ALL_SIDES),   
PSYS_PART_END_COLOR,llGetColor(ALL_SIDES) ,     
                PSYS_PART_START_ALPHA,0.5,
                PSYS_PART_END_ALPHA,0,
          PSYS_PART_START_SCALE,<0.2,0.2,0>,
                PSYS_PART_END_SCALE,<0.0,0.0,0>,
                PSYS_PART_MAX_AGE,0.5,
                PSYS_SRC_MAX_AGE,0,
                PSYS_SRC_TARGET_KEY, (key)NULL_KEY,
                PSYS_SRC_BURST_PART_COUNT,1,
                PSYS_SRC_BURST_RADIUS,0.0,
                PSYS_SRC_BURST_RATE,0.01,   
                PSYS_PART_START_GLOW,0.2,
                PSYS_PART_END_GLOW,0,    
                PSYS_SRC_BURST_SPEED_MIN,0.05,
                PSYS_SRC_BURST_SPEED_MAX,0.05,
                PSYS_SRC_TEXTURE, (key)"a24b6ddf-de77-ade8-0716-8b98686c00ee"]);
    }
}
