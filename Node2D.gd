extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rat = 3.5/2.0

onready var sh = preload("res://main_shader.shader")
onready var sh_64 = preload("res://main_shader_64.shader")
onready var sh_128 = preload("res://main_shader_128.shader")
var sp = Sprite.new()
var center = Vector2(0,0)
var centerx = Color(0,0,0,0)
var centery = Color(0,0,0,0)
var w
var h
var mouse_pos = Vector2(0,0)
var sc = 1.0
var iter = 300
var palleteL = 100
var palleteH = 2
var palleteN = 0
var tgl = false
var incs = []
var sc_cnt = 0
var sc_max = 600

func numsc(x):
	if x==0.0:
		return str('0.0')
	var xp = int(log(abs(x))/log(10))
	if pow(10,xp)==0.0:
		return ('0.0')
	var nb = x/pow(10,xp)
	return str(nb)+'e'+str(xp)

func _ready():
	
	
	for _i in range(sc_max):
		incs.append([0.0,0.0])
	var PALLETE_IMAGE = Image.new()
	var PALLETE_TEXTURE = ImageTexture.new()
	
	PALLETE_TEXTURE.create(palleteH,palleteL,11,0)
	PALLETE_IMAGE.create(palleteH,palleteL,false,11)
	PALLETE_IMAGE.lock()
	for i in range(palleteH):
		for j in range(palleteL):
			if i==0:
				var cl = 1-float(j)/palleteL
				PALLETE_IMAGE.set_pixel(i,j,Color(cl,cl,cl,1))
			elif i==1:
				var cl1 = pow(sin(float(j)/palleteL*PI),2)
				var cl2 = pow(sin(float(j)/palleteL*3*PI),2)
				var cl3 = pow(sin(float(j)/palleteL*4*PI),2)
				PALLETE_IMAGE.set_pixel(i,j,Color(cl1,cl2,cl3,1))
	PALLETE_IMAGE.unlock()
	PALLETE_TEXTURE.set_data(PALLETE_IMAGE)
	#print(tst(PALLETE_IMAGE,0,24))
	h = get_viewport().size[1]
	w = h*rat
	#print(w,h)
	var img = Image.new()
	var tx = ImageTexture.new()
	img.create(w, h, false, 11)
	tx.create_from_image(img)
	sp.texture = tx
	sp.material = ShaderMaterial.new()
	sp.material.shader=sh_128
	sp.material.set_shader_param("pallete",PALLETE_TEXTURE)
	sp.material.set_shader_param("palleteN",palleteN)
	sp.material.set_shader_param("palleteL",palleteL)
	sp.material.set_shader_param("center",center)
	sp.material.set_shader_param("centery",0.0)
	sp.material.set_shader_param("centerx",0.0)
	sp.material.set_shader_param("scale",sc)
	sp.material.set_shader_param("iter",iter)
	sp.centered=true
	sp.position = Vector2(w/2,h/2)
	add_child(sp)

func center_set(inc):
	var incx = inc[0]
	var incy = inc[1]
	var sclim=1e6
	var sclim1 = 1e12
	var sclim2 = 1e18
	if sc>sclim2:
		centerx[3]+=incx
		centery[3]+=incy
	elif sc>sclim1:
		centerx[2]+=incx
		centery[2]+=incy
	elif sc>sclim:
		centerx[1]+=incx
		centery[1]+=incy
	else:
		centerx[0]+=incx
		centery[0]+=incy
	
func center_set_1(inc):
	var incx = inc[0]
	var incy = inc[1]
	incs[sc_cnt][0]+=incx
	incs[sc_cnt][1]+=incy


func _process(_delta):
	if Input.is_action_just_pressed("tgl"):
		tgl = not tgl
	if Input.is_action_just_pressed("click"):
		mouse_pos = ms()
		for i in range(4):
			print(numsc(centerx[i]),'----',numsc(centery[i]))
	if Input.is_action_pressed("click"):
		var tmp = ms()
		var inc=(tmp-mouse_pos)/sc
		center+=inc
		#var bx = 1
		#if center[0]>bx or center[0]<-bx:
		#	center[0]-=inc[0]
		#	inc[0]=0.0
		#if center[1]>bx or center[1]<-bx:
		#	center[1]-=inc[1]
		#	inc[1]=0.0
		#incs.append(inc)
		#print(inc*5e15)
		#incs.append(inc)
		center_set(inc)
		#print(centerx,'----',centery)
		mouse_pos=tmp
		sp.material.set_shader_param("centerx",centerx)
		sp.material.set_shader_param("centery",centery)
		sp.material.set_shader_param("center",center)
		#print(center)
	if Input.is_action_just_released("sc_up"):
		sc_cnt+=1
		sc*=1.1
		print(numsc(sc))
		sp.material.set_shader_param("scale",sc)
	if Input.is_action_just_released("sc_down"):
		sc_cnt-=1
		sc/=1.1
		if sc<=1.0:
			sc = 1.0
		print(numsc(sc))
		sp.material.set_shader_param("scale",sc)
	if Input.is_action_just_pressed("reset"):
		center = Vector2(0,0)
		centerx = Color(1.5,0.0,0.0,0.0)
		centery = Color(0.0,0.0,0.0,0.0)
		sc = 1.0
		iter = 300
		sp.material.set_shader_param("scale",sc)
		sp.material.set_shader_param("center",center)
		sp.material.set_shader_param("centerx",centerx)
		sp.material.set_shader_param("centery",centery)
		sp.material.set_shader_param("iter",iter)
	if Input.is_action_just_pressed("inc"):
		iter+=100
		if iter>=10001:
			iter = 1000
		sp.material.set_shader_param("iter",iter)
	if Input.is_action_just_pressed("dec"):
		iter-=100
		if iter<=99:
			iter = 10
		sp.material.set_shader_param("iter",iter)
	if Input.is_action_just_pressed("chng"):
		palleteN+=1
		palleteN%=palleteH
		sp.material.set_shader_param("palleteN",palleteN)
	

func ms():
	var pos = get_viewport().get_mouse_position()-Vector2(w/2,h/2)
	pos[0]*=3.5/w
	pos[1]*=2.0/h
	return pos
