extends CharacterBody2D

enum ZombieState { IDLE, PATROL, CHASE, ATTACK, INVESTIGATE, STUNNED, KING_COMMANDED }

@export var current_state: ZombieState = ZombieState.IDLE
@export var detection_range: float = 200.0
@export var attack_range: float = 50.0
@export var patrol_speed: float = 50.0
@export var chase_speed: float = 100.0
@export var stun_duration: float = 2.0 # For stun state

var player: Node2D = null # Reference to the protagonist
var timer: Timer = null # For timed states like STUNNED or INVESTIGATE

func _ready():
	# Find the player in the scene (adjust path as needed)
	# For simplicity, we'll assume the player is in the main scene tree.
	# In a real game, you might use a GameManager singleton to store player reference.
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("Player node not found in group 'player'!")

	# Initialize timer if needed (e.g., for 'STUNNED' state)
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(on_timer_timeout)

func _physics_process(delta: float):
	_handle_state_transitions()
	_execute_current_state_behavior(delta)

func _handle_state_transitions():
	# Priority order: Critical > High > Medium > Low

	var distance_to_player = 1000000.0 # Effectively infinity if player is null or far
	if player:
		distance_to_player = global_position.distance_to(player.global_position)

	# 1. Critical: STUNNED overrides everything else
	if current_state == ZombieState.STUNNED:
		# Stunned state handles its own exit via timer
		return

	# 2. High Priority: Zombie King Command (e.g., "rally", "attack specific target")
	#    This would likely be an event-driven check in a more complex system,
	#    but for polling, imagine a global flag or a signal listener.
	if GlobalGameData.is_king_command_active() and current_state != ZombieState.KING_COMMANDED:
		change_state(ZombieState.KING_COMMANDED)
		return

	# 3. High Priority: Attack if player is in range and not stunned
	if distance_to_player < attack_range:
		if current_state != ZombieState.ATTACK:
			change_state(ZombieState.ATTACK)
		return

	# 4. Medium Priority: Chase if player is detected and not in attack range
	if player and distance_to_player < detection_range:
		# You might add line-of-sight checks here later
		if current_state != ZombieState.CHASE and current_state != ZombieState.ATTACK:
			change_state(ZombieState.CHASE)
		return

	# 5. Low Priority: Investigate (e.g., heard a noise, lost sight of player)
	#    This typically transitions from CHASE or PATROL if conditions for them are lost.
	#    For simplicity, let's say after losing player sight, they investigate for a bit.
	if current_state == ZombieState.CHASE and (not player or distance_to_player >= detection_range):
		change_state(ZombieState.INVESTIGATE) # Start investigation timer in change_state
		return

	# 6. Default/Low Priority: Patrol or Idle if nothing else is happening
	if current_state != ZombieState.PATROL and current_state != ZombieState.IDLE:
		change_state(ZombieState.PATROL) # Or IDLE, depending on default behavior

func change_state(new_state: ZombieState):
	if current_state == new_state:
		return # No need to change if already in this state

	_exit_state(current_state)
	current_state = new_state
	_enter_state(new_state)
	print("Zombie changed state to: ", ZombieState.keys()[current_state])

func _enter_state(state: ZombieState):
	match state:
		ZombieState.IDLE:
			# Setup for idle, e.g., stop movement
			velocity = Vector2.ZERO
			pass
		ZombieState.PATROL:
			# Setup for patrol, e.g., pick a patrol point
			pass
		ZombieState.CHASE:
			# Setup for chase, e.g., start pathfinding to player
			pass
		ZombieState.ATTACK:
			# Setup for attack, e.g., trigger attack animation, stop movement
			velocity = Vector2.ZERO
			pass
		ZombieState.INVESTIGATE:
			# Setup for investigate, e.g., move to last known player position, start timer
			timer.start(3.0) # Investigate for 3 seconds
			pass
		ZombieState.STUNNED:
			# Setup for stunned, e.g., play stun animation, disable input/movement, start timer
			velocity = Vector2.ZERO
			timer.start(stun_duration)
			pass
		ZombieState.KING_COMMANDED:
			# Setup for King's command, e.g., move to a specific rally point
			pass

func _exit_state(state: ZombieState):
	match state:
		ZombieState.IDLE:
			pass
		ZombieState.PATROL:
			pass
		ZombieState.CHASE:
			pass
		ZombieState.ATTACK:
			# Cleanup after attack, e.g., reset attack cooldown
			pass
		ZombieState.INVESTIGATE:
			timer.stop() # Stop investigate timer if we transition out early
			pass
		ZombieState.STUNNED:
			timer.stop() # Stop stun timer if we transition out early (e.g., hit again, reset stun)
			pass
		ZombieState.KING_COMMANDED:
			pass

func _execute_current_state_behavior(delta: float):
	# This function will contain the actual actions for each state
	# (This is where 'Create State-Specific Behaviors' comes in)
	match current_state:
		ZombieState.IDLE:
			# Play idle animation
			pass
		ZombieState.PATROL:
			# Move along patrol path/randomly
			pass
		ZombieState.CHASE:
			# Move towards player using navigation
			pass
		ZombieState.ATTACK:
			# Perform attack animation/logic
			pass
		ZombieState.INVESTIGATE:
			# Look around, move towards last known player position
			pass
		ZombieState.STUNNED:
			# Just stay put, play stun effect
			pass
		ZombieState.KING_COMMANDED:
			# Execute specific King command (e.g., move to a location, attack a specific target)
			pass

	# Example movement application (adjust based on your CharacterBody2D setup)
	move_and_slide()

func on_timer_timeout():
	# This is called when any timer in the AI script finishes
	# Check which state it was likely used for and transition accordingly
	if current_state == ZombieState.INVESTIGATE:
		change_state(ZombieState.PATROL) # After investigating, return to patrol
	elif current_state == ZombieState.STUNNED:
		change_state(ZombieState.IDLE) # After stun, become idle/patrol (or re-evaluate immediately)

# Call this function from outside (e.g., player hit zombie with specific attack)
func get_stunned(duration: float):
	if current_state != ZombieState.STUNNED:
		stun_duration = duration
		change_state(ZombieState.STUNNED)

# Global variable or signal for King's commands
# In a real game, this might be a singleton or a dedicated King AI script broadcasting signals.
class GlobalGameData:
	static var king_command_active: bool = false
	static func is_king_command_active() -> bool:
		return king_command_active
	static func set_king_command_active(active: bool):
		king_command_active = active

# Example of how the King might activate a command:
# GlobalGameData.set_king_command_active(true) # Zombies would react
