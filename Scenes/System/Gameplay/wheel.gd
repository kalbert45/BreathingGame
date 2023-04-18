extends Node2D

# wheel needs to handle mouse input

const LERP_SPEED = 5
const WIDTH = 30
const BASE_RADIUS = 30

@export var layer = 1 # determines order of wheel, like atoms with electrons
@export var init_rotation = 0 # base rotation of wheel when level spawns (degrees)

var initial_angle = null
var target_angle = 0

var active = false : set = _set_active
var rotating = false : set = _set_rotating

# arrange projectiles
func _ready():
	target_angle = deg_to_rad(init_rotation)
	rotation = deg_to_rad(init_rotation)
	var projectiles = get_projectiles()
	for proj in projectiles:
		proj.position = (layer * BASE_RADIUS) * proj.position.normalized()
		proj.rotation = proj.position.angle()
		proj.init_position = proj.position

func get_projectiles():
	var projectiles = get_children()
	for p in projectiles:
		if p.name == "visuals":
			projectiles.erase(p)
	return projectiles
	
func reset():
	for p in get_projectiles():
		p.reset()

func _set_active(value):
	active = value
	if active:
		self_modulate.a = 1
	else:
		$visuals/AnimationPlayer.play('fade_out')

func _set_rotating(value):
	if value:
		initial_angle = ((get_global_mouse_position() - global_position).angle()) - rotation
	
	rotating = value
	

func _draw():
	draw_arc(Vector2.ZERO, layer * BASE_RADIUS, 0, 2*PI, 40, Color('#253a5e'))

# smoothly rotate wheel towards mouse position
func _process(delta):
	if !active:
		return
		
	if rotating:
		var mouse_pos = get_global_mouse_position()
		target_angle = ((mouse_pos - global_position).angle()) - initial_angle
	rotation = lerp_angle(rotation, target_angle, LERP_SPEED*delta)
	
func in_bounds(pos):
	var dist = global_position.distance_to(pos)
	return (dist < (BASE_RADIUS*layer + (WIDTH/2))) and (dist > (BASE_RADIUS*layer - (WIDTH/2)))
	
func _unhandled_input(event):
	if !(event is InputEventMouseButton):
		return
	if !(in_bounds(get_global_mouse_position()) or rotating):
		return
	
	if event.is_action_pressed("left_click"):
		self.rotating = true
	elif event.is_action_released("left_click"):
		self.rotating = false
	
