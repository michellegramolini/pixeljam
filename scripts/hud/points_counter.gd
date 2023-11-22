extends Control

onready var player_nodes = get_tree().get_nodes_in_group("Player")
onready var manager_nodes = get_tree().get_nodes_in_group("LevelManager")

# Tracking number of points
var points = 0
var label
var player
var level_manager

func _ready():
	label = $RichTextLabel
	label.text = str(points)

	# TODO: points signal
	if player_nodes != null and len(player_nodes) > 0:
		# Player node exists, assign it to a variable
		player = player_nodes[0]
		player.connect("send_points", self, "_on_send_points")
	else:
		# Player node doesn't exist or couldn't be found
		print(str(self) + " Cannot find Player node in the scene tree.")

	if manager_nodes != null and len(manager_nodes) > 0:
		# LevelManager node exists, assign it to a variable
		level_manager = manager_nodes[0]
		level_manager.connect("reset_stage", self, "_on_LevelManager_reset_stage")
	else:
		# LevelManager node doesn't exist or couldn't be found
		print(str(self) + " Cannot find LevelManager node in the scene tree.")
		

func _on_send_points(points: int):
	update_label(points)

func update_label(add_points: int):
	# Update the Label to display the current points
	points += add_points
	label.text = str(points)

# Signals
func _on_LevelManager_reset_stage():
	# Reset points to 0
	points = 0
	label.text = str(points)
