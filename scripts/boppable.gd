extends StaticBody2D

# scripts
const Animations = preload("res://scripts/animations.gd")

# onready var player_node = get_node("../Player")
onready var player_nodes = get_tree().get_nodes_in_group("Player")
onready var manager_nodes = get_tree().get_nodes_in_group("LevelManager")
# onready var level_manager = get_node("../LevelManager")
onready var sprite = $AnimatedSprite
onready var collider = $CollisionShape2D

var player
export var disabled_duration = 1.0  # Duration to disable collisions
var disabled_timer = 0.0  # Timer to track disabled time

func _ready():
	enable()
	
	sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

	if player_nodes != null and len(player_nodes) > 0:
		# Player node exists, assign it to a variable
		player = player_nodes[0]
		player.get_node("Hitbox").connect("body_entered", self, "_on_Player_landed_on_boppable")
		player.get_node("Hurtbox").connect("body_entered", self, "_on_Player_ran_into_boppable")
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
	if disabled_timer > 0:
		disabled_timer -= delta
	else:
		# Enable collisions after the disabled duration
		sprite.play(Animations.BOPPABLE_IDLE)
		enable()

func disable():
	disable_collisions()
	disable_sprite()

func disable_collisions():
	set_collision_layer_bit(0, false)  # Disable the collision layer
	set_collision_mask_bit(0, false)  # Disable collision mask
	collider.disabled = true

func disable_sprite():
	sprite.visible = false

# TODO: might use later will delete if not
func enable():
	set_collision_layer_bit(0, true)  # Enable the collision layer
	set_collision_mask_bit(0, true)  # Enable collision mask
	collider.disabled = false
	sprite.visible = true

func disable_for_duration(duration: float):
	"""Temporarily disable collisons and sprites on an enemy for a specific duration."""
	# Play animation
	sprite.stop()
	sprite.play(Animations.BOPPABLE_BREAK)
	# Start timer
	disabled_timer = duration

func _on_Player_landed_on_boppable(boppable):
	"""Called when the player lands on a boppable."""
	if boppable == self:
		disable_for_duration(disabled_duration)

func _on_Player_ran_into_boppable(boppable):
	"""Called when the player runs into a boppable."""
	if boppable == self:
		disable_for_duration(disabled_duration)

func _on_LevelManager_reset_stage():
	"""Called when the level manager resets the stage."""
	call_deferred("enable")

func _on_AnimatedSprite_animation_finished():
	"""Called when the AnimatedSprite finishes playing an animation."""
	if sprite.animation == Animations.BOPPABLE_BREAK:
		# Disable sprites and collisions
		disable()
