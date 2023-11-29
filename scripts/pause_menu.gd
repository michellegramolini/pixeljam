extends Control

var game_paused: bool
enum menu_buttons {RESUME, MENU} 
var selected_button

func _ready():
	game_paused = false
	#set_focus(menu_buttons.RESUME)
	
func _process(delta):
	if Input.is_action_just_pressed(InputActions.PAUSE):
		handle_pause_press()
		
	if game_paused:
		if Input.is_action_just_pressed(InputActions.UI_ACCEPT):
			handle_ui_input(InputActions.UI_ACCEPT)
			
		if Input.is_action_just_pressed(InputActions.UI_UP):
			handle_ui_input(InputActions.UI_UP)
			
		if Input.is_action_just_pressed(InputActions.UI_DOWN):
			handle_ui_input(InputActions.UI_DOWN)


func handle_pause_press():
	game_paused = !game_paused
	set_pause_menu_visibilty(game_paused)
	get_tree().paused = game_paused

func set_pause_menu_visibilty(vis):
	$"menu_button".set_process(vis)
	$"menu_button".visible = vis
	$"resume_button".set_process(vis)
	$"resume_button".visible = vis
	
	
func handle_ui_input(ui_action):
	if ui_action == InputActions.UI_DOWN:
		if selected_button == menu_buttons.RESUME || selected_button == null:
			set_focus(menu_buttons.MENU)
			
	if ui_action == InputActions.UI_UP:
		if selected_button == menu_buttons.MENU || selected_button == null:
			set_focus(menu_buttons.RESUME)
		
	if ui_action == InputActions.UI_ACCEPT:
		if selected_button == menu_buttons.MENU:
			go_to_main_menu()
		else:
			handle_pause_press()
		
func set_focus(button):
	if button == menu_buttons.RESUME:
		selected_button = menu_buttons.RESUME
		$"resume_button".grab_focus()
		
	elif button == menu_buttons.MENU:
		selected_button = menu_buttons.MENU
		$"menu_button".grab_focus()
		

func go_to_main_menu():
	get_tree().change_scene("res://Scenes/menus/main_menu.tscn") # TODO A second PR will be made for fixing naming with spaces. sry 0.0
	get_tree().paused = false
	
