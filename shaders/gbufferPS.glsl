#version 330

uniform vec2 ScreenRes;
uniform float uTime;
in vec3 vTex;
in vec4 vPos;

layout(location = 1) out vec4 heightMap;
layout(location = 0) out vec4 outColor;


vec2 quintic(vec2 p) {
  return p * p * p * (10.0 + p * (-15.0 + p * 6.0));
}



vec2 randomGradient(vec2 pos){
	float x = dot(pos, vec2(111.0, 248.0));
	float y = dot(pos, vec2(111.0, 248.0));
	vec2 Gradient = vec2(x, y);
	Gradient = sin(Gradient);
	Gradient *= 20.0;
	Gradient = sin(Gradient + 5);
	return Gradient;
}

vec4 color_tile(vec4 tile){
    if (tile.x <=0.4)
    tile = vec4(0, 1, 1, 1.0);
    heightMap = tile;
    if (tile.x > 0.8) tile = vec4(0.7, 0.7, 0.7, 1);       
    else if (tile.x > 0.6) tile = vec4(0.4, 0.8, 0.1, 1);  
    else if (tile.x > 0.4) tile = vec4(0.3, 0.5, 0.1, 1);
    return tile;
	
}


float perlin(vec2 uv) {
    uv *= 18.0;
    vec2 gridId = floor(uv);
    vec2 gridUV = fract(uv);

    vec2 bl = gridId + vec2(0.0, 0.0);
    vec2 br = gridId + vec2(1.0, 0.0);
    vec2 tl = gridId + vec2(0.0, 1.0);
    vec2 tr = gridId + vec2(1.0, 1.0);

    vec2 gradbl = randomGradient(bl);
    vec2 gradbr = randomGradient(br);
    vec2 gradtl = randomGradient(tl);
    vec2 gradtr = randomGradient(tr);

    vec2 distFromPixelTobl = gridUV - vec2(0.0, 0.0);
    vec2 distFromPixelTobr = gridUV - vec2(1.0, 0.0);
    vec2 distFromPixelTotl = gridUV - vec2(0.0, 1.0);
    vec2 distFromPixelTotr = gridUV - vec2(1.0, 1.0);

    float dotbl = dot(gradbl, distFromPixelTobl);
    float dotbr = dot(gradbr, distFromPixelTobr);
    float dottl = dot(gradtl, distFromPixelTotl);
    float dottr = dot(gradtr, distFromPixelTotr);

    gridUV = quintic(gridUV);

    float s = mix(dotbl, dotbr, gridUV.x);
    float t = mix(dottl, dottr, gridUV.x);
    float noise = mix(s, t, gridUV.y);

    return noise;
}


float fBm(vec2 uv) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 6; i++) {
        value += amplitude * perlin(uv * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}


void main(){

	if(vPos.x < -0.4 || vPos.x > 0.4 || vPos.y < -0.4 || vPos.y > 0.4)
		outColor = vec4(0.0, 1.0, 1.0, 1.0);
	/*else if(vPos.x > 0.4 && vPos.x < 0){
		vec2 uv = vPos.xy;
		uv = (uv+1)/2;
	
		float terrain = fBm(uv * 4.0);
		float dist = distance(vPos.xy, vec2(0.0, 0.0));
		float shape = smoothstep(0.0, 0.4, 1.0 - dist);
		float height = mix(terrain, shape, shape * 0.7);
    	height = pow(height, 1.5);
		//float height = mix(perlin, elevation, 0.6);
		//outColor = vec4(height);
		outColor = vec4(height, height, height, 1.0);
		outColor = color_tile(outColor);
	}*/
	else {
		vec2 uv = vPos.xy;
		uv = (uv+1)/2;
	
		float p = perlin(uv);
		p = 1 - p;
		float dist = distance(vPos.xy, vec2(0.0, 0.0));
		float elevation = 1.0 - smoothstep(0.0, 0.4, dist);
        float height = mix(p, elevation, 0.6);
        outColor = vec4(height);
		outColor = vec4(height, height, height, 1.0);

		outColor = color_tile(outColor);
	}

}


