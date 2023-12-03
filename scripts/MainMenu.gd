extends Container

enum menu_buttons {START, QUIT} 
var selected_button


func _ready():
	#set_focus(menu_buttons.START)
	pass
	
func go_to_level_select():
	get_tree().change_scene("res://Scenes/menus/level_select_menu.tscn")
	
func _process(delta):
	if Input.is_action_just_pressed(InputActions.UI_ACCEPT):
		handle_ui_input(InputActions.UI_ACCEPT)
		
	if Input.is_action_just_pressed(InputActions.UI_UP):
		handle_ui_input(InputActions.UI_UP)
		
	if Input.is_action_just_pressed(InputActions.UI_DOWN):
		handle_ui_input(InputActions.UI_DOWN)

func handle_ui_input(ui_action):
	if ui_action == InputActions.UI_ACCEPT:
		if selected_button == menu_buttons.START:
			go_to_level_select()
		elif selected_button == menu_buttons.QUIT:
			get_tree().quit()

	if ui_action == InputActions.UI_DOWN:
		if selected_button == menu_buttons.START || selected_button == null:
			set_focus(menu_buttons.QUIT)
		
	if ui_action == InputActions.UI_UP:
		if selected_button == menu_buttons.QUIT || selected_button == null:
			set_focus(menu_buttons.START)
	
func set_focus(button):
	if button == menu_buttons.START:
		selected_button = menu_buttons.START
		$"start_button".grab_focus()
		
	elif button == menu_buttons.QUIT:
		selected_button = menu_buttons.QUIT
		$"quit_button".grab_focus()
		


func quit_game():
	get_tree().quit()

