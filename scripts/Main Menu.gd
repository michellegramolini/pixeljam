extends Container

enum menu_buttons {START, QUIT, ONE, TWO, THREE, BACK} 
var selected_button
var main_view

func _ready():
	main_view = true

func go_to_level_select():
	set_main_screen_visibility(false)
	set_level_screen_visibility(true)
	main_view = false
	
func go_to_main_view():
	set_main_screen_visibility(true)
	set_level_screen_visibility(false)
	main_view = true

func set_main_screen_visibility(vis):
	$"quit_button".set_process(vis)
	$"quit_button".visible = vis
	$"start_button".set_process(vis)
	$"start_button".visible = vis


func set_level_screen_visibility(vis):
	$"1".set_process(vis)
	$"1".visible = vis
	$"2".set_process(vis)
	$"2".visible = vis
	$"3".set_process(vis)
	$"3".visible = vis
	$"back".set_process(vis)
	$"back".visible = vis
	
	
func change_level(num):
	get_tree().change_scene("res://Scenes/levels/MichelleLevel.tscn") # TODO: hard coded until other scenes added
	#get_tree().change_scene("res://Scenes/Levels/Level " + num + ".tscn")
	
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

func handle_ui_input(ui_action):
	print(main_view)
	if ui_action == InputActions.UI_ACCEPT:
		if selected_button == menu_buttons.START:
			go_to_level_select()
		elif selected_button == menu_buttons.QUIT:
			get_tree().quit()
		elif selected_button == menu_buttons.ONE:
			change_level("one")
		elif selected_button == menu_buttons.TWO:
			change_level("two")
		elif selected_button == menu_buttons.THREE:
			change_level("three")
		elif selected_button == menu_buttons.BACK:
			go_to_main_view()
			
	if main_view:
		if ui_action == InputActions.UI_DOWN:
			if selected_button == menu_buttons.START || selected_button == null:
				set_focus(menu_buttons.QUIT)
			
		if ui_action == InputActions.UI_UP:
			if selected_button == menu_buttons.QUIT || selected_button == null:
				set_focus(menu_buttons.START)
	else:
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
	if button == menu_buttons.START:
		selected_button = menu_buttons.START
		$"start_button".grab_focus()
		
	elif button == menu_buttons.QUIT:
		selected_button = menu_buttons.QUIT
		$"quit_button".grab_focus()
		
	elif button == menu_buttons.ONE:
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
	
		

