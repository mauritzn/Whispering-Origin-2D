extends KinematicBody2D

signal drop_item(item_key, amount)
signal drop_xp(skill_key, amount)
signal to_low_level(skill_key, required_level)
enum Dir { LEFT, RIGHT }
var durability = 100
var spawned = true

export (String) var skill_key = "woodcutting"
export (String) var drop_item = "log_standard"
export (int) var required_skill_level = 1
export (int) var respawn_time = 3
export (int) var drop_item_amount_min = 1
export (int) var drop_item_amount_max = 5
export (int) var drop_xp_amount_per_item = 1

var rng = RandomNumberGenerator.new()
var chop_sound_player = AudioStreamPlayer2D.new()
var chop_sound_sfx = preload("res://audio/chop.ogg")
var fall_sound_player = AudioStreamPlayer2D.new()
var fall_sound_sfx = preload("res://audio/tree_fall_2.ogg")
var respawn_timer = Timer.new()
var animation_player = AnimationPlayer.new()

func _ready():
	rng.randomize()
	self.add_to_group("world_items")
	#print(self.get_tree().get_root().get_node("."))
	
	respawn_timer.wait_time = respawn_time
	respawn_timer.connect("timeout", self, "_on_respawn_timer_timeout")
	animation_player.connect("animation_finished", self, "_on_animation_finished")
	self.add_child(respawn_timer)
	self.add_child(animation_player)
	
	add_sound()
	add_shake_animation()
	add_fall_animation()
	add_fade_in_animation()
	add_standing_animation()
	animation_player.play("standing")

func hit(hitter):
	if PlayerData.skills.has(self.skill_key):
		if PlayerData.skills[self.skill_key].level >= self.required_skill_level:
			if durability > 0 and spawned == true:
				durability -= hitter.tools.axe.hit_force
				shake()
				chop_sound_player.play(0.0)
				
				if durability <= 0:
					if hitter.position.x > position.x:
						fall(Dir.LEFT)
					else:
						fall(Dir.RIGHT)
					var items_dropped = rng.randi_range(self.drop_item_amount_min, self.drop_item_amount_max)
					self.emit_signal("drop_item", self.drop_item, items_dropped)
					self.emit_signal("drop_xp", self.skill_key, (items_dropped * self.drop_xp_amount_per_item))
					spawned = false
					respawn_timer.start()
		else:
			self.emit_signal("to_low_level", self.skill_key, self.required_skill_level)

func _on_animation_finished(animation_name):
	if spawned == false and animation_name == "fade_in":
		spawned = true

func _on_respawn_timer_timeout():
	respawn_timer.stop()
	durability = 100
	animation_player.play("fade_in")


func shake():
	var shake_animation = animation_player.get_animation("shake")
	if shake_animation:
		var current_shake_value = shake_animation.track_get_key_value(0, 1)
		shake_animation.track_set_key_value(0, 1, (current_shake_value * -1))
		
		if current_shake_value != null:
			animation_player.play("shake")

func fall(direction):
	var fall_animation = animation_player.get_animation("fall")
	if fall_animation:
		if direction == Dir.LEFT:
			fall_animation.track_set_key_value(0, 1, -90)
		else:
			fall_animation.track_set_key_value(0, 1, 90)
		fall_sound_player.play(0.0)
		animation_player.play("fall")

########################################## ANIMATIONS & SOUND ##########################################

func add_sound():
	chop_sound_sfx.set_loop(false)
	chop_sound_player.stream = chop_sound_sfx
	self.add_child(chop_sound_player)
	
	fall_sound_sfx.set_loop(false)
	fall_sound_player.stream = fall_sound_sfx
	fall_sound_player.volume_db = -10
	self.add_child(fall_sound_player)
	
func add_shake_animation():
	var animation = Animation.new()
	animation.length = 0.3

	var TextureRect_rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(TextureRect_rotation_track, 0.0, 0)
	animation.track_insert_key(TextureRect_rotation_track, 0.1, -2)
	animation.track_insert_key(TextureRect_rotation_track, 0.2, 0)
	animation_player.add_animation("shake", animation)
	
	var TextureRect_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TextureRect_modulate_track, "TextureRect:modulate")
	animation.track_insert_key(TextureRect_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TextureRect_modulate_track, 0.3, Color(1, 1, 1, 1))
	
	var TreeShadow_modulate_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(TreeShadow_modulate_track, "TreeShadow:modulate")
	animation.track_insert_key(TreeShadow_modulate_track, 0.0, Color(1, 1, 1, 1))
	animation.track_insert_key(TreeShadow_modulate_track, 0.3, Color(1, 1, 1, 1))

func add_fall_animation():
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
	
	animation_player.add_animation("fall", animation)

func add_fade_in_animation():
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
	
	animation_player.add_animation("fade_in", animation)

func add_standing_animation():
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
	
	animation_player.add_animation("standing", animation)