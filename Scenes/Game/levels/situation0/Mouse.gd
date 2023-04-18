extends Sprite2D

func _process(delta):
	modulate.a = get_node("../sources").modulate.a
