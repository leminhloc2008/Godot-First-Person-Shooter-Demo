extends Control

#weapon display
onready var shotgun = $shotgun
onready var machineGun = $machineGun
onready var pistol = $pistol

#node
onready var healthBar : TextureProgress = get_node("HealthBar")
onready var ammoText : Label = get_node("AmmoText")
onready var scoreText : Label = get_node("ScoreText")
onready var weaponText : Label = get_node("Weapon")
onready var player : Node = get_node("/root/MainScene/Player")

#change weapon display
func _physics_process(delta):
	if player.current_weapon == 1:
		shotgun.visible = true
		weaponText.text = "Shotgun"
		
	else:
		shotgun.visible = false

	if player.current_weapon == 2:
		machineGun.visible = true
		weaponText.text = "Machine Gun"
	else:
		machineGun.visible = false

	if player.current_weapon == 3:
		pistol.visible = true
		weaponText.text = "Pistol"
		
	else:
		pistol.visible = false
	pass
	
func update_health_bar (curHp, maxHp):
	
	healthBar.max_value = maxHp
	healthBar.value = curHp
	pass
	
func update_ammo_text (ammo):
	
	ammoText.text = str(ammo)
	pass
	
func update_score_text (score):
	
	scoreText.text = "Score: " + str(score)
	pass
pass
