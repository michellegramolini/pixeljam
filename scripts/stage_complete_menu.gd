extends CanvasLayer


onready var level_flag = get_node("../LevelFlag")
onready var total_points_label = get_node("Info/Points")
onready var time_label = get_node("Info/Time")
onready var continue_button = get_node("ContinueButton")


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	continue_button.connect("pressed", self, "_on_ContinueButton_pressed")

	if level_flag:
		level_flag.connect("stage_clear", self, "_on_LevelFlag_stage_clear")
	
func show_menu():
	get_tree().paused = true
	show()

func hide_menu():
	get_tree().paused = false
	hide()

# Signals
func _on_ContinueButton_pressed():
	print("Continue")
	hide_menu()
	# Go to level select
	get_tree().change_scene("res://scenes/menus/Main Menu.tscn")

func _on_LevelFlag_stage_clear(points, time):
	total_points_label.text = str(points)
	time_label.text = time
	show_menu()
