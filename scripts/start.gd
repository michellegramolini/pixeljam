extends CanvasLayer

signal start_level

var start

func _ready():
	start = self
	start.visible = true
	get_tree().paused = true
	yield(get_tree().create_timer(2.0), "timeout")  # Pause for 2 seconds
	start.visible = false
	get_tree().paused = false
	emit_signal("start_level")

