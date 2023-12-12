shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
uniform sampler2D normal_texture : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D depth_texture : source_color, hint_depth_texture;
uniform float depth_range:hint_range(0.1, 100.0, 0.1);

uniform sampler3D master_lookup:repeat_disable,filter_nearest;
uniform sampler3D secondary_lookup:repeat_disable,filter_nearest;
uniform sampler2D noiseTexture:repeat_enable,filter_nearest;
uniform vec2      resolution = vec2(320, 240);
uniform float     colorLevels = 8.0;
uniform float 	  ditherResolution = 64.0;

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
}

void fragment()
{
	vec2 uv = SCREEN_UV;
	uv = floor(uv * resolution)/resolution;
	
	vec3 screen_color = texture(screen_texture, uv).rgb;
	screen_color = floor(screen_color * colorLevels) / colorLevels;
	vec3 normal = texture(normal_texture, uv).rgb;
	float roughness =  texture(normal_texture, uv).w;
	
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z / depth_range;
	
	// your code goes here!
	vec4 c1 = texture(master_lookup, screen_color.xyz);
	vec4 c2 = texture(secondary_lookup, screen_color.xyz);
	float f = c2.a;
	// Now choose one or the other color, based on the value of c2.a
	// which acts like a percentage value
	float n = texture(noiseTexture, SCREEN_UV * ditherResolution).r;
	if (c2.a <= n)
		ALBEDO.rgb = c1.rgb;
	else
		ALBEDO.rgb = c2.rgb;
	
	// Output mix factor
	//ALBEDO.rgb = vec3(c2.a, c2.a, c2.a);	
	// Output mix
	//ALBEDO.rgb = mix(c1.rgb, c2.rgb, c2.a);
	// Output color 1
	//ALBEDO.rgb = c1.rgb;
	// Output color 2
	//ALBEDO.rgb = c2.rgb;
	// Output noise
	//ALBEDO.rgb = vec3(n,n,n);
	// Output color to match
	//ALBEDO.rgb = screen_color.rgb;
}
