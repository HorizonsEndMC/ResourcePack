#version 150



uniform sampler2D Sampler0;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 baseColor;

#moj_import <multiversion.glsl>

in vec3 vertexPosition;

out vec4 fragColor;

#moj_import <raymarching.glsl>
#moj_import <utils.glsl>
#moj_import <model_effects.glsl>

void main() {
    vec2 screenPosNormalized = gl_FragCoord.xy / ScreenSize;
    vec3 worldDirection = normalize(vertexPosition);

    #moj_import <skybox_config.glsl>



    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = applyFog(color,1);
}