extends Control

func _on_Start_pressed():
	self.get_tree().change_scene("Game.tscn")

func _on_Quit_pressed():
	self.get_tree().quit()
