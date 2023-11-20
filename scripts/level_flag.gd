extends Area2D

signal stage_clear

func _ready():
	set_collision_layer_bit(0, false)
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("stage_clear")
