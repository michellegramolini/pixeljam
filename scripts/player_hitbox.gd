extends Area2D

signal player_landed_on_enemy(enemy)
signal player_slammed_breakable(breakable)

func _ready():
	set_collision_layer_bit(0, false)  # Set the collision layer to match the player or other layers
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		emit_signal("player_landed_on_enemy", null)
	if body.is_in_group("Breakable"):
		emit_signal("player_slammed_breakable", null)


