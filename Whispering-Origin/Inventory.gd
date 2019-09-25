extends Control

onready var grid = $CanvasLayer/Panel/MarginContainer/GridContainer
const ItemDB = preload("ItemDB.gd")
const Slot = preload("res://InventorySlot.tscn")

var inventory_size = PlayerData.inventory._rows * PlayerData.inventory._cols
var holding_item_key = null

func _ready():
	grid.columns = PlayerData.inventory._cols
	
	for world_item in get_tree().get_nodes_in_group("world_items"):
		world_item.connect("drop_item", self, "_on_item_drop")

	create_inventory()

func clean_inventory():
	for child in grid.get_children():
		grid.remove_child(child)

func create_inventory():
	clean_inventory()
	
	for i in range(inventory_size):
		var slot_instance = Slot.instance()
		clear_slot(slot_instance)
		grid.add_child(slot_instance)
		slot_instance.connect("pressed", self, "_on_Slot_pressed", [slot_instance, i])
		
		if PlayerData.inventory.has(i):
			if PlayerData.inventory[i].amount > PlayerData.inventory._max_stack:
				PlayerData.inventory[i].amount = PlayerData.inventory._max_stack
			fill_slot(slot_instance, PlayerData.inventory[i])

func update_inventory():
	for i in range(inventory_size):
		if holding_item_key != null:
			grid.get_child(i).mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			if PlayerData.inventory.has(i):
				if PlayerData.inventory[i].amount > PlayerData.inventory._max_stack:
					PlayerData.inventory[i].amount = PlayerData.inventory._max_stack
				fill_slot(grid.get_child(i), PlayerData.inventory[i])
			else:
				clear_slot(grid.get_child(i))

func hide_slot(slot_instance):
	slot_instance.get_node("MarginContainer").modulate = Color(1, 1, 1, 0)
	slot_instance.hint_tooltip = ""
	
func show_slot(slot_instance):
	slot_instance.get_node("MarginContainer").modulate = Color(1, 1, 1, 1)

func clear_slot(slot_instance):
	hide_slot(slot_instance);
	slot_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fill_slot(slot_instance, inventory_slot):
	var found_item = ItemDB.get_item(inventory_slot["item"])
	var sprite = slot_instance.get_node("MarginContainer/Sprite")
	var label = slot_instance.get_node("MarginContainer/MarginContainer/Label")

	if sprite != null and label != null:
		if found_item != null:
			show_slot(slot_instance);
			sprite.texture = found_item["_icons"]
			sprite.hframes = found_item["_frame_count"]
			sprite.frame = found_item["item"]["icon_nr"]
			label.text = str(inventory_slot["amount"])
			slot_instance.hint_tooltip = found_item["item"]["name"]
			slot_instance.mouse_filter = Control.MOUSE_FILTER_STOP
			
			if found_item["item"]["stackable"] == true:
				label.modulate = Color(1, 1, 1, 1)
			else:
				label.modulate = Color(1, 1, 1, 0)


func _on_Slot_pressed(slot_instance, key):
	if $CanvasLayer/MovingItem.texture == null:
		$CanvasLayer/MovingItem.texture = slot_instance.get_node("MarginContainer/Sprite").texture
		$CanvasLayer/MovingItem.position = get_viewport().get_mouse_position()
		holding_item_key = key
		hide_slot(slot_instance)
		update_inventory()
	else:
		if holding_item_key != null:
			PlayerData.move_item(holding_item_key, key)
			$CanvasLayer/MovingItem.texture = null
			holding_item_key = null
			update_inventory()
	#print("SLOT PRESSED! ", slot_instance.name)


func _input(event):
	if event is InputEventMouseMotion:
		if $CanvasLayer/MovingItem.texture != null:
			$CanvasLayer/MovingItem.position = event.position

func _on_item_drop(item_key: String, amount: int):
	PlayerData.add_item(item_key, amount)
	update_inventory()