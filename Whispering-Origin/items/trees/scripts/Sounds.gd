var _chop_sound_file = preload("res://audio/chop.ogg")
var _fall_sound_file = preload("res://audio/tree_fall_2.ogg")

var chop = AudioStreamPlayer2D.new()
var fall = AudioStreamPlayer2D.new()

func _init(scene: KinematicBody2D):
	_chop_sound_file.set_loop(false)
	_fall_sound_file.set_loop(false)
	
	chop.stream = _chop_sound_file
	fall.stream = _fall_sound_file
	fall.volume_db = -10
	
	scene.add_child(chop)
	scene.add_child(fall)