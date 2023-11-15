extends KinematicBody2D

# Scripts
const Animations = preload("res://scripts/animations.gd")
const InputActions = preload("res://scripts/input_actions.gd")

# Properties export
export var speed = 200.0
export var jump_height: float
export var jump_time_to_peak: float
export var jump_time_to_descent: float
export var acceleration: float = 1000.0  # Adjust as needed
export var friction: float = 800.0  # Adjust as needed
export var coyote_time: float = 0.15  # Adjust the time in seconds
export var variable_jump_velocity_floor = -80.0 # Adjust as needed

var velocity := Vector2.ZERO

# Onready variables
onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
onready var jump_timer: Timer = $CoyoteTimer
onready var player_sprite = $AnimatedSprite

# Sprite squash and stretch
const SQUASH_X_AMOUNT = 1.2
const SQUASH_Y_AMOUNT = 0.8
const STRETCH_X_AMOUNT = 0.8
const STRETCH_Y_AMOUNT = 1.2
const NORMAL_SCALE = Vector2(1, 1)

var is_falling = false
var facing_direction = 1  # Initially facing right

func _process(delta):
	flip_sprite()

func _physics_process(delta):
	player_sprite.play(Animations.RUN)

	velocity.y += get_gravity() * delta

	# Applying acceleration and friction
	var target_velocity = get_input_velocity() * speed
	#  For smooth speed manipulation, use the interpolate function
	velocity.x = interpolate(velocity.x, target_velocity, acceleration * delta)

	var was_on_floor = is_on_floor()

	# Jumping
	if Input.is_action_just_pressed(InputActions.JUMP):
		jump()
	if Input.is_action_just_released(InputActions.JUMP):
		cancel_jump()
	
	velocity = move_and_slide(velocity, Vector2.UP)

	if was_on_floor and !is_on_floor():
		jump_timer.start(coyote_time)
	elif is_on_floor():
		jump_timer.stop()

	
	if !is_on_floor() and velocity.y > 0.0:
		is_falling = true

	# Landing
	if is_on_floor() and is_falling:
		is_falling = false
		velocity = Vector2.ZERO
		player_sprite.scale = Vector2(SQUASH_X_AMOUNT * facing_direction, SQUASH_Y_AMOUNT)
		reset_scale()

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func get_input_velocity() -> float:
	var horizontal_velocity := 0.0
	# Horizontal movement
	if Input.is_action_pressed(InputActions.MOVE_RIGHT):
		horizontal_velocity += 1.0
	if Input.is_action_pressed(InputActions.MOVE_LEFT):
		horizontal_velocity -= 1.0
	
	return horizontal_velocity

func jump():
	"""When Jump action is pressed, Jump if the player is on the floor or within the coyote time."""
	if is_on_floor() or !jump_timer.is_stopped():
		# Animation
		player_sprite.scale = Vector2(STRETCH_X_AMOUNT * facing_direction, STRETCH_Y_AMOUNT)
		reset_scale()
		velocity.y = jump_velocity

func cancel_jump():
	"""Cancel the jump if the player releases the jump button early."""
	if velocity.y < variable_jump_velocity_floor:
		velocity.y = variable_jump_velocity_floor

func interpolate(current: float, target: float, delta: float) -> float:
	"""Interpolate between current and target values by delta"""
	if current < target:
		return min(current + delta, target)
	elif current > target:
		return max(current - delta, target)
	else:
		return current

func flip_sprite():
	"""Flip the sprite horizontally"""
	var input_x = Input.get_action_strength(InputActions.MOVE_RIGHT) - Input.get_action_strength(InputActions.MOVE_LEFT)
	if input_x != 0:
		facing_direction = 1 if input_x > 0 else -1
		player_sprite.scale.x = abs(player_sprite.scale.x) * facing_direction

func reset_scale():
	"""Essentially a coroutine to reset the scale of the player sprite after a jump."""
	yield(get_tree().create_timer(0.15), "timeout")  # Adjust the duration as needed
	$AnimatedSprite.scale = Vector2(NORMAL_SCALE.x * facing_direction, NORMAL_SCALE.y)

