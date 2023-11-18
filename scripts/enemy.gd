extends KinematicBody2D

# Scripts
const Animations = preload("res://scripts/animations.gd")

# Export variables
export var horizontal_motion: bool = true
export var motion_distance: float = 100.0
export var motion_speed: float = 2.0

var starting_position: Vector2
var timer: float = 0.0
var disabled_duration = 1.0  # Duration to disable collisions
var disabled_timer = 0.0  # Timer to track disabled time
var player

# Onready variables
onready var enemy_sprite = $AnimatedSprite
onready var player_node = get_node("../Player")

func _ready():
	starting_position = global_position

	if player_node != null:
		# Player node exists, assign it to a variable
		player = player_node as KinematicBody2D  # Assuming the player is a KinematicBody2D
		player.hitbox.connect("body_entered", self, "_on_player_landed_on_enemy")
	else:
		# Player node doesn't exist or couldn't be found
		print(str(self) + " Cannot find Player node in the scene tree.")

func _process(delta):
	# Check if the enemy is disabled
	if disabled_timer > 0:
		# Disable collisions for a specific duration
		set_collision_layer_bit(0, false)  # Disable the collision layer temporarily
		set_collision_mask_bit(0, false)  # Disable collision mask temporarily
		enemy_sprite.visible = false  # Hide the enemy sprite
		disabled_timer -= delta
	else:
		# Enable collisions after the disabled duration
		set_collision_layer_bit(0, true)  # Enable the collision layer
		set_collision_mask_bit(0, true)  # Enable collision mask
		enemy_sprite.visible = true  # Hide the enemy sprite
		
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


func disable_for_duration(duration: float):
	"""Temporarily disable collisons and sprites on an enemy for a specific duration."""
	disabled_timer = duration

# Signals
func _on_player_landed_on_enemy(enemy: KinematicBody2D):
	"""Perform actions when the player lands on an enemy"""
	if enemy == self:
		# Disable the enemy for a specific duration
		disable_for_duration(disabled_duration)


