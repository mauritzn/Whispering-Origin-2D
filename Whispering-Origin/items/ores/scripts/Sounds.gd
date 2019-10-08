var _pickaxe_sound_file = preload("res://audio/pickaxe.ogg")

var pickaxe = AudioStreamPlayer2D.new()

func _init(scene: KinematicBody2D):
	_pickaxe_sound_file.set_loop(false)
	pickaxe.stream = _pickaxe_sound_file
	scene.add_child(pickaxe)