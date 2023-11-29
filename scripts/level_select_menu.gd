extends Container


enum menu_buttons {ONE, TWO, THREE, BACK} 
var selected_button

func _ready():
	#set_focus(menu_buttons.ONE)
	pass

func change_level(num):
	get_tree().change_scene("res://Scenes/levels/MichelleLevel.tscn")

func go_to_main_view():
	
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")


func handle_ui_input(ui_action):
	if ui_action == InputActions.UI_ACCEPT:
		if selected_button == menu_buttons.ONE:
			change_level("one")
		elif selected_button == menu_buttons.TWO:
			change_level("two")
		elif selected_button == menu_buttons.THREE:
			change_level("three")
		elif selected_button == menu_buttons.BACK:
			go_to_main_view()
			
	if ui_action == InputActions.UI_DOWN:
		if selected_button != menu_buttons.BACK:
			set_focus(menu_buttons.BACK)
			
	if ui_action == InputActions.UI_UP:
		if selected_button == menu_buttons.BACK || selected_button == null:
			set_focus(menu_buttons.TWO)
			
	if ui_action == InputActions.UI_RIGHT:
		if selected_button == null:
			set_focus(menu_buttons.ONE)
		elif selected_button == menu_buttons.ONE:
			set_focus(menu_buttons.TWO)
		elif selected_button == menu_buttons.TWO || selected_button == menu_buttons.BACK:
			set_focus(menu_buttons.THREE)
			
	if ui_action == InputActions.UI_LEFT:
		if selected_button == null:
			set_focus(menu_buttons.ONE)
		elif selected_button == menu_buttons.TWO || selected_button == menu_buttons.BACK:
			set_focus(menu_buttons.ONE)
		elif selected_button == menu_buttons.THREE:
			set_focus(menu_buttons.TWO)
		
func set_focus(button):
	if button == menu_buttons.ONE:
		selected_button = menu_buttons.ONE
		$"1".grab_focus()
		
	elif button == menu_buttons.TWO:
		selected_button = menu_buttons.TWO
		$"2".grab_focus()
		
	elif button == menu_buttons.THREE:
		selected_button = menu_buttons.THREE
		$"3".grab_focus()
		
	elif button == menu_buttons.BACK:
		selected_button = menu_buttons.BACK
		$"back".grab_focus()
	
		
		
func _process(delta):
	if Input.is_action_just_pressed(InputActions.UI_ACCEPT):
		handle_ui_input(InputActions.UI_ACCEPT)
		
	if Input.is_action_just_pressed(InputActions.UI_UP):
		handle_ui_input(InputActions.UI_UP)
		
	if Input.is_action_just_pressed(InputActions.UI_DOWN):
		handle_ui_input(InputActions.UI_DOWN)
	
	if Input.is_action_just_pressed(InputActions.UI_RIGHT):
		handle_ui_input(InputActions.UI_RIGHT)
		
	if Input.is_action_just_pressed(InputActions.UI_LEFT):
		handle_ui_input(InputActions.UI_LEFT)
