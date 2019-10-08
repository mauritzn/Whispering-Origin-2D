extends Node

const _ITEM_DB = {
	"ore": {
		"_icons": preload("res://images/ores.png"),
		"_frame_count": 1,
		"copper": {
			"name": "Copper Ore",
			"value": 25,
			"stackable": true,
			"icon_nr": 0
		},
	},

	"log": {
		"_icons": preload("res://images/logs.png"),
		"_frame_count": 1,
		"standard": {
			"name": "Log",
			"value": 10,
			"stackable": true,
			"icon_nr": 0
		}
	}
}


static func parse_item_key(item_key: String):
	var split_key = item_key.split("_", true, 1)
	if len(split_key) == 2:
		if _ITEM_DB.has(split_key[0]):
			return {
				"category": split_key[0],
				"item_key": split_key[1],
				"items": _ITEM_DB[split_key[0]]
			}
	return null

static func get_item(item_key: String):
	var parsed = parse_item_key(item_key)
	if parsed != null:
		if parsed["items"].has("_icons") and parsed["items"].has("_frame_count"):
			if parsed["items"].has(parsed["item_key"]):
				parsed["items"][parsed["item_key"]]._key = item_key
				return {
					"_icons": parsed["items"]["_icons"],
					"_frame_count": parsed["items"]["_frame_count"],
					"item": parsed["items"][parsed["item_key"]]
				}
	return null