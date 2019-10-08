extends KinematicBody2D

signal drop_item(item_key, amount)
signal drop_xp(skill_key, amount)
signal to_low_level(skill_key, required_level)
enum Dir { LEFT, RIGHT }
var durability = 100
var spawned = true

export (String) var skill_key = "mining"
export (String) var drop_item = "ore_copper"
export (int) var required_skill_level = 1
export (int) var respawn_time = 3
export (int) var drop_item_amount_min = 1
export (int) var drop_item_amount_max = 5
export (int) var drop_xp_amount_per_item = 1

var rng = RandomNumberGenerator.new()
var pickaxe_sound_player = AudioStreamPlayer2D.new()
var pickaxe_sound_sfx = preload("res://audio/pickaxe.ogg")
var respawn_timer = Timer.new()
var animation_player = AnimationPlayer.new()

func _ready():
	rng.randomize()
	self.add_to_group("world_items")
	
	respawn_timer.wait_time = respawn_time
	respawn_timer.connect("timeout", self, "_on_respawn_timer_timeout")
	self.add_child(respawn_timer)
	self.add_child(animation_player)
	
	pickaxe_sound_sfx.set_loop(false)
	pickaxe_sound_player.stream = pickaxe_sound_sfx
	self.add_child(pickaxe_sound_player)
	
	add_shake_animation()
	add_standing_animation()
	animation_player.play("standing")

func hit(hitter):
	if PlayerData.skills.has(self.skill_key):
		if PlayerData.skills[self.skill_key].level >= self.required_skill_level:
			if durability > 0 and spawned == true:
				durability -= hitter.tools.pickaxe.hit_force
				shake()
				pickaxe_sound_player.play(0.0)
				
				if durability <= 0:
					$TextureRect/OreSprite.frame += 1
					var items_dropped = rng.randi_range(self.drop_item_amount_min, self.drop_item_amount_max)
					self.emit_signal("drop_item", self.drop_item, items_dropped)
					self.emit_signal("drop_xp", self.skill_key, (items_dropped * self.drop_xp_amount_per_item))
					spawned = false
					respawn_timer.start()
		else:
			self.emit_signal("to_low_level", self.skill_key, self.required_skill_level)

func _on_respawn_timer_timeout():
	respawn_timer.stop()
	durability = 100
	spawned = true
	$TextureRect/OreSprite.frame -= 1


func shake():
	var shake_animation = animation_player.get_animation("shake")
	if shake_animation:
		var current_shake_value = shake_animation.track_get_key_value(0, 1)
		shake_animation.track_set_key_value(0, 1, (current_shake_value * -1))
		
		if current_shake_value != null:
			animation_player.play("shake")

########################################## ANIMATIONS ##########################################

func add_shake_animation():
	var animation = Animation.new()
	animation.length = 0.3

	var rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(rotation_track, 0.0, 0)
	animation.track_insert_key(rotation_track, 0.1, -2)
	animation.track_insert_key(rotation_track, 0.2, 0)
	animation_player.add_animation("shake", animation)

func add_standing_animation():
	var animation = Animation.new()
	animation.length = 0.5

	var rotation_track = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(rotation_track, "TextureRect:rect_rotation")
	animation.track_insert_key(rotation_track, 0.0, 0)
	animation.track_insert_key(rotation_track, 0.5, 0)
	animation_player.add_animation("standing", animation)