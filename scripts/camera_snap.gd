extends Camera2D

const WINDOW_SIZE := Vector2(400, 224)

var current_screen := Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	global_position = get_parent().global_position
	_update_screen(current_screen)
	smoothing_enabled = false
	
func _physics_process(delta):
	smoothing_enabled = true
	var parent_screen : Vector2 = (get_parent().global_position / WINDOW_SIZE).floor()
	
	if not parent_screen.is_equal_approx(current_screen):
		_update_screen(parent_screen)

func _update_screen(new_screen: Vector2):
	current_screen = new_screen
	global_position = current_screen * WINDOW_SIZE + WINDOW_SIZE * 0.5
