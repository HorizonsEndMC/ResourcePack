#define LEATHER_EFFECT(r, g, b) if(isLeatherColor(vec3(r, g, b)))

#define MODEL_SHADER(a) if(isTextureAlpha(255 - a))

#define ALPHA_EFFECT(a) if(isTextureAlpha(a))

#define ALPHA_EFFECT_TWO(a,b) if(isTextureAlpha(a) || isTextureAlpha(b))

#define ALPHA_EFFECT_THREE(a,b,c) if(isTextureAlpha(a) || isTextureAlpha(b) || isTextureAlpha(c))

#define ALPHA_RANGE_EFFECT(a,b) if(isTextureAlphaRange(a,b))

///////////////////////
// GENERAL FUNCTIONS //
///////////////////////

bool isLeatherColor(vec3 colorToExpect) {
	bool colorConfirmed = false;

	float epsilon = 0.01;
	if(distance(round(baseColor.rgb * 255.0), colorToExpect.rgb) < epsilon) {
		colorConfirmed = true;
	}

	return colorConfirmed;
}

bool isTextureAlpha(float valueToExpect) {
	bool alphaConfiemd = false;

	float epsilon = 0.001;
    float colorValue = texture(Sampler0, texCoord0*0.9999999 + vec2(0.00000005)).a * 255.;
	if(distance(colorValue,valueToExpect) < epsilon) {
		alphaConfiemd = true;
	}

	return alphaConfiemd;
}

bool isTextureAlphaRange(float minValueToExpect,float maxValueToExpect) {
	bool alphaConfiemd = false;

	float epsilon = 0.001;
    float colorValue = texture(Sampler0, texCoord0*0.9999999 + vec2(0.00000005)).a * 255.;
	if(colorValue <= maxValueToExpect && colorValue >= minValueToExpect) {
		alphaConfiemd = true;
	}

	return alphaConfiemd;
}

///////////////////////
//  SKYBOXE UTILITY  //
///////////////////////

float DayTime() {
	return (baseColor.r * 255 * 255 + baseColor.g * 255) / 24000;
}

float DayTimeLowPrecision() {
	return baseColor.r;
}

float PlayerHeight() {

    int center = int(255 * 255 * 255 * 0.5);

    int value = int(baseColor.r * 255 * 255 * 255 + baseColor.g * 255 * 255 + baseColor.b * 255);

    float height = (value - center) * 0.01;

	return height;
}

float PlayerHeightLowPrecision() {

    int center = int(255 * 255 * 0.5);

    int value = int(baseColor.g * 255 * 255 + baseColor.b * 255);

    float height = (value - center) * 0.1;

	return height;
}


vec2 localTextureUV(vec2 imageSize,in vec2 localTexCoord) {
    return floor(texCoord0 * textureSize(Sampler0, 0)) / textureSize(Sampler0, 0) + (imageSize / textureSize(Sampler0, 0)) * localTexCoord * 1.;
}

vec2 normalToSpherical(vec3 normal) {
    float planetXCoord = atan(normal.x, normal.z);
    float planetYCoord = asin(normal.y);

    vec2 base = vec2(planetXCoord,planetYCoord) / PI;

    base = base * vec2(0.5,-1) + vec2(0.5,0.5);
    return base;
}