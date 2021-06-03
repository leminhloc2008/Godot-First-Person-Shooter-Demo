extends KinematicBody

# stats
var curHp : int = 10
var maxHp : int = 10
var ammo : int = 15
var score: int = 0

# physics
var moveSpeed : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 12.0

# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0

# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

#weapon controller
var current_weapon = 1
onready var shotgun = $Camera/shotgun
onready var machineGun = $Camera/machineGun
onready var pistol = $Camera/pistol

# components
onready var camera : Camera = get_node("Camera")
onready var muzzle : Spatial = get_node("Camera/Muzzle")
onready var bulletShotgun = load("res://Bullet.tscn")
onready var bulletPistol = load("res://BulletPistol.tscn")
onready var bulletMachinegun = load("res://BulletMachinegun.tscn")
onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")

remote func _set_position(pos):
	global_transform.origin = pos
	
	
func _ready ():
	
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# set the UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(ammo)
	ui.update_score_text(score)

# called 60 times a second
func _physics_process(delta):
	
	weapon_select()
	
	# reset the x and z velocity
	vel.x = 0
	vel.z = 0
	
	
	var input = Vector2()
	
	# movement inputs
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
		
	input = input.normalized()
	
	# get the forward and right directions
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	# set the velocity
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed	
	
	# apply gravity
	vel.y -= gravity * delta
	
	
	# move the player
	vel = move_and_slide(vel, Vector3.UP)
	
	# jumpings
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
	pass
	
# called every frame	
func _process(delta):
	
	# rotate the camera along the x axis
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	# clamp camera x rotation axis
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate the player along their y axis
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	# reset the mouse delta vector
	mouseDelta = Vector2()
	
	# check to see if we have shot
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot()
	pass
	
# called when an input is detected
func _input(event):
	
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if current_weapon < 3:
					current_weapon += 1
				else:
					current_weapon = 1
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if current_weapon > 1:
					current_weapon -= 1
				else:
					current_weapon = 3
	pass

#change weapon
func weapon_select():
	
	if Input.is_action_just_pressed("pistol"):
		current_weapon = 1
	elif Input.is_action_just_pressed("shotgun"):
		current_weapon = 2
	elif Input.is_action_just_pressed("machinegun"):
		current_weapon = 3
		
	if current_weapon == 1:
		shotgun.visible = true
		
	else:
		shotgun.visible = false

	if current_weapon == 2:
		machineGun.visible = true
		
	else:
		machineGun.visible = false

	if current_weapon == 3:
		pistol.visible = true
		
	else:
		pistol.visible = false

# called when we press the shoot button - spawn a new bullet	
func shoot ():
	#change bullet
	var bullet
	if(current_weapon==1):
		bullet = bulletShotgun.instance()
	elif(current_weapon==2):
		bullet = bulletMachinegun.instance()
	elif(current_weapon==3):
		bullet = bulletPistol.instance()
	#spawn a new bullet and move it 	
	get_node("/root/MainScene").add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform
	
	ammo -= 1
	
	ui.update_ammo_text(ammo)
	pass

# called when an enemy damages us
func take_damage (damage):
	
	curHp -= damage
	
	ui.update_health_bar(curHp, maxHp)
	
	if curHp <= 0:
		die()
	pass

# called when our health reaches 0	
func die ():
	
	get_tree().reload_current_scene()
	pass
	
func add_score (amount):
	
	score += amount
	ui.update_score_text(score)
	pass
	
func add_health (amount):
	
	curHp += amount
	
	if curHp > maxHp:
		curHp = maxHp
		
	ui.update_health_bar(curHp, maxHp)
	pass

func add_small_health (small_amount):
	
	curHp += small_amount
	
	if curHp > maxHp:
		curHp = maxHp
		
	ui.update_health_bar(curHp, maxHp)
	pass
		
func add_ammo (amount):
	
	ammo += amount
	ui.update_ammo_text(ammo)
	pass
	
func add_small_ammo (small_amount):
	
	ammo += small_amount
	ui.update_ammo_text(ammo)
	pass
pass
