extends KinematicBody2D

# Scripts
const Animations = preload("res://scripts/animations.gd")

# Export variables
export var horizontal_motion: bool = true
export var motion_distance: float = 100.0
export var motion_speed: float = 2.0

var starting_position: Vector2
var timer: float = 0.0
var player
var previous_direction = Vector2.ZERO

# Onready variables
onready var enemy_sprite = $AnimatedSprite
onready var collider = $CollisionShape2D
onready var player_nodes = get_tree().get_nodes_in_group("Player")
onready var manager_nodes = get_tree().get_nodes_in_group("LevelManager")
# onready var player_node = get_node("../Player")
# onready var level_manager = get_node("../LevelManager")

func _ready():
	starting_position = global_position
	enable()

	if player_nodes != null and len(player_nodes) > 0:
		# Player node exists, assign it to a variable
		player = player_nodes[0]
		player.get_node("Hitbox").connect("body_entered", self, "_on_player_landed_on_enemy")
	else:
		# Player node doesn't exist or couldn't be found
		print(str(self) + " Cannot find Player node in the scene tree.")

	if manager_nodes != null and len(manager_nodes) > 0:
		# Level manager node exists, connect to the reset signal
		manager_nodes[0].connect("reset_stage", self, "_on_LevelManager_reset_stage")
	else:
		# Level manager node doesn't exist or couldn't be found
		print(str(self) + " Cannot find LevelManager node in the scene tree.")

func _process(delta):
	# Update the animation
	enemy_sprite.play(Animations.IDLE)

	timer += delta

	var motion: Vector2
	motion = move_and_slide(motion)

	if horizontal_motion:
		# Calculate horizontal motion (left to right)
		motion.x = sin(timer * motion_speed) * motion_distance
		motion.y = 0  # No vertical movement
	else:
		# Calculate vertical motion (up and down)
		motion.x = 0  # No horizontal movement
		motion.y = sin(timer * motion_speed) * motion_distance
	
	# Flip the sprite based on the direction of horizontal motion
	if motion.x != 0 and motion.x * previous_direction.x < 0:
		# enemy_sprite.scale.x *= -1  # Flip the sprite horizontally
		# var rotation = enemy_sprite.get_rotation_degrees()
		# enemy_sprite.set_rotation_degrees(rotation + 90)
		rotate_object_on_x_axis(180)

	global_position = starting_position + motion
	previous_direction = motion

func rotate_object_on_x_axis(degrees_to_rotate):
	var rotation_radians = deg2rad(degrees_to_rotate)  # Convert degrees to radians
	var cosine = cos(rotation_radians)
	var sine = sin(rotation_radians)

	# Apply rotation on the Y-axis (to simulate X-axis rotation)
	var current_scale = scale
	var new_scale = Vector2(current_scale.x * cosine, current_scale.y)
	scale = new_scale

func disable():
	"""Disable collisions and sprites on an enemy."""
	set_collision_layer_bit(0, false)  # Disable the collision layer temporarily
	set_collision_mask_bit(0, false)  # Disable collision mask temporarily
	collider.disabled = true
	enemy_sprite.visible = false  # Hide the enemy sprite

func enable():
	"""Enable collisions and sprites on an enemy."""
	set_collision_layer_bit(0, true)  # Enable the collision layer
	set_collision_mask_bit(0, true)  # Enable collision mask
	collider.disabled = false
	enemy_sprite.visible = true  # Hide the enemy sprite

# Signals
func _on_player_landed_on_enemy(enemy: KinematicBody2D):
	"""Perform actions when the player lands on an enemy"""
	if enemy == self:
		call_deferred("disable")

func _on_LevelManager_reset_stage():
	"""Perform actions when the level manager resets the stage."""
	call_deferred("enable")

