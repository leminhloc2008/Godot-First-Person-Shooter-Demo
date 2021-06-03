extends KinematicBody

var speed : float = 2.0
var damage : int = 1

# called every frame
func _process(delta):
	
	# move the bullet forwards
	translation -= global_transform.basis.x * speed * delta
	pass
	
pass

func disappeare ():
	
	queue_free()
	pass
	
func _on_Timer_timeout():
	disappeare()
	pass # Replace with function body.
