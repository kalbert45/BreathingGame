extends Sprite2D

# handles projectile movement and wheel activation

var num_wheels = 1 # number of wheels around the source
var projectiles = []
var wheels

func _ready():
	wheels = get_wheels()
	for w in wheels:
		for p in w.get_projectiles():
			projectiles.append(p)

func get_wheels():
	var wheels = get_children()
	wheels.pop_back()
	return wheels
		
# also handles inhale animation
func activate_wheels():
	for w in wheels:
		w.active = true
	
func exhale_projectiles(strength):
	for w in wheels:
		w.active = false
		
	for p in projectiles:
		var dir = (p.global_position - global_position).normalized()
		p.push(strength, dir)
	
func reset():
	for w in wheels:
		w.reset()