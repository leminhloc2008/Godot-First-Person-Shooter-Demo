extends Area

var speed : float = 30.0
var damage : int = 1

# called every frame
func _process(delta):
	
	# move the bullet forwards
	translation += global_transform.basis.z * speed * delta
	pass
	
# destroys the bullet
func destroy ():
	
	queue_free()
	pass

# called when we enter the collider of another body
func _on_Bullet_body_entered(body):
	
	# does this body have a 'take_damage' function?
	# if so, deal damage and destroy the bullet
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
	pass
pass
