extends Node2D

onready var level_music = get_node("Music")
onready var victory_music = get_node("Victory")
onready var title_music = get_node("Title")
onready var cutscene_music = get_node("IntroCut")
onready var start_effect = get_node("Start")
onready var level_starter = get_tree().get_nodes_in_group("Start")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to the Start node to start the timer
	if level_starter != null and len(level_starter) > 0:
		level_starter[0].connect("start_level", self, "_on_Start_start_level")
	else:
		print(str(self) + " Cannot find Start node in the scene tree.")

func play_title_music():
	title_music.play()

func stop_title_music():
	title_music.stop()

func play_start_effect():
	start_effect.play()

func play_cutscene_music():
	cutscene_music.play()

func stop_cutscene_music():
	cutscene_music.stop()

# Signals
func _on_Start_start_level():
	level_music.play()
