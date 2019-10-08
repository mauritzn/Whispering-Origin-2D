extends Node2D

const Inventory = preload("res://ui/Inventory.tscn")
const Skills = preload("res://ui/Skills.tscn")

func _ready():
	var inventory_instance = Inventory.instance()
	var skills_instance = Skills.instance()
	self.add_child(inventory_instance)
	self.add_child(skills_instance)