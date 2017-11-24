// UNIFORMS
uniform samplerCube skybox;

varying vec3 Normal_V;
varying vec3 Position_V;
varying vec3 Texcoord;

void main() {

    vec4 texColor = textureCube(skybox,Texcoord);
	gl_FragColor = texColor;
}