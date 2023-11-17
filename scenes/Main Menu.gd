extends Container

var buttons = []
var current_button_index = 0

func _ready():
	for child in get_children():
		if child is TextureButton:
			buttons.append(child)

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		navigate(-1)
	elif Input.is_action_just_pressed("ui_down"):
		navigate(1)

func navigate(direction):
	var new_index = (current_button_index + direction) % buttons.size()
	if new_index < 0:
		new_index = buttons.size() - 1
	current_button_index = new_index
	buttons[current_button_index].grab_focus()

func go_to_level_select():
	set_main_screen_visibility(false)
	set_level_screen_visibility(true)
	
func go_to_main_view():
	set_main_screen_visibility(true)
	set_level_screen_visibility(false)

func set_main_screen_visibility(vis):
	$"Quit Button".set_process(vis)
	$"Quit Button".visible = vis
	$"Start Button".set_process(vis)
	$"Start Button".visible = vis


func set_level_screen_visibility(vis):
	$"1".set_process(vis)
	$"1".visible = vis
	$"2".set_process(vis)
	$"2".visible = vis
	$"3".set_process(vis)
	$"3".visible = vis
	$"Back".set_process(vis)
	$"Back".visible = vis
	
	
func change_level(num):
	print("loading level " + num)
	get_tree().change_scene("res://Scenes/TestLevel.tscn") # hard coded until other scenes added
	#get_tree().change_scene("res://Scenes/Levels/Level " + num + ".tscn")
