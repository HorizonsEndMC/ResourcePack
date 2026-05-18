    MODEL_SHADER(9) {
        // Original From https://polyhaven.com/a/kloofendal_48d_partly_cloudy_puresky licensed under CC0
        // Downscaled to reduce files size, however an 8k texture would also work
        vec2 textureSize = vec2(3840,2160);

        vec2 sphericalUV = normalToSpherical(worldDirection);
        vec2 atlasUV = localTextureUV(textureSize,sphericalUV);
        fragColor = texture(Sampler0,atlasUV);

        fragColor.a = 1;
        fragColor = applyFog(fragColor,0.0);
        return;
    }