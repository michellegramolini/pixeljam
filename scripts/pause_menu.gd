extends Control

var game_paused: bool

func ready():
	game_paused = false
	
func _process(delta):
	if Input.is_action_just_pressed(InputActions.PAUSE):
		handle_pause_press()

func handle_pause_press():
	game_paused = !game_paused
	set_pause_menu_visibilty(game_paused)
	get_tree().paused = game_paused

func set_pause_menu_visibilty(vis):
	$"menu_button".set_process(vis)
	$"menu_button".visible = vis
	$"resume_button".set_process(vis)
	$"resume_button".visible = vis
	
