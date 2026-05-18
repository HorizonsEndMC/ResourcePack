
#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;
uniform vec2 ScreenSize;


vec4 applyFog(vec4 inColor,float modifier) {
    return linear_fog(inColor, vertexDistance * modifier, FogStart, FogEnd, FogColor);
}