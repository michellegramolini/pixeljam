extends KinematicBody2D

# Scripts
const Animations = preload("res://scripts/animations.gd")

# Export variables
export var horizontal_motion: bool = true
export var motion_distance: float = 100.0
export var motion_speed: float = 2.0

var starting_position: Vector2
var timer: float = 0.0

# Onready variables
onready var enemy_sprite = $AnimatedSprite

func _ready():
	starting_position = global_position

func _process(delta):
	# Update the animation
	enemy_sprite.play(Animations.IDLE)

	timer += delta

	var motion: Vector2

	if horizontal_motion:
		# Calculate horizontal motion (left to right)
		motion.x = sin(timer * motion_speed) * motion_distance
		motion.y = 0  # No vertical movement
	else:
		# Calculate vertical motion (up and down)
		motion.x = 0  # No horizontal movement
		motion.y = sin(timer * motion_speed) * motion_distance

	global_position = starting_position + motion
