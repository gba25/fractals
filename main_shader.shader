shader_type canvas_item;


uniform int iter;
uniform vec2 center;
uniform float scale;
uniform sampler2D pallete;
uniform int palleteN;
uniform int palleteL;

uniform vec2 centerx;
uniform vec2 centery;


vec4 plt(float cl){
	vec4 cc = texelFetch(pallete,ivec2(palleteN,int(cl*float(palleteL))),0);
	return cc;
}




void fragment() {
	float x = 0.0;
	float y = 0.0;
	float x2 = 0.0;
	float y2 = 0.0;
	float x0 = ((-2.5 + UV.x*3.5)/scale - center[0]);
	float y0 = ((-1.0 + UV.y*2.0)/scale - center[1]);
	int count = iter - 1;
	for(int i = 0; i < iter; i++){
		if(x2 + y2 >= 4.0){
			count = i;
			break;
		}
		y = (x + x)*y + y0;
		x = x2 - y2 + x0;
		x2 = x*x;
		y2 = y*y;
	}
	float cl = float(count)/float(iter);
	vec4 col = plt(cl);
	COLOR = col;
	
}