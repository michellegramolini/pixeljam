extends Control

var points = 0
var label

func _ready():
	label = $RichTextLabel
	label.text = str(points)

	# TODO: points signal
	get_tree().connect("get_points", self, "_on_get_points")

func _on_get_points():
	# TODO: points value
	points += 10
	update_label()

func update_label():
	# Update the Label to display the current points
	label.text = str(points)
