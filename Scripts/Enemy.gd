class_name Enemy
extends CharacterBody2D

@export var enemy_config: EnemyConfig

var current_health: int

func _ready():
	if enemy_config:
		current_health = enemy_config.max_health
		print("%s initialized with %d health." % [enemy_config.enemy_name, current_health])
		# Example: Set movement speed from config
		# var speed = enemy_config.movement_speed
		# Example: Load sprite if using AnimatedSprite2D
		# $AnimatedSprite2D.frames = load(enemy_config.sprite_atlas) 
	else:
		push_warning("EnemyConfig not assigned to " + name)

func take_damage(amount: int):
	if enemy_config:
		current_health -= amount
		print("%s took %d damage. Health: %d" % [enemy_config.enemy_name, amount, current_health])
		if current_health <= 0:
			die()
	else:
		push_warning("EnemyConfig missing; cannot process damage.")

func die():
	if enemy_config:
		print("%s died!" % enemy_config.enemy_name)
		# Play death sound if configured
		# if $AudioStreamPlayer and enemy_config.death_sound:
		#     $AudioStreamPlayer.stream = enemy_config.death_sound
		#     $AudioStreamPlayer.play()
		# Handle loot drops and XP
	queue_free()
