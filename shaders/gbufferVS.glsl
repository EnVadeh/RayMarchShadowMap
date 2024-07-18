#version 330

uniform mat4 matGeo;
uniform mat4 matOrtho;

layout(location = 0) in vec3 pos;
layout(location = 2) in vec2 tex;

out vec2 vTex;
out vec4 vPos;

void main(){
	gl_Position = matOrtho * matGeo * vec4(pos, 1.0); 
	vTex = tex;
	vPos = gl_Position;
}