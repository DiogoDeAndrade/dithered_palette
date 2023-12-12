shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
uniform sampler3D master_lookup:repeat_disable,filter_nearest;
uniform sampler3D secondary_lookup:repeat_disable,filter_nearest;
uniform sampler2D noiseTexture:repeat_enable,filter_linear;
uniform vec2      resolution = vec2(320, 240);
uniform float     colorLevels = 8.0;
uniform float 	  ditherResolution = 64.0;

void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 q = FRAGCOORD.xy / iResolution.xy;
	q = floor(vec2(q.x * resolution.x, q.y * resolution.y)) / vec2(resolution.x, resolution.y);
	vec3 color = texture( screen_texture, q.xy ).rgb;
	color = floor(color * colorLevels) / colorLevels;
	vec4 c1 = texture(master_lookup, color.xyz);
	vec4 c2 = texture(secondary_lookup, color.xyz);
	// Now choose one or the other color, based on the value of c2.a
	// which acts like a percentage value
	float n = texture(noiseTexture, SCREEN_UV * ditherResolution).r;
	if (c2.a <= n)
		COLOR.rgb = c1.rgb;
	else
		COLOR.rgb = c2.rgb;

	//COLOR.rgb = mix(c1.rgb, c2.rgb, c2.a);
	//COLOR.rgb = c1.rgb;
	//COLOR.rgb = c2.rgb;
	//COLOR.rgb = vec3(c2.a, c2.a, c2.a);
	//COLOR.rgb = vec3(n,n,n);
}
