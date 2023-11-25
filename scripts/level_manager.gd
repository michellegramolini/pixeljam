extends Node2D

signal reset_stage

onready var player_hurtbox = get_node("../Player/Hurtbox")
onready var player_hitbox = get_node("../Player/Hitbox")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Do these even work like i think they do?
	if player_hurtbox != null:
		player_hurtbox.connect("player_hurt", self, "_on_Player_hurt")
	else:
		print(str(self) + " Cannot find Player in the scene tree.")

	if player_hitbox != null:
		player_hitbox.connect("player_landed_on_spikes", self, "_on_Player_hurt")
	else:
		print(str(self) + " Cannot find Player in the scene tree.")

# Signals
func _on_Player_hurt():
	emit_signal("reset_stage")


