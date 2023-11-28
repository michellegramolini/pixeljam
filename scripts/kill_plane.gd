extends Area2D

signal player_hit_kill_plane

onready var collider = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("player_hit_kill_plane")

