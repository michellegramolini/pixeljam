extends StaticBody2D

onready var player_node = get_node("../Player")
onready var level_manager = get_node("../LevelManager")
onready var sprite = $Sprite
onready var collider = $CollisionShape2D

var player

func _ready():
	if player_node != null:
		# Player node exists, assign it to a variable
		player = player_node as KinematicBody2D  # Assuming the player is a KinematicBody2D
		player.hitbox.connect("body_entered", self, "_on_player_smashed_breakable")
	else:
		# Player node doesn't exist or couldn't be found
		print(str(self) + " Cannot find Player node in the scene tree.")

	if level_manager != null:
		# Level manager node exists, connect to the reset signal
		level_manager.connect("reset_stage", self, "_on_LevelManager_reset_stage")
	else:
		# Level manager node doesn't exist or couldn't be found
		print(str(self) + " Cannot find LevelManager node in the scene tree.")


func disable():
	set_collision_layer_bit(0, false)  # Disable the collision layer
	set_collision_mask_bit(0, false)  # Disable collision mask
	collider.disabled = true
	sprite.visible = false

# TODO: might use later will delete if not
func enable():
	set_collision_layer_bit(0, true)  # Enable the collision layer
	set_collision_mask_bit(0, true)  # Enable collision mask
	collider.disabled = false
	sprite.visible = true

func _on_player_smashed_breakable(breakable: StaticBody2D):
	"""Called when the player smashes a breakable."""
	if breakable == self && player.slammed:
		call_deferred("disable")

func _on_LevelManager_reset_stage():
	"""Called when the level manager resets the stage."""
	call_deferred("enable")
