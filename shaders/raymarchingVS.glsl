#version 330

uniform mat4 matGeo;
uniform mat4 matOrtho;

layout(location = 0) in vec3 pos;

out vec4 vPos;

void main(){
	gl_Position = matOrtho * matGeo * vec4(pos, 1.0); 
	vPos = gl_Position;
}