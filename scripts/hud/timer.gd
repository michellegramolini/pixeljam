extends Control

onready var label: RichTextLabel = $RichTextLabel
onready var timer: Timer = $Timer
onready var manager_nodes = get_tree().get_nodes_in_group("LevelManager")
onready var level_starter = get_tree().get_nodes_in_group("Start")

var start_time: int = 0
var level_manager: Node = null

func _ready():
	if manager_nodes != null and len(manager_nodes) > 0:
		# LevelManager node exists, assign it to a variable
		level_manager = manager_nodes[0]
		level_manager.connect("reset_stage", self, "_on_LevelManager_reset_stage")
	else:
		# LevelManager node doesn't exist or couldn't be found
		print(str(self) + " Cannot find LevelManager node in the scene tree.")
	
	# Connect to the Start node to start the timer
	if level_starter != null and len(level_starter) > 0:
		level_starter[0].connect("start_level", self, "_on_Start_start_level")

func delay(seconds):
	yield(get_tree().create_timer(seconds), "timeout")
	# After the delay, start the timer again
	start_time = OS.get_ticks_msec()
	timer.start()

func get_time():
	return label.bbcode_text

# Signals
func _on_Timer_timeout():
	var current_time = OS.get_ticks_msec()
	var elapsed_time = current_time - start_time

	var elapsed_seconds = elapsed_time / 1000
	var elapsed_milliseconds = elapsed_time % 1000

	var elapsed = "%02d:%02d:%03d" % [elapsed_seconds / 60, elapsed_seconds % 60, elapsed_milliseconds]
	label.bbcode_text = elapsed

func _on_LevelManager_reset_stage():
	timer.stop()
	start_time = OS.get_ticks_msec()
	label.bbcode_text = "00:00:000"
	delay(1.2)

func _on_Start_start_level():
	start_time = OS.get_ticks_msec()
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()


