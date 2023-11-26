extends CanvasLayer

onready var animated_sprite = $Control/AnimatedSprite

const IDLE = "idle"
const DEFAULT = "default"
const SHINY = "shine"

var time_elapsed: float = 0.0
var interval: float = 5.0
var shiny_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.connect("animation_finished", self, "_on_animation_finished")
	animated_sprite.play(DEFAULT)

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

# This method is called when any animation finishes playing
func _on_animation_finished():
	if animated_sprite.animation == DEFAULT:
		print("DEFAULT animation finished")
		# After the "default" animation finishes, start the "idle" animation
		animated_sprite.play(IDLE)
	if animated_sprite.animation == SHINY:
		shiny_done = true

