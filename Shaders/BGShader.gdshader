shader_type canvas_item;

//uniform vec2 iResolution;
uniform float iTime;


// Ashima 2D Simplex noise
vec3 mod289(vec3 x){ return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x){ return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x){ return mod289(((x*34.0)+1.0)*x); }

float snoise(vec2 v){
	//i got no clue what these numebrs mean - hobbes
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                       -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0/41.0
    vec2 i = floor(v + dot(v, C.yy) );
    vec2 x0 = v - i + dot(i, C.xx);

    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0,0.0) : vec2(0.0,1.0);

    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;

    vec3 p = permute( permute( vec3(i.y, i.y + i1.y, i.y + 1.0) )
                    + vec3(i.x, i.x + i1.x, i.x + 1.0) );

    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m;
    m = m*m;

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

    vec3 g;
    g.x  = a0.x * x0.x + h.x * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;

    return 130.0 * dot(m, g);
}


// Worley noise
float hash21(vec2 p){
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}
vec2 hash22(vec2 p){
    float h = hash21(p);
    return vec2(fract(h * 265.33), fract(h * 179.43));
}

float worleyF1(vec2 uv, float jitter){
    // uv in cell space (each integer grid cell potentially has a point)
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);
    float best = 10.0;
    // 3x3 search, probably inefficient but meh gpus are pretty fast
    for(int y=-1;y<=1;y++){
        for(int x=-1;x<=1;x++){
            vec2 cell = iuv + vec2(float(x), float(y));
            vec2 pt = hash22(cell);
            pt = (pt - 0.5) * jitter + 0.5;
            vec2 diff = cell + pt - uv;
            float d = length(diff);
            if(d < best) best = d;
        }
    }
    return best;
}




float invertedSmoothstep(float x) {
    return x + (x - (x*x * (3.0 - 2.0*x)));
}

void vertex() {

}

void fragment() {
    // normalized pixel coordinates (0..1)
    vec2 uv = SCREEN_UV;
    // keep aspect
    vec2 center = uv - 0.5;
    center.x *= SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;

    // time scale; use a lower number to make the animation slower
    float time = iTime * 0.1;
    // roundness > 1 makes rounder blobs but causes some funky artifacts when too high
    float roundness = 2.0;
    // affects the worley noise, hard to describe how though. just mess around ig
	//messed with it, still dont know what it is - hobbes
    float jitter = 0.5;
    // affects the coordinate "warping"
    float warpFreq = 1.2;
	//this number bigger = weird wave like patterns - hobbes
    float warpAmp = 0.20;

    vec2 samplePos = center;
    samplePos.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    samplePos += 0.5;

    vec2 warp = vec2(
        snoise((samplePos * warpFreq) + vec2(TIME * 0.2, -TIME * 0.15)),
        snoise((samplePos * warpFreq*1.3) + vec2(-TIME * 0.1, TIME * 0.25))
    );
    samplePos += warp * warpAmp;

    float f1 = worleyF1(samplePos, jitter);
    float shaped = pow(1.0 - f1 * 0.5, roundness);

    // idk random numbers I pulled out of nowhere
	//Changes the levl at which the two colors divide, higher is more bottom color, negative is more top color - hobbes
    float detail = 0.5;
    detail += 0.4 * snoise((samplePos * 0.4) + vec2(time* 0.25, -time * 0.6));
    detail += 0.5 * snoise((samplePos * 2.4) + vec2(-time * 0.3, -time * 1.4));
    shaped = shaped * 0.8 + detail * 0.3;

    //vec3 color1 = vec3(89.0, 44.0, 255.0) / 255.0;  // #592CFF - purple
    vec3 color1 = vec3(255.0, 99.0, 71.0) / 255.0;  // #ff6347  - tomato
    vec3 color2 = vec3(237.0, 255.0, 10.0) / 255.0; // #EDFF0A - yellow

    float threshold = 0.5 - invertedSmoothstep(center.y) * 0.8;
    vec3 col = threshold > shaped ? color1 : color2;
    COLOR = vec4(col, 1.0);
}
//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

