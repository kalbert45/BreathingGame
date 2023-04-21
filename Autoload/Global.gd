extends Node

var num_levels = {0: 8, 1: 8, 2: 8}

func pick_note():
	return Constants.NOTES.values().pick_random()

func play_sfx(path, db):
	var sfx = SFX.new()
	sfx.stream = load(path)
	sfx.volume_db = db
	add_child(sfx)
	sfx.play()
