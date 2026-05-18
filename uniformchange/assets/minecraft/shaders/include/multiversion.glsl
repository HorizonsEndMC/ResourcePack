
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;

vec4 applyFog(vec4 inColor,float modifier) {
    return apply_fog(inColor, sphericalVertexDistance * modifier, cylindricalVertexDistance * modifier, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}