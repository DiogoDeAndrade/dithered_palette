shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
uniform sampler3D master_lookup:repeat_disable,filter_nearest;
uniform sampler3D secondary_lookup:repeat_disable,filter_nearest;
uniform sampler2D noiseTexture:repeat_enable,filter_linear;
uniform vec2      resolution = vec2(320, 240);

void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 q = FRAGCOORD.xy / iResolution.xy;
	q = floor(vec2(q.x * resolution.x, q.y * resolution.y)) / vec2(resolution.x, resolution.y);
	vec3 color = texture( screen_texture, q.xy ).rgb;
	vec4 c1 = texture(master_lookup, color.xyz);
	vec4 c2 = texture(secondary_lookup, color.xyz);
	// Now choose one or the other color, based on the value of c2.a
	// which acts like a percentage value
	float n = texture(noiseTexture, q.xy * 32.0).r;
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

// Based on: https://www.shadertoy.com/view/Ms23DR
/*uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Loosely based on postprocessing shader by inigo quilez, License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.92 + 0.04;
	return uv;
}
void fragment(  )
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 q = FRAGCOORD.xy / iResolution.xy;
    vec2 uv = q;
    uv = curve( uv );
    vec3 oricol = texture( screen_texture, vec2(q.x,q.y) ).xyz;
    vec3 col;
	float x =  sin(0.3*TIME+uv.y*21.0)*sin(0.7*TIME+uv.y*29.0)*sin(0.3+0.33*TIME+uv.y*31.0)*0.0017;

    col.r = texture(screen_texture,vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
    col.g = texture(screen_texture,vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
    col.b = texture(screen_texture,vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
    col.r += 0.08*texture(screen_texture,0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
    col.g += 0.05*texture(screen_texture,0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
    col.b += 0.08*texture(screen_texture,0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
	col *= vec3(pow(vig,0.3));

    col *= vec3(0.95,1.05,0.95);
	col *= 2.8;

	float scans = clamp( 0.35+0.35*sin(3.5*TIME+uv.y*iResolution.y*1.5), 0.0, 1.0);
	
	float s = pow(scans,1.7);
	col = col*vec3( 0.4+0.7*s) ;

    col *= 1.0+0.01*sin(110.0*TIME);
	if (uv.x < 0.0 || uv.x > 1.0)
		col *= 0.0;
	if (uv.y < 0.0 || uv.y > 1.0)
		col *= 0.0;
	
	col*=1.0-0.65*vec3(clamp((mod(FRAGCOORD.x, 2.0)-1.0)*2.0,0.0,1.0));
	
    float comp = smoothstep( 0.1, 0.9, sin(TIME) );
 

    COLOR = vec4(col,1.0);
}
*/