extends Control

onready var player_node = get_tree().get_nodes_in_group("Player")

# Tracking number of points
var points = 0
var label
var player

func _ready():
	label = $RichTextLabel
	label.text = str(points)

	# TODO: points signal
	if player_node != null:
		# Player node exists, assign it to a variable
		player = player_node[0]
		player.connect("send_points", self, "_on_send_points")
	else:
		# Player node doesn't exist or couldn't be found
		print(str(self) + " Cannot find Player node in the scene tree.")

func _on_send_points(points: int):
	update_label(points)

func update_label(add_points: int):
	# Update the Label to display the current points
	points += add_points
	label.text = str(points)
