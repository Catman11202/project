extends CharacterBody2D

enum AI_STATE {
	IDLE,
	PATROL,
	INVESTIGATE,
	CHASE,
	ATTACK,
	STUNNED,
	DEATH
}

var current_state: AI_STATE = AI_STATE.IDLE

# More AI logic will go here later

func _physics_process(delta: float):
	match current_state:
		AI_STATE.IDLE:
			_handle_idle_state(delta)
		AI_STATE.PATROL:
			_handle_patrol_state(delta)
		AI_STATE.INVESTIGATE:
			_handle_investigate_state(delta)
		AI_STATE.CHASE:
			_handle_chase_state(delta)
		AI_STATE.ATTACK:
			_handle_attack_state(delta)
		AI_STATE.STUNNED:
			_handle_stunned_state(delta)
		AI_STATE.DEATH:
			_handle_death_state(delta)

# Placeholder functions for each state (we'll implement these fully in the next step)
func _handle_idle_state(delta: float):
	pass # Placeholder for idle logic

func _handle_patrol_state(delta: float):
	pass # Placeholder for patrol logic

func _handle_investigate_state(delta: float):
	pass # Placeholder for investigate logic

func _handle_chase_state(delta: float):
	pass # Placeholder for chase logic

func _handle_attack_state(delta: float):
	pass # Placeholder for attack logic

func _handle_stunned_state(delta: float):
	pass # Placeholder for stunned logic

func _handle_death_state(delta: float):
	pass # Placeholder for death logic
