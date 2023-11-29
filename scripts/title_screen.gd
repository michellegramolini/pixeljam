extends CanvasLayer

onready var animated_sprite = $Control/AnimatedSprite
onready var start_button = $Control/StartButton
onready var quit_button = $Control/QuitButton
onready var music_manager = $MusicManager
signal play_intro_cutscene

const IDLE = "idle"
const DEFAULT = "default"
const SHINY = "shine"

var time_elapsed: float = 0.0
var interval: float = 5.0
var shiny_done = false
var focused_button: Button = null

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.set_disabled(false)
	quit_button.set_disabled(false)

	# Connect buttons
	start_button.connect("pressed", self, "_on_StartButton_pressed")
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")

	# Connect animation events
	animated_sprite.connect("animation_finished", self, "_on_animation_finished")
	animated_sprite.play(DEFAULT)
	
	# Enable input handling for navigation
	set_process_input(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta

	if time_elapsed >= interval:
		# Play the "shiny" animation
		animated_sprite.play(SHINY)
#		# Reset the timer for the next 5-second interval
		time_elapsed = 0.0
	else:
		if animated_sprite.animation != DEFAULT and shiny_done:
			shiny_done = false
			animated_sprite.play(IDLE) 

# Input Handling for Button Navigation
func _input(event):
	if event.is_action_pressed("ui_up"):
		focus_button(start_button)
		get_tree().set_input_as_handled()

	elif event.is_action_pressed("ui_down"):
		focus_button(quit_button)
		get_tree().set_input_as_handled()

	elif event.is_action_pressed("ui_select"):
		if focused_button == start_button:
			_on_StartButton_pressed()
		elif focused_button == quit_button:
			_on_QuitButton_pressed()

# Custom function to set focus to a specific button
func focus_button(button: Button):
	focused_button = button
	button.grab_focus()

# Signals

# This method is called when any animation finishes playing
func _on_animation_finished():
	if animated_sprite.animation == DEFAULT:
		# Play music
		music_manager.play_title_music()
		# After the "default" animation finishes, start the "idle" animation
		animated_sprite.play(IDLE)
	if animated_sprite.animation == SHINY:
		shiny_done = true

func _on_StartButton_pressed():
	# Stop music
	music_manager.stop_title_music()
	# Play sound effect
	music_manager.play_start_effect()
	# Replace with function body.
	start_button.set_disabled(true)
	yield(get_tree().create_timer(0.5), "timeout")
	# Start cutscene
	emit_signal("play_intro_cutscene")

func _on_QuitButton_pressed():
	# Replace with function body.
	quit_button.set_disabled(true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()


func reset_start_button():
	start_button.set_disabled(false)
	
