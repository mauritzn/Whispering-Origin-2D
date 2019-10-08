var player = AnimationPlayer.new()

func _init(scene: KinematicBody2D):
	_add_shake_animation()
	_add_fall_animation()
	_add_fade_in_animation()
	_add_standing_animation()
	scene.add_child(player)

func play(animation_name: String):
	player.play(animation_name)


func _add_shake_animation():
	var animation = Animation.new()
	animation.length = 0.3

	var TextureRect_rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(TextureRect_rotation_track, 0.0, 0)
	animation.track_insert_key(TextureRect_rotation_track, 0.1, -2)
	animation.track_insert_key(TextureRect_rotation_track, 0.2, 0)
	player.add_animation("shake", animation)
	
	var TextureRect_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_modulate_track, "TextureRect:modulate")
	animation.track_insert_key(TextureRect_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TextureRect_modulate_track, 0.3, Color(1, 1, 1, 1))
	
	var TreeShadow_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TreeShadow_modulate_track, "TreeShadow:modulate")
	animation.track_insert_key(TreeShadow_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TreeShadow_modulate_track, 0.3, Color(1, 1, 1, 1))


func _add_fall_animation():
	var animation = Animation.new()
	animation.length = 0.5

	var TextureRect_rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(TextureRect_rotation_track, 0.0, 0)
	animation.track_insert_key(TextureRect_rotation_track, 0.5, -90)
	
	var TextureRect_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_modulate_track, "TextureRect:modulate")
	animation.track_insert_key(TextureRect_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TextureRect_modulate_track, 0.4, Color(1, 1, 1, 1))
	animation.track_insert_key(TextureRect_modulate_track, 0.5, Color(1, 1, 1, 0))
	
	var TreeShadow_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TreeShadow_modulate_track, "TreeShadow:modulate")
	animation.track_insert_key(TreeShadow_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TreeShadow_modulate_track, 0.4, Color(1, 1, 1, 1))
	animation.track_insert_key(TreeShadow_modulate_track, 0.5, Color(1, 1, 1, 0))
	
	player.add_animation("fall", animation)


func _add_fade_in_animation():
	var animation = Animation.new()
	animation.length = 0.5

	var TextureRect_rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(TextureRect_rotation_track, 0.0, 0)
	animation.track_insert_key(TextureRect_rotation_track, 0.5, 0)
	
	var TextureRect_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_modulate_track, "TextureRect:modulate")
	animation.track_insert_key(TextureRect_modulate_track, 0.0, Color(1, 1, 1, 0))
	animation.track_insert_key(TextureRect_modulate_track, 0.5, Color(1, 1, 1, 1))
	
	var TreeShadow_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TreeShadow_modulate_track, "TreeShadow:modulate")
	animation.track_insert_key(TreeShadow_modulate_track, 0.0, Color(1, 1, 1, 0))
	animation.track_insert_key(TreeShadow_modulate_track, 0.5, Color(1, 1, 1, 1))
	
	player.add_animation("fade_in", animation)


func _add_standing_animation():
	var animation = Animation.new()
	animation.length = 0.5

	var TextureRect_rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(TextureRect_rotation_track, 0.0, 0)
	animation.track_insert_key(TextureRect_rotation_track, 0.5, 0)
	
	var TextureRect_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_modulate_track, "TextureRect:modulate")
	animation.track_insert_key(TextureRect_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TextureRect_modulate_track, 0.5, Color(1, 1, 1, 1))
	
	var TreeShadow_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TreeShadow_modulate_track, "TreeShadow:modulate")
	animation.track_insert_key(TreeShadow_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TreeShadow_modulate_track, 0.5, Color(1, 1, 1, 1))
	
	player.add_animation("standing", animation)