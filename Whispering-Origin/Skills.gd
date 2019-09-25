extends Control

onready var mining_level = $CanvasLayer/Panel/MarginContainer/ColorRect/MiningLevel
onready var mining_progress = $CanvasLayer/Panel/MarginContainer/ColorRect/MiningProgress
onready var woodcutting_level = $CanvasLayer/Panel/MarginContainer/ColorRect/WoodcuttingLevel
onready var woodcutting_progress = $CanvasLayer/Panel/MarginContainer/ColorRect/WoodcuttingProgress

func _ready():
	$CanvasLayer/LevelUpAnimations.play("LevelUp-default-out")
	$CanvasLayer/RequiredLevelAnimations.play("RequiredLevel-default-out")
	for world_item in get_tree().get_nodes_in_group("world_items"):
		world_item.connect("drop_xp", self, "_on_xp_drop")
		world_item.connect("to_low_level", self, "_on_to_low_level")
	update_progress("mining")
	update_progress("woodcutting")

func format_number(number, separator = ","):
	number = str(number)
	var size = number.length()
	var result = ""
	
	for i in range(size):
		if((size - i) % 3 == 0 and i > 0):
			result = str(result, separator, number[i])
		else:
			result = str(result, number[i])
	return result

func _calc_progress(skill_key: String):
	if PlayerData.skills.has(skill_key):
		var xp_caps = PlayerData.get_level_xp_caps(skill_key)
		if xp_caps != null:
			var current_xp = PlayerData["skills"][skill_key].xp
			var relative_xp = current_xp - xp_caps.previous
			var relative_required_xp = xp_caps.current - xp_caps.previous
			if PlayerData["skills"][skill_key].level >= PlayerData.skills._max_level:
				relative_xp = current_xp
				relative_required_xp = xp_caps.previous
			return ((float(relative_xp) / float(relative_required_xp)) * 100)
	return null

func update_progress(skill_key: String):
	if PlayerData.skills.has(skill_key):
		if PlayerData["skills"][skill_key].level > PlayerData.skills._max_level:
			PlayerData["skills"][skill_key].level = PlayerData.skills._max_level
			var xp_caps_fixed = PlayerData.get_level_xp_caps(skill_key)
			PlayerData["skills"][skill_key].xp = xp_caps_fixed.previous
			
		var xp_caps = PlayerData.get_level_xp_caps(skill_key)
		if xp_caps != null:
			var xp_cap = xp_caps.current
			if PlayerData["skills"][skill_key].level >= PlayerData.skills._max_level:
				xp_cap = xp_caps.previous
			var level_text = "Level " + str(PlayerData["skills"][skill_key].level)
			var xp_text = format_number(PlayerData["skills"][skill_key].xp) + "/" + format_number(xp_cap) + " xp"
			var progress = _calc_progress(skill_key)
			
			if progress != null:
				match skill_key:
					"mining":
						mining_level.text = level_text
						mining_progress.get_node("XpLabel").text = xp_text
						mining_progress.value = progress
					"woodcutting":
						woodcutting_level.text = level_text
						woodcutting_progress.get_node("XpLabel").text = xp_text
						woodcutting_progress.value = progress

func _on_xp_drop(skill_key: String, amount: int):
	if PlayerData.skills.has(skill_key):
		var current_level = PlayerData["skills"][skill_key].level
		PlayerData.add_xp(skill_key, amount)
		update_progress(skill_key)

		if PlayerData["skills"][skill_key].level > current_level:
			current_level = PlayerData["skills"][skill_key].level
			$CanvasLayer/LevelUp.text = "You are now level " + str(current_level) + " in " + PlayerData["skills"][skill_key]._name
			$CanvasLayer/LevelUpAnimations.play("LevelUp-in")
			$CanvasLayer/LevelUpTimer.start(0.0)
			$CanvasLayer/AudioStreamPlayer2D.play(0.0)

func _on_LevelUpTimer_timeout():
	$CanvasLayer/LevelUpAnimations.play("LevelUp-out")
	$CanvasLayer/LevelUpTimer.stop()


func _on_to_low_level(skill_key: String, required_level: int):
	$CanvasLayer/RequiredLevel.text = "Too low " + PlayerData["skills"][skill_key]._name + " level, required: " + str(required_level)
	$CanvasLayer/RequiredLevelAnimations.play("RequiredLevel-in")
	$CanvasLayer/RequiredLevelTimer.start(0.0)

func _on_RequiredLevelTimer_timeout():
	$CanvasLayer/RequiredLevelAnimations.play("RequiredLevel-out")
	$CanvasLayer/RequiredLevelTimer.stop()
