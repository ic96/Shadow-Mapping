
varying vec3 Normal_V;
varying vec3 Position_V;
varying vec3 Texcoord;

void main() {


	Normal_V = normalMatrix * normal;
	Position_V = vec3(modelViewMatrix * vec4(position, 1.0));
    Texcoord = vec3(position - cameraPosition);
	gl_Position = projectionMatrix * viewMatrix * vec4(position, 1.0);
}