extends CanvasLayer

onready var animation = get_node("Control/AnimatedSprite")
onready var music_manager = $MusicManager

const DEFAULT = "default"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect animation events
	animation.connect("animation_finished", self, "_on_animation_finished")
	
	# Play cutscene
	play_cutscene()


func play_cutscene():
	animation.play(DEFAULT)
	# Wait before starting music
	yield(get_tree().create_timer(0.2), "timeout")
	# Start music
	music_manager.play_cutscene_music()
	
func _on_animation_finished():
	#music_manager.stop_cutscene_music()
	# Wait before transitioning
	yield(get_tree().create_timer(0.5), "timeout")
	# Transition to level select
	get_tree().change_scene("res://scenes/menus/level_select_menu.tscn")
