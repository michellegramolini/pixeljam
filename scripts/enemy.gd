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

# Onready variables
onready var enemy_sprite = $AnimatedSprite
onready var collider = $CollisionShape2D
onready var player_node = get_node("../Player")
onready var level_manager = get_node("../LevelManager")

func _ready():
	starting_position = global_position
	enable()

	if player_node != null:
		# Player node exists, assign it to a variable
		player = player_node as KinematicBody2D  # Assuming the player is a KinematicBody2D
		player.hitbox.connect("body_entered", self, "_on_player_landed_on_enemy")
	else:
		# Player node doesn't exist or couldn't be found
		print(str(self) + " Cannot find Player node in the scene tree.")

	if level_manager != null:
		# Level manager node exists, connect to the reset signal
		level_manager.connect("reset_stage", self, "_on_LevelManager_reset_stage")
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

	global_position = starting_position + motion

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

# TODO: reset signal/event. on reset enable character
func _on_LevelManager_reset_stage():
	"""Perform actions when the level manager resets the stage."""
	call_deferred("enable")

