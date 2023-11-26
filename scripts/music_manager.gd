extends Node2D

onready var level_music = get_node("Music")
onready var victory_music = get_node("Victory")
onready var level_starter = get_tree().get_nodes_in_group("Start")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to the Start node to start the timer
	if level_starter != null and len(level_starter) > 0:
		level_starter[0].connect("start_level", self, "_on_Start_start_level")

# Signals
func _on_Start_start_level():
	level_music.play()
