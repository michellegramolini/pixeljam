extends Node2D

signal reset_stage

onready var level_flag = get_node("../LevelFlag")
onready var player_hurtbox = get_node("../Player/Hurtbox")

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_flag != null:
		level_flag.connect("stage_clear", self, "_on_LevelFlag_stage_clear")
	else:
		print(str(self) + " Cannot find LevelFlag in the scene tree.")

	if player_hurtbox != null:
		player_hurtbox.connect("player_hurt", self, "_on_Player_hurt")
	else:
		print(str(self) + " Cannot find Player in the scene tree.")

func _on_LevelFlag_stage_clear():
	# TODO: display level clear menu/scene
	print("Stage Clear!")
	emit_signal("reset_stage")

func _on_Player_hurt():
	print("Player Hurt!")
	emit_signal("reset_stage")


