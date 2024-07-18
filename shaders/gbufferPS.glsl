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
	float x = dot(pos, vec2(11.0, 24.0));
	float y = dot(pos, vec2(11.0, 24.0));
	vec2 Gradient = vec2(x, y);
	Gradient = sin(Gradient);
	Gradient *= 1111.0;
	Gradient = sin(Gradient + 5);
	return Gradient;
}

vec4 color_tile(vec4 tile){
	vec4 colored_tile = tile;
	heightMap = tile;	
    if (tile.x > 0.8) colored_tile = vec4(0.7, 0.7, 0.7, 1);       
    else if (tile.x > 0.6) colored_tile = vec4(0.4, 0.8, 0.1, 1);  
    else if (tile.x > 0.4) colored_tile = vec4(0.3, 0.5, 0.1, 1);  
    else if (tile.x > 0.2) colored_tile = vec4(0.6, 0.6, 0.1, 1);  
    else if (tile.x > 0.1) colored_tile = vec4(0.8, 0.8, 0.0, 1);  
    else colored_tile = vec4(0.0, 1.0, 1.0, 1.0);                  
    return colored_tile;
	
}


void main(){

	if(vPos.x < -0.4 || vPos.x > 0.4 || vPos.y < -0.4 || vPos.y > 0.4)
		outColor = vec4(0.0, 1.0, 1.0, 1.0);
	else{
		vec2 uv = vPos.xy;
		uv = (uv+1)/2;
		uv *= 64.0;
		vec2 gridId = floor(uv);
		vec2 gridUV= fract(uv);
		outColor = vec4(gridUV, 0.0, 1.0);
		
		vec2 bl = gridId + vec2(0.0, 0.0);
		vec2 br = gridId + vec2(1.0, 0.0);
		vec2 tl = gridId + vec2(0.0, 1.0);
		vec2 tr = gridId + vec2(1.0, 1.0);
		

		vec2 gradbl = randomGradient(bl);
		vec2 gradbr = randomGradient(br);
		vec2 gradtl = randomGradient(tl);
		vec2 gradtr = randomGradient(tr);
		
		vec2 distFromPixelTobl = gridUV - vec2(0.0, 0.0);
		vec2 distFromPixelTobr = gridUV - vec2(0.0, 1.0);
		vec2 distFromPixelTotl = gridUV - vec2(1.0, 0.0);
		vec2 distFromPixelTotr = gridUV - vec2(1.0, 1.0);
		
		float dotbl = dot(gradbl, distFromPixelTobl);
		float dotbr = dot(gradbr, distFromPixelTobr);
		float dottl = dot(gradtl, distFromPixelTotl);
		float dottr = dot(gradtr, distFromPixelTotr);
	
		//gridUV = quintic(gridUV);
	
		float s = mix(dotbl, dotbr, gridUV.x);
		float t = mix(dottl, dottr, gridUV.x);
		float perlin = mix(s, t, gridUV.y);
		perlin = 1 - perlin;
		
		float dist = distance(vPos.xy, vec2(0.0, 0.0));
		float elevation = 1.0 - smoothstep(0.0, 0.4, dist);
		float height = mix(perlin, elevation, 0.6);
		outColor = vec4(height);
		
		outColor = color_tile(outColor);
		
	}

}


