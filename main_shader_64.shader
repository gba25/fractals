shader_type canvas_item;


uniform int iter;
uniform vec2 center;
uniform vec2 centerx;
uniform vec2 centery;
uniform float scale;
uniform sampler2D pallete;
uniform int palleteN;
uniform int palleteL;


vec4 plt(float cl){
	vec4 cc = texelFetch(pallete,ivec2(palleteN,int(cl*float(palleteL))),0);
	return cc;
}

vec2 myvec2(vec2 x){
	vec2 ans=x;
	if(abs(x[0])<abs(x[1])){
		ans[1]=x[0];
		ans[0]=x[1];
	}
	return ans;
}


vec2 mul(vec2 x1,vec2 x2){
	vec2 ans;
	//float tmp;
	float x10 = x1[0];
	float x11 = x1[1];
	float x20 = x2[0];
	float x21 = x2[1];
	ans[0]=x10*x20;
	ans[1]=x11*x20+x10*x21+x11*x21;
	if(abs(ans[0])>=10.0){
		//tmp = ans[0];
		ans[0] = ans[1]+ans[0];
		ans[1] = 0.0;
	}
	return ans;
}




void fragment() {
	vec2 x = vec2(0.0,0.0);
	vec2 y = vec2(0.0,0.0);
	vec2 x2 = vec2(0.0,0.0);
	vec2 y2 = vec2(0.0,0.0);
	vec2 x0 = vec2(-centerx[0]-centerx[1],+(-2.5 + UV.x*3.5)/scale);
	vec2 y0 = vec2(-centery[0]-centery[1],+(-1.0 + UV.y*2.0)/scale);
	int count = iter - 1;
	for(int i = 0; i < iter; i++){
		if(x2[0] + y2[0] + x2[1] +y2[1]>= 4.0){
			count = i;
			break;
		}
		y = mul(x + x,y) + y0;
		x = x2 - y2 + x0;
		x2 = mul(x,x);
		y2 = mul(y,y);
	}
	float cl = float(count)/float(iter);
	vec4 col = plt(cl);
	COLOR = col;
	
}
