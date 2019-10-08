extends Control

func _on_Start_pressed():
	self.get_tree().change_scene("res://scenes/Game.tscn")

func _on_Quit_pressed():
	self.get_tree().quit()
