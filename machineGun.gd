extends MeshInstance

var ammo = 15 
onready var bulletScene = load("res://Bullet.tscn")
onready var muzzle : Spatial = get_node("muzzle")
onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")

func shoot():
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		fire()
	pass

func fire ():
	
	var bullet = bulletScene.instance()
	get_node("/root/MainScene").add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform
	
	ammo -= 1
	
	ui.update_ammo_text(ammo)
	pass

func add_ammo (amount):
	
	ammo += amount
	ui.update_ammo_text(ammo)
	pass
pass
