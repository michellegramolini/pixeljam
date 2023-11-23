extends Area2D

signal player_hurt
signal ran_into_boppable
signal ran_into_gem(gem)

func _ready():
	set_collision_layer_bit(0, false)
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("Hazard"):
		emit_signal("player_hurt")
	if body.is_in_group("Boppable"):
		emit_signal("ran_into_boppable")
	if body.is_in_group("Gem"):
		emit_signal("ran_into_gem", null)
