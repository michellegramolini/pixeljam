extends Control

var start_time: int = 0

onready var label: RichTextLabel = $RichTextLabel
onready var timer: Timer = $Timer

func _ready():
	start_time = OS.get_ticks_msec()
	timer.connect("timeout", self, "_on_Timer_timeout")

	timer.start()

func _on_Timer_timeout():
	var current_time = OS.get_ticks_msec()
	var elapsed_time = current_time - start_time

	var elapsed_seconds = elapsed_time / 1000
	var elapsed_milliseconds = elapsed_time % 1000

	var elapsed = "%02d:%02d:%03d" % [elapsed_seconds / 60, elapsed_seconds % 60, elapsed_milliseconds]
	label.bbcode_text = elapsed
