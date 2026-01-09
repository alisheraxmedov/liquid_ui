// Liquid Glass Fragment Shader for Flutter
// Copyright 2026 Alisher Axmedov
// Based on iOS liquid glass design principles
//
// This shader creates a liquid glass effect with:
// - Background blur sampling
// - Glass tinting
// - Specular highlights
// - Edge lighting

#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

// Uniforms
uniform vec2 uSize;              // Widget size in pixels
uniform float uBlurSigma;        // Blur intensity (0.0 - 30.0)
uniform float uThickness;        // Glass thickness for lighting
uniform vec4 uGlassColor;        // Glass tint color (RGBA)
uniform float uBorderRadius;     // Corner radius
uniform float uLightIntensity;   // Specular light intensity
uniform float uOpacity;          // Overall opacity
uniform sampler2D uBackground;   // Captured background texture

layout(location = 0) out vec4 fragColor;

// Luma weights for luminance calculation (Rec. 709)
const vec3 LUMA_WEIGHTS = vec3(0.299, 0.587, 0.114);

// Signed Distance Function for rounded rectangle
float roundedRectSDF(vec2 p, vec2 size, float radius) {
    vec2 q = abs(p) - size + vec2(radius);
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius;
}

// Get height based on SDF for 3D-like effect
float getHeight(float sd, float thickness) {
    if (sd >= 0.0 || thickness <= 0.0) return 0.0;
    if (sd < -thickness) return thickness;
    float x = thickness + sd;
    return sqrt(max(0.0, thickness * thickness - x * x));
}

// Calculate specular lighting
vec3 calculateSpecular(float height, float thickness, float lightIntensity, vec3 bgColor) {
    if (thickness <= 0.0) return vec3(0.0);
    
    float normalizedHeight = height / thickness;
    float rimFactor = 1.0 - normalizedHeight;
    rimFactor = pow(rimFactor, 2.0);
    
    // Use background luminance for highlight color
    float luminance = dot(bgColor, LUMA_WEIGHTS);
    vec3 highlightColor = vec3(1.0) * (0.5 + luminance * 0.5);
    
    return highlightColor * rimFactor * lightIntensity * 0.5;
}

// Apply glass color tinting
vec4 applyGlassTint(vec4 baseColor, vec4 glassColor) {
    if (glassColor.a <= 0.0) return baseColor;
    
    float glassLuminance = dot(glassColor.rgb, LUMA_WEIGHTS);
    vec3 tinted;
    
    if (glassLuminance < 0.5) {
        // Dark glass - multiply blend
        tinted = baseColor.rgb * (glassColor.rgb * 2.0);
    } else {
        // Light glass - screen blend
        vec3 invBase = vec3(1.0) - baseColor.rgb;
        vec3 invGlass = vec3(1.0) - glassColor.rgb;
        tinted = vec3(1.0) - (invBase * invGlass);
    }
    
    return vec4(mix(baseColor.rgb, tinted, glassColor.a * 0.5), baseColor.a);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    
    // Normalize UV coordinates
    #ifdef IMPELLER_TARGET_OPENGLES
        vec2 uv = vec2(fragCoord.x / uSize.x, 1.0 - (fragCoord.y / uSize.y));
    #else
        vec2 uv = fragCoord / uSize;
    #endif
    
    // Center coordinates for SDF
    vec2 center = uSize * 0.5;
    vec2 p = fragCoord - center;
    
    // Calculate SDF
    float sd = roundedRectSDF(p, center - vec2(1.0), uBorderRadius);
    
    // Early discard for pixels outside the shape
    if (sd > 0.0) {
        fragColor = vec4(0.0);
        return;
    }
    
    // Sample background with blur
    // Note: Blur is handled by BackdropFilterLayer before this shader
    vec4 bgColor = texture(uBackground, uv);
    
    // Calculate height for 3D effect
    float height = getHeight(sd, uThickness);
    
    // Apply glass tinting
    vec4 glassColor = applyGlassTint(bgColor, uGlassColor);
    
    // Calculate specular highlights
    vec3 specular = calculateSpecular(height, uThickness, uLightIntensity, bgColor.rgb);
    
    // Add inner gradient (top-left bright, bottom-right fade)
    float gradientFactor = 1.0 - (uv.x * 0.3 + uv.y * 0.3);
    vec3 gradient = vec3(gradientFactor * 0.15);
    
    // Combine all effects
    vec3 finalColor = glassColor.rgb + specular + gradient;
    
    // Edge anti-aliasing
    float alpha = smoothstep(0.0, -1.5, sd) * uOpacity;
    
    fragColor = vec4(finalColor, alpha);
}
