extends Node2D

# handles space bar input
# contains real world node and gameplay node

const MAX_STRENGTH = 250 # maximum strength of exhale
const BREATH_LIMIT = 5 # maximum time limit in seconds

var active = true # determines if input is active
var prepared = true # variable to disallow spamming
var strength = 0 # strength of exhale. Depends on length held
var level

var inhaling = false : set = _set_inhaling

func _ready():
	level = $level
	set_physics_process(false)
	SignalBus.breath_finished.connect(_on_Breath_Finished)
	SignalBus.level_cleared.connect(_on_Level_Cleared)

func _on_Breath_Finished():
	prepared = true

func _on_Level_Cleared(s, l):
	# 'clear' feedback
	# wait a bit
	await get_tree().create_timer(0.5).timeout
	# if there is a next level, add it. else, progress situation
	var max_levels = Global.num_levels[s]
	if l < max_levels - 1:
		var new_l = l+1
		var new_level = load("res://Scenes/Game/levels/situation"+str(s)+"/breath"+str(s)+"_"+str(new_l)+".tscn")
		level = new_level.instantiate()
		add_child(level)
		
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
			level.inhale()
			prepared = false
			self.inhaling = true
	elif event.is_action_released("breathe"):
		if inhaling:
			level.exhale(strength)
			self.inhaling = false

# about 5 seconds to max
func _physics_process(delta):
	strength = lerpf(strength, MAX_STRENGTH, delta)
