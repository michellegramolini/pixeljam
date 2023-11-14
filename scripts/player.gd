extends KinematicBody2D

# Physics properties
export var speed = 200.0
export var jump_height: float
export var jump_time_to_peak: float
export var jump_time_to_descent: float
export var acceleration: float = 1000.0  # Adjust as needed
export var friction: float = 800.0  # Adjust as needed
export var coyote_time: float = 0.15  # Adjust the time in seconds
export var variable_jump_velocity_floor = -80.0 # Adjust as needed

var velocity := Vector2.ZERO

onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
onready var jump_timer: Timer = $CoyoteTimer


func _physics_process(delta):
	velocity.y += get_gravity() * delta

	# Applying acceleration and friction
	var target_velocity = get_input_velocity() * speed
    #  For smooth speed manipulation, use the interpolate function
	velocity.x = interpolate(velocity.x, target_velocity, acceleration * delta)

	var was_on_floor = is_on_floor()

    # Jumping
	if Input.is_action_just_pressed("ui_up"):
		jump()
	if Input.is_action_just_released("ui_up"):
		cancel_jump()

	velocity = move_and_slide(velocity, Vector2.UP)

	if was_on_floor and !is_on_floor():
		jump_timer.start(coyote_time)
	elif is_on_floor():
		jump_timer.stop()

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func get_input_velocity() -> float:
	var horizontal_velocity := 0.0
    # Horizontal movement
	if Input.is_action_pressed("ui_right"):
		horizontal_velocity += 1.0
	if Input.is_action_pressed("ui_left"):
		horizontal_velocity -= 1.0
	
	return horizontal_velocity

func jump():
    """When Jump action is pressed, Jump if the player is on the floor or within the coyote time."""
    if is_on_floor() or !jump_timer.is_stopped():
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

