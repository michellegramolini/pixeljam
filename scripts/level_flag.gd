extends Area2D

signal stage_clear(points, time)

onready var hud = get_node("../HUD")

var points_counter
var timer

var points
var time

func _ready():
	if hud:
		print("HUD found")
		points_counter = hud.get_node("Control/PointsCounter")
		timer = hud.get_node("Control/HUDTimer")

	set_collision_layer_bit(0, false)
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		points = points_counter.get_points()
		time = timer.get_time()
		print("Stage clear! ", points, " points, ", time, " time")
		emit_signal("stage_clear", points, time)
