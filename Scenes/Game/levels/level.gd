extends Node2D

@export var situation = 0
@export var level = 0
# contains source and wheel nodes
# handles whether input can be handled
# contains inhale and exhale functions

func _ready():
	pass

# show the level
# activate wheels
# play animations
func inhale():
	for d in $demons.get_children():
		d.activate()
	
	$AnimationPlayer.play("fade_in")
	for s in $sources.get_children():
		s.activate_wheels()
	

# call exhale on all sources
# after some time, processes state, determines if cleared
# wheels fade first, projectiles fade on their own
# Then all else fades while demons are checked
# Then, reset -> emit prepared signal to try again.
func exhale(strength):
	for d in $demons.get_children():
		if d.has_method('deactivate'):
			d.deactivate()
	
	for s in $sources.get_children():
		s.exhale_projectiles(strength) # causes fading of wheel and projectiles
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	check_state()

func check_state():
	var cleared = true
	for demon in $demons.get_children():
		if !demon.hit:
			cleared = false
			#demon.get_node('AnimationPlayer').play('flash')
	
	if cleared:
		clear()
	else:
		fail()

# reset whole level. emit breath finished signal.
func fail():
	for s in $sources.get_children():
		s.reset()
		
	for d in $demons.get_children():
		d.reset()
		
	SignalBus.emit_signal('breath_finished')
	
	
# progress to next level. emit level cleared signal
func clear():
	var order = level % 4
	Global.play_sfx('res://Assets/Sounds/SFX/arp'+str(order)+'.wav', 0)
	SignalBus.emit_signal('level_cleared', situation, level)
	queue_free()
