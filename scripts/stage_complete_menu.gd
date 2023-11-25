extends CanvasLayer


onready var level_flag = get_node("../LevelFlag")
onready var total_points_label = get_node("Info/Points")
onready var time_label = get_node("Info/Time")
onready var continue_button = get_node("ContinueButton")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the menu
	hide()

	continue_button.connect("pressed", self, "_on_ContinueButton_pressed")

	if level_flag:
		level_flag.connect("stage_clear", self, "_on_LevelFlag_stage_clear")

func _input(event):
	if event.is_action_pressed("ui_select"):
		handle_button_press()  # Call a function to handle button press

func handle_button_press():
	# Check if the menu's button has focus or is selected
	if continue_button.has_focus():
		# Perform action when the button is selected or pressed
		continue_button.pressed()  # Simulate button press
				
func show_menu():
	get_tree().paused = true
	show()
	continue_button.grab_focus()

func hide_menu():
	get_tree().paused = false
	hide()

# Signals
func _on_ContinueButton_pressed():
	hide_menu()
	# Go to level select
	get_tree().change_scene("res://scenes/menus/Main Menu.tscn")

func _on_LevelFlag_stage_clear(points, time):
	get_tree().paused = true  # Pause the game

	yield(get_tree().create_timer(2.0), "timeout")  # Pause for 2 seconds

	get_tree().paused = false  # Resume the game
	
	total_points_label.text = str(points)
	time_label.text = time
	show_menu()
