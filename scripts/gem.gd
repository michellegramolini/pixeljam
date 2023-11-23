extends StaticBody2D


onready var sprite = $AnimatedSprite
onready var collider = $CollisionShape2D
onready var player_nodes = get_tree().get_nodes_in_group("Player")
onready var manager_nodes = get_tree().get_nodes_in_group("LevelManager")

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	enable()
	if player_nodes != null and len(player_nodes) > 0:
		# Player node exists, assign it to a variable
		player = player_nodes[0]
		player.get_node("Hurtbox").connect("body_entered", self, "_on_Player_ran_into_gem")
	else:
		# Player node doesn't exist or couldn't be found
		print(str(self) + " Cannot find Player node in the scene tree.")

	if manager_nodes != null and len(manager_nodes) > 0:
		# Level manager node exists, connect to the reset signal
		manager_nodes[0].connect("reset_stage", self, "_on_LevelManager_reset_stage")
	else:
		# Level manager node doesn't exist or couldn't be found
		print(str(self) + " Cannot find LevelManager node in the scene tree.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func disable():
	"""Disable collisions and sprites on an enemy."""
	set_collision_layer_bit(0, false)  # Disable the collision layer temporarily
	set_collision_mask_bit(0, false)  # Disable collision mask temporarily
	collider.disabled = true
	sprite.visible = false  # Hide the enemy sprite

func enable():
	"""Enable collisions and sprites on an enemy."""
	set_collision_layer_bit(0, true)  # Enable the collision layer
	set_collision_mask_bit(0, true)  # Enable collision mask
	collider.disabled = false
	sprite.visible = true  # Hide the enemy sprite

# Signals
func _on_Player_ran_into_gem(gem: StaticBody2D):
	if gem == self:
		call_deferred("disable")

func _on_LevelManager_reset_stage():
	"""Perform actions when the level manager resets the stage."""
	call_deferred("enable")
