#version 330

uniform vec2 ScreenRes;
uniform sampler2D colorMap;
uniform sampler2D heightMap;

in vec4 vPos;
//this is in uv coordinate
vec3 sunPos = vec3(0.1, 0.9, 2);
int steps = 500;

out vec4 vColor;

bool sunBlocked(vec2 pos){
	vec3 realPos = vec3(pos, texture(heightMap, pos).x);
	vec3 lightDir = sunPos - realPos;
	vec3 stepDir = lightDir/steps;
	
	for(int i = 0; i < steps; i++){
		realPos += stepDir;
		float height = texture(heightMap, realPos.xy).x;
		if(height > realPos.z){
			return true;
		}
		if(realPos.z > 1)
			return false;
	}
		
	return false;
}

void main(){
		//making my own texture Coordinates becuase it's inverted for some reason
		vec2 uv = vPos.xy;
		uv.x = (uv.x + 1)/2;
		uv.y = (uv.y + 1)/2;
		//give uv coordinate pos
		vColor = texture(colorMap, uv);
		if(sunBlocked(uv))
		vColor = vColor * vec4(0.6, 0.6, 0.6, 1);
		//vColor = texture(colorMap, uv);
	
}


