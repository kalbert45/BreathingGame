extends Node2D

# handles space bar input
# contains real world node and gameplay node

const MAX_STRENGTH = 250 # maximum strength of exhale
const BREATH_LIMIT = 5 # maximum time limit in seconds

var active = true # determines if input is active
var prepared = true # variable to disallow spamming
var strength = 0 # strength of exhale. Depends on length held

var inhaling = false : set = _set_inhaling

func _ready():
	set_physics_process(false)
	SignalBus.breath_finished.connect(_on_Breath_Finished)

func _on_Breath_Finished():
	prepared = true

func _set_inhaling(value):
	inhaling = value
	if inhaling:
		set_physics_process(true)
	else:
		strength = 0
		set_physics_process(false)

func _unhandled_input(event):
	if !active:
		return
	
	if event.is_action_pressed("breathe"):
		if prepared:
			$level.inhale()
			prepared = false
			self.inhaling = true
	elif event.is_action_released("breathe"):
		if inhaling:
			$level.exhale(strength)
			self.inhaling = false

# about 5 seconds to max
func _physics_process(delta):
	strength = lerpf(strength, MAX_STRENGTH, delta)
