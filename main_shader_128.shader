shader_type canvas_item;


uniform int iter;
uniform vec2 center;
uniform vec4 centerx;
uniform vec4 centery;
uniform float scale;
uniform sampler2D pallete;
uniform int palleteN;
uniform int palleteL;


vec4 plt(float cl){
	vec4 cc = texelFetch(pallete,ivec2(palleteN,int(cl*float(palleteL))),0);
	return cc;
}

int getpow(float x){
	if(x==0.0){
		return 40;
	}
	return abs(int(log(abs(x))/log(10.0)));
}

vec4 myvec(vec4 ans){
	float pr = 1.0;
	
	if(abs(ans[3])>=pr){
		//tmp = ans[0];
		ans[0] = ans[3]+ans[0];
		ans[3] = 0.0;
	}/*else if(abs(ans[3])>=pr*1e-6){
		//tmp = ans[0];
		ans[1] = ans[3]+ans[1];
		ans[3] = 0.0;
	}else if(abs(ans[3])>=pr*1e-12){
		//tmp = ans[0];
		ans[2] = ans[3]+ans[2];
		ans[3] = 0.0;
	}*/
	pr=1.0;/*
	if(getpow(ans[2])<=getpow(ans[1])){
		//tmp = ans[0];
		ans[1] = ans[2]+ans[1];
		ans[2] = 0.0;
	}else*/ if(getpow(ans[2])<=getpow(ans[0])+2){
		//tmp = ans[0];
		ans[0] = ans[2]+ans[0];
		ans[2] = 0.0;
	}
	if(getpow(ans[1])<=getpow(ans[0])+2){
		//tmp = ans[0];
		ans[0] = ans[1]+ans[0];
		ans[1] = 0.0;
	}
	return ans;
}





vec4 mul(vec4 x1,vec4 x2){
	vec4 ans;
	float ans1,ans2,ans3,ans4;
	//float tmp;
	float x = x1[0];
	float dx = x1[1];
	float dx2 = x1[2];
	float dx3 = x1[3];
	float y = x2[0];
	float dy = x2[1];
	float dy2 = x2[2];
	float dy3 = x2[3];
	ans1=x*y;
	ans2=x*dy+y*dx;
	ans3=x*dy2+y*dx2+dx*dy;
	ans4=(x*dy3+y*dx3+dx*dy2+dy*dx2)+(dx*dy3+dy*dx3+dx2*dy2)+(dx2*dy3+dy2*dx3)+(dx3*dy3);
	ans = vec4(ans1,ans2,ans3,ans4);
	//ans = myvec(ans);
	
	return ans;
}




void fragment() {
	vec4 sm = vec4(0.0,0.0,0.0,0.0);
	vec4 x = vec4(0.0,0.0,0.0,0.0);
	vec4 y = vec4(0.0,0.0,0.0,0.0);
	vec4 x2 = vec4(0.0,0.0,0.0,0.0);
	vec4 y2 = vec4(0.0,0.0,0.0,0.0);
	vec4 x0 = vec4(0.0-centerx[0],0.0-centerx[1],0.0-centerx[2],+(-2.5 + UV.x*3.5)/scale-centerx[3]);
	vec4 y0 = vec4(0.0-centery[0],0.0-centery[1],0.0-centery[2],+(-1.0 + UV.y*2.0)/scale-centery[3]);
	int count = iter - 1;
	
	for(int i = 0; i < iter; i++){
		sm=x2+y2;
		if(sm[0] + sm[1] + sm[2] + sm[3] >= 4.0){
			count = i;
			break;
		}
		y = myvec(mul(x + x,y)) + y0;
		x = x2 - y2 + x0;
		x2 = myvec(mul(x,x));
		y2 = myvec(mul(y,y));
	}
	float cl = float(count)/float(iter);
	vec4 col = plt(cl);
	COLOR = col;
	
}
