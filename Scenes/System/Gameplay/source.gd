extends Sprite2D

# handles projectile movement and wheel activation

var num_wheels = 1 # number of wheels around the source
var projectiles = []
var wheels

func _ready():
	self_modulate.a = 0
	$visuals.visible = true
	
	wheels = get_wheels()
	for w in wheels:
		for p in w.get_projectiles():
			projectiles.append(p)

func get_wheels():
	var _wheels = get_children()
	for w in _wheels:
		if w.name == "visuals":
			_wheels.erase(w)
	return _wheels
		
# also handles inhale animation
func activate_wheels():
	$visuals/AnimationPlayer.play("inhale")
	
	for w in wheels:
		w.active = true
		
	for p in projectiles:
		p.spawn()
	
func exhale_projectiles(strength):
	$visuals/AnimationPlayer.play("exhale")
	
	for w in wheels:
		w.active = false
		
	for p in projectiles:
		var dir = (p.global_position - global_position).normalized()
		p.push(strength, dir)
	
func reset():
	for w in wheels:
		w.reset()
