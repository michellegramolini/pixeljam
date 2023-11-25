extends Node2D

onready var start = get_node("Start")

func _ready():
	if start:
		start.visible = true
		print("START!")
		get_tree().paused = true
		yield(get_tree().create_timer(2.0), "timeout")  # Pause for 2 seconds
		start.visible = false
		get_tree().paused = false

