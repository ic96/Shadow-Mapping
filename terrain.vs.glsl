//VARYING VAR
varying vec3 Normal_V;
varying vec3 Position_V;
varying vec2 Texcoord_V;
varying vec4 Shadow_V;

//UNIFORM VAR
// Inverse world matrix used to render the scene from the light POV
uniform mat4 lightViewMatrixUniform;
// Projection matrix used to render the scene from the light POV
uniform mat4 lightProjectMatrixUniform;


void main() {
    // Shadow coordinate calculations

	Normal_V = normalMatrix * normal;
	Position_V = vec3(modelViewMatrix * vec4(position, 1.0));
    Shadow_V = lightProjectMatrixUniform * lightViewMatrixUniform * modelMatrix * vec4(position, 1.0);
	Texcoord_V = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}