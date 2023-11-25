extends Area2D

signal player_hit_gem(Gem)

onready var animated_sprite = $AnimatedSprite
onready var collider = $CollisionShape2D
onready var manager_nodes = get_tree().get_nodes_in_group("LevelManager")

func _ready():
	enable()
	connect("body_entered", self, "_on_body_entered")

	if manager_nodes != null and len(manager_nodes) > 0:
		# Level manager node exists, connect to the reset signal
		manager_nodes[0].connect("reset_stage", self, "_on_LevelManager_reset_stage")
	else:
		# Level manager node doesn't exist or couldn't be found
		print(str(self) + " Cannot find LevelManager node in the scene tree.")

func disable():
	collider.disabled = true
	animated_sprite.visible = false

func enable():
	collider.disabled = false
	animated_sprite.visible = true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("player_hit_gem", self)
		call_deferred("disable")

func _on_LevelManager_reset_stage():
	enable()
