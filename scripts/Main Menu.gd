extends Container



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
	get_tree().change_scene("res://Scenes/levels/MichelleLevel.tscn") # TODO: hard coded until other scenes added
	#get_tree().change_scene("res://Scenes/Levels/Level " + num + ".tscn")