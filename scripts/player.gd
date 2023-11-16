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
export var bop_force = -100.0
export var bop_slam_multiplier = 1.5
export var slam_velocity_multiplier = 1.5

var velocity := Vector2.ZERO

# Onready variables
onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
onready var jump_timer: Timer = $CoyoteTimer
onready var player_sprite = $AnimatedSprite
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox

# Sprite squash and stretch
const SQUASH_X_AMOUNT = 1.2
const SQUASH_Y_AMOUNT = 0.8
const STRETCH_X_AMOUNT = 0.8
const STRETCH_Y_AMOUNT = 1.2
const NORMAL_SCALE = Vector2(1, 1)
const BOP_DURATION = 0.2

var is_falling = false
var facing_direction = 1  # Initially facing right
var jumped = false
var bop_duration = BOP_DURATION
var bopped = false
var slammed = false
var disabled_duration = 1.0  # Duration to disable collisions
var disabled_timer = 0.0  # Timer to track disabled time
var starting_position: Vector2
var reset_position = false
var input_enabled = true

func _ready():
	# Connect signals
	hitbox.connect("player_landed_on_enemy", self, "_on_player_landed_on_enemy")
	hurtbox.connect("player_hurt", self, "_on_player_hurt")

	# Store the initial position when the scene is ready
	starting_position = global_position

func _process(delta):
	flip_sprite()

	# Check if the player is disabled
	if disabled_timer > 0:
		hurtbox.monitorable = false # Disable hurtbox
		input_enabled = false # Disable player controls
		reset_position = true
		player_sprite.visible = false  # Hide the player sprite
		disabled_timer -= delta
	else:
		if reset_position:
			reset_position = false
			position = starting_position  # Reset the position
		# TODO: enable hurtbox
		player_sprite.visible = true  # Hide the player sprite
		hurtbox.monitorable = true # Enable hurtbox
		input_enabled = true # Re-enable player controls

func _physics_process(delta):
	player_sprite.play(Animations.RUN)

	velocity.y += get_gravity() * delta

	# Applying acceleration and friction
	var target_velocity = get_input_velocity() * speed
	#  For smooth speed manipulation, use the interpolate function
	velocity.x = interpolate(velocity.x, target_velocity, acceleration * delta)

	var was_on_floor = is_on_floor()

	if is_on_floor():
		# Reset jump
		jumped = false

	if input_enabled:
		# Jumping
		if Input.is_action_just_pressed(InputActions.JUMP):
			jump()
		if Input.is_action_just_released(InputActions.JUMP):
			cancel_jump()
		# Slam
		if Input.is_action_just_pressed(InputActions.SLAM):
			slam()
		if Input.is_action_just_released(InputActions.SLAM):
			cancel_slam()
	
	# Bopping
	if bopped:
		if bop_duration > 0:
			if slammed:
				velocity = move_and_slide(Vector2(velocity.x * 0.8, bop_force * bop_slam_multiplier))
			else:
				velocity = move_and_slide(Vector2(velocity.x * 0.8, bop_force))
			bop_duration -= delta
		else:
			bopped = false

	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Coyote time
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
	if is_on_floor() or !jump_timer.is_stopped() and jumped == false:
		jumped = true
		# Animation
		player_sprite.scale = Vector2(STRETCH_X_AMOUNT * facing_direction, STRETCH_Y_AMOUNT)
		reset_scale()
		velocity.y = jump_velocity

func cancel_jump():
	"""Cancel the jump if the player releases the jump button early."""
	if velocity.y < variable_jump_velocity_floor:
		velocity.y = variable_jump_velocity_floor

func slam():
	"""Slam the player down"""
	slammed = true
	velocity.y = -jump_velocity * slam_velocity_multiplier

func cancel_slam():
	"""Cancel the slam if the player releases the slam button early."""
	slammed = false

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

func disable_for_duration(duration: float):
	"""Temporarily disable collisons and sprites on an enemy for a specific duration."""
	disabled_timer = duration

# Signals
func _on_player_landed_on_enemy():
	"""Perform actions when the player lands on an enemy"""
	# print("Player landed on enemy!")
	# Indicate you bopped an enemy so we can maniuplate other processes
	bopped = true
	bop_duration = BOP_DURATION

func _on_player_hurt():
	"""Perform actions when the player is hurt"""
	disable_for_duration(disabled_duration)

