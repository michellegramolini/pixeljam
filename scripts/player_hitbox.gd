extends Area2D

signal player_landed_on_enemy(enemy)

func _ready():
	set_collision_layer_bit(0, false)  # Set the collision layer to match the player or other layers
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		emit_signal("player_landed_on_enemy", null)

