extends TextureButton


func go_to_main_menu():
	get_tree().change_scene("res://Scenes/menus/Main Menu.tscn") # TODO A second PR will be made for fixing naming with spaces. sry 0.0
	get_tree().paused = false

func focus():
	grab_focus()
