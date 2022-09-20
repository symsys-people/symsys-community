uniform vec3 diffuse;
uniform float opacity;
#include <common>



// /globe/MAT/pointsParticles/disk1
float disk_feather(float dist, float radius, float feather){
	if(feather <= 0.0){
		if(dist < radius){return 1.0;}else{return 0.0;}
	} else {
		float half_feather = feather * 0.5;
		if(dist < (radius - half_feather)){
			return 1.0;
		} else {
			if(dist > (radius + half_feather)){
				return 0.0;
			} else {
				float feather_start = (radius - half_feather);
				float blend = 1.0 - (dist - feather_start) / feather;
				return blend;
			}
		}
	}
}

float disk2d(vec2 pos, vec2 center, float radius, float feather){
	float dist = distance(pos, center);
	return disk_feather(dist, radius, feather);
}

// function could be called sphere, but is an overload of disk, and is the same
float disk3d(vec3 pos, vec3 center, float radius, float feather){
	float dist = distance(pos, center);
	return disk_feather(dist, radius, feather);
}







// /globe/MAT/pointsParticles/attribute2
uniform sampler2D texture_basecolor_SEPARATOR_hovered;

// /globe/MAT/pointsParticles/attribute1
varying vec2 particles_sim_uv_varying;




#include <color_pars_fragment>
#include <map_particle_pars_fragment>
#include <alphatest_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>
void main() {
	#include <clipping_planes_fragment>
	vec3 outgoingLight = vec3( 0.0 );
	vec4 diffuseColor = vec4( diffuse, opacity );



	// /globe/MAT/pointsParticles/attribute2
	vec3 v_POLY_attribute2_val = texture2D( texture_basecolor_SEPARATOR_hovered, particles_sim_uv_varying ).xyz;
	
	// /globe/MAT/pointsParticles/globals1
	vec2 v_POLY_globals1_gl_PointCoord = gl_PointCoord;
	
	// /globe/MAT/pointsParticles/disk1
	float v_POLY_disk1_float = disk2d(v_POLY_globals1_gl_PointCoord, vec2(0.5, 0.5), 0.23, 0.1);
	
	// /globe/MAT/pointsParticles/output1
	diffuseColor.xyz = v_POLY_attribute2_val;
	diffuseColor.a = v_POLY_disk1_float;



	#include <logdepthbuf_fragment>
	#include <map_particle_fragment>
	#include <color_fragment>
	#include <alphatest_fragment>
	outgoingLight = diffuseColor.rgb;
	#include <output_fragment>
	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
}