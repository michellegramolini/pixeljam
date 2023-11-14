extends KinematicBody2D

# Declare member variables here. Examples:
var speed = 200
var velocity = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Player movement
	velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
	move_and_slide(velocity)
