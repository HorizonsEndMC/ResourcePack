    MODEL_SHADER(1) {
        vec2 textureSize = vec2(1920,1080);

        vec2 sphericalUV = normalToSpherical(worldDirection);
        vec2 atlasUV = localTextureUV(textureSize,sphericalUV);
        fragColor = texture(Sampler0,atlasUV);

        fragColor.a = 1;
        fragColor = applyFog(fragColor,0.0);
        return;
    }

    MODEL_SHADER(2) {
        vec2 textureSize = vec2(1920,1080);

        vec2 sphericalUV = normalToSpherical(worldDirection);
        vec2 atlasUV = localTextureUV(textureSize,sphericalUV);
        fragColor = texture(Sampler0,atlasUV);

        fragColor.a = 1;
        fragColor = applyFog(fragColor,0.0);
        return;
    }
