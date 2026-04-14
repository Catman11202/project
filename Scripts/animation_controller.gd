extends AnimatedSprite2D

func _process(_delta):
	# Play 'walk' if moving, otherwise 'idle'
	if Input.is_action_pressed("right"):
		play("Walk")
		flip_h = false  # Face right
	elif Input.is_action_pressed("left"):
		play("Walk")
		flip_h = true   # Face left
	else:
		play("Idle")
