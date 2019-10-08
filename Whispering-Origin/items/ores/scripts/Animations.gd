var player = AnimationPlayer.new()

func _init(scene: KinematicBody2D):
	_add_shake_animation()
	_add_standing_animation()
	scene.add_child(player)

func play(animation_name: String):
	player.play(animation_name)


func _add_shake_animation():
	var animation = Animation.new()
	animation.length = 0.3

	var rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(rotation_track, 0.0, 0)
	animation.track_insert_key(rotation_track, 0.1, -2)
	animation.track_insert_key(rotation_track, 0.2, 0)
	player.add_animation("shake", animation)


func _add_standing_animation():
	var animation = Animation.new()
	animation.length = 0.5

	var rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(rotation_track, 0.0, 0)
	animation.track_insert_key(rotation_track, 0.5, 0)
	player.add_animation("standing", animation)