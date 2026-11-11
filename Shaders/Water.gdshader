shader_type canvas_item;

uniform vec4 water_color : source_color = vec4(0.12, 0.45, 0.75, 1.0);
uniform vec4 sun_color : source_color = vec4(1.0, 0.95, 0.8, 0.5); // Warm translucent sunlight color
uniform vec2 speed = vec2(0.03, 0.02);
uniform float scale : hint_range(1.0, 20.0) = 6.0;
uniform float intensity : hint_range(0.1, 2.0) = 1.0;
uniform sampler2D noise_texture : repeat_enable;

void fragment() {
    // Fix aspect ratio distortion so patterns stay perfectly proportioned circles/blobs
    vec2 uv = UV * scale;
    uv.x *= 1.78; // Adjusts for widescreen aspect ratio (assuming 16:9)
    
    // Two layers moving in opposite directions to create shimmering sunlight caustics
    vec2 uv1 = uv + speed * TIME;
    vec2 uv2 = uv - speed * 0.7 * TIME + vec2(5.0, 2.0);
    
    float n1 = texture(noise_texture, uv1).r;
    float n2 = texture(noise_texture, uv2).r;
    
    // Multiply and contrast the noise to create sharp, glowing light webs/patches
    float caustic = n1 * n2;
    caustic = smoothstep(0.2, 0.8, caustic) * intensity;
    
    // Blend the warm translucent sunlight over the blue water background
    vec3 final_rgb = mix(water_color.rgb, sun_color.rgb, caustic * sun_color.a);
    
    COLOR = vec4(final_rgb, water_color.a);
}