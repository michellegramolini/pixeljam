extends Node2D

var main
var select
export var level_1 = preload("res://scenes/levels/level_one.tscn")
export var level_2 = preload("res://scenes/levels/level_two.tscn")
export var level_3 = preload("res://scenes/levels/level_three.tscn")

func _ready():
	main = $main_menu
	select = $level_select_menu
	#level_1 = $level_1
	#level_2 = $level_2
	#level_3 = $level_3
	
	disable_everything()
	show_main_menu()
	
func show_main_menu():
	disable_everything()
	main.visible = true
	main.set_process(true)

func show_level_select_menu():
	disable_everything()
	select.visible = true
	select.set_process(true)
	
func show_level(num):
	disable_everything()
	if num == "one":
		var level_1_instance = level_1.instance()
		add_child(level_1_instance)
	elif num == "two":
		var level_2_instance = level_2.instance()
		add_child(level_2_instance)
	else:
		var level_3_instance = level_3.instance()
		add_child(level_3_instance)
		

func disable_everything():
	main.visible = false
	main.set_process(false)
	select.visible = false
	select.set_process(false)
	
