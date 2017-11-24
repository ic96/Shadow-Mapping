//VARYING VAR
varying vec3 Normal_V;
varying vec3 Position_V;
varying vec2 Texcoord_V;
varying vec4 Shadow_V;

//UNIFORM VAR
uniform vec3 lightColorUniform;
uniform vec3 ambientColorUniform;
uniform vec3 lightDirectionUniform;

uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;

uniform float shininessUniform;

uniform sampler2D colorMap;
uniform sampler2D normalMap;
uniform sampler2D aoMap;
uniform sampler2D shadowMap;

// PART D)
// Use this instead of directly sampling the shadowmap, as the float
// value is packed into 4 bytes as WebGL 1.0 (OpenGL ES 2.0) doesn't
// support floating point bufffers for the packing see depth.fs.glsl
float getShadowMapDepth(vec2 texCoord)
{
	vec4 v = texture2D(shadowMap, texCoord);
	const vec4 bitShift = vec4(1.0, 1.0/256.0, 1.0/(256.0 * 256.0), 1.0/(256.0*256.0*256.0));
	return dot(v, bitShift);
}

void main() {
	// PART B) TANGENT SPACE NORMAL
	vec3 N_1 = normalize(texture2D(normalMap, Texcoord_V).xyz * 2.0 - 1.0);

	// PRE-CALCS
	vec3 N = normalize(Normal_V);
	vec3 L = normalize(vec3(viewMatrix * vec4(lightDirectionUniform, 0.0)));
	vec3 V = normalize(-Position_V);
	vec3 H = normalize(V + L);
	vec3 T = normalize(cross(N,vec3(0,1,0)));
	vec3 B = normalize(cross(N,T));

    // Convert to Tangent Space
    mat3 TBN = mat3(T,B,N);
    vec3 tangent_L = TBN*L;
    vec3 tangent_V = TBN*V;
    vec3 tangent_H = TBN*H;

    //SHADOW MAPPING
    vec3 shadow = Shadow_V.xyz/Shadow_V.w;
    shadow = (shadow/2.0) + 0.5;
    float attenuation = 1.0;
    if(getShadowMapDepth(shadow.xy) < shadow.z){
        attenuation = 0.3;
    }

	// AMBIENT
	vec3 aoMapTexture = vec3(texture2D(aoMap, Texcoord_V));
	vec3 light_AMB = aoMapTexture* ambientColorUniform * kAmbientUniform;

	// DIFFUSE
	vec3 colorMapTexture = vec3(texture2D(colorMap, Texcoord_V));
	vec3 diffuse = colorMapTexture* kDiffuseUniform * lightColorUniform;
	vec3 light_DFF = attenuation * diffuse * max(0.0, dot(N_1, tangent_L));

	// SPECULAR
	vec3 specular = kSpecularUniform * lightColorUniform;
	vec3 light_SPC = attenuation * specular * pow(max(0.0, dot(tangent_H, N_1)), shininessUniform);

	// TOTAL
	vec3 TOTAL = light_AMB + light_DFF  + light_SPC;

	// SHADOW
	// Fill in attenuation for shadow here

	gl_FragColor = vec4(TOTAL, 1.0);
}
