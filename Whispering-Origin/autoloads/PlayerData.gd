extends Node

var skills = {
	"_max_level": 20,
	"mining": {
		"_name": "Mining",
		"level": 1,
		"xp": 0
	},
	"woodcutting": {
		"_name": "Woodcutting",
		"level": 1,
		"xp": 0
	}
}

var tools = {
	"axe": {
		"name": "Bronze Axe",
		"hit_force": (100 / 3) + 1
	},
	"pickaxe": {
		"name": "Bronze Pickaxe",
		"hit_force": (100 / 3) + 1
	}
}

var inventory = {
	"_rows": 3,
	"_cols": 8,
	"_max_stack": 999
}

func _ready():
	#_push_to_inventory("ore_copper", 9)
	#_push_to_inventory("log_standard", 8)
	#_push_to_inventory("ore_copper", 7)
	pass


func get_level_xp_caps(skill_key: String):
	if self.skills.has(skill_key):
		if self.skills[skill_key].level < 1:
			self.skills[skill_key].level = 1
		return {
			"current": pow((self.skills[skill_key].level * 2), 3),
			"previous": pow(((self.skills[skill_key].level - 1) * 2), 3)
		}
	return null

func add_xp(skill_key: String, amount: int = 1):
	if self.skills.has(skill_key):
		
		if self.skills[skill_key].level < self.skills._max_level:
			self.skills[skill_key].xp += amount
			var xp_caps = get_level_xp_caps(skill_key)
			var runs = 0;
			
			if xp_caps != null:
				while self.skills[skill_key].xp >= xp_caps.current and runs <= self.skills._max_level:
					runs += 1
					if xp_caps != null:
							if self.skills[skill_key].xp >= xp_caps.current:
								self.skills[skill_key].level += 1
								xp_caps = get_level_xp_caps(skill_key)
								if self.skills[skill_key].level >= self.skills._max_level:
									self.skills[skill_key].xp = xp_caps.previous


func _push_to_inventory(item_key: String, amount: int = 1):
	var inventory_size = self.inventory._rows * self.inventory._cols
	for i in range(inventory_size):
		if !self.inventory.has(i):
			self.inventory[i] = {
				"item": item_key,
				"amount": amount
			}
			return

func _swap_items(item_index_1: int, item_index_2: int) -> void:
	if item_index_1 != item_index_2:
		var temp = self.inventory[item_index_2]
		if self.inventory[item_index_1].item == self.inventory[item_index_2].item:
			var found_item = ItemDB.get_item(self.inventory[item_index_1].item)
			if found_item != null:
				if found_item["item"].stackable == true:
					var amount_1 = self.inventory[item_index_1].amount
					var amount_2 = self.inventory[item_index_2].amount
					
					if (amount_2 + amount_1) <= self.inventory._max_stack:
						self.inventory[item_index_2].amount += amount_1
						self.inventory.erase(item_index_1)
					else:
						if amount_1 == self.inventory._max_stack or amount_2 == self.inventory._max_stack:
							self.inventory[item_index_2] = self.inventory[item_index_1]
							self.inventory[item_index_1] = temp
						else:
							var remainder = (amount_2 + amount_1) - self.inventory._max_stack
							self.inventory[item_index_2].amount = self.inventory._max_stack
							self.inventory[item_index_1].amount = remainder
				else:
					self.inventory[item_index_2] = self.inventory[item_index_1]
					self.inventory[item_index_1] = temp
		else:
			self.inventory[item_index_2] = self.inventory[item_index_1]
			self.inventory[item_index_1] = temp


func find_item(item_key: String):
	var inventory_size = self.inventory._rows * self.inventory._cols
	var found_item = ItemDB.get_item(item_key)
	var inventory_item = null
	
	if found_item != null:
		for i in range(inventory_size):
			if self.inventory.has(i):
				if self.inventory[i].item == found_item["item"]._key:
					if self.inventory[i].amount < self.inventory._max_stack and inventory_item == null:
						inventory_item = {
							"item": found_item["item"],
							"index": i,
							"amount": self.inventory[i].amount
						}

		if inventory_item != null:
			return inventory_item
		else:
			return {
				"item": found_item["item"],
				"index": -1,
				"amount": 0
			}
	else:
		return null

func add_item(item_key: String, amount: int = 1) -> void:
	var found_item = find_item(item_key)
	if found_item != null:
		if found_item.index >= 0 and self.inventory.has(found_item.index):
			if found_item["item"].stackable == true:
				if (found_item.amount + amount) <= self.inventory._max_stack:
					self.inventory[found_item.index].amount += amount
				else:
					var runs = 0
					var max_runs = (self.inventory._rows * self.inventory._cols * self.inventory._max_stack)
					var remainder = (found_item.amount + amount) - self.inventory._max_stack
					self.inventory[found_item.index].amount = self.inventory._max_stack
					
					while remainder > 0 and runs <= max_runs:
						runs += 1
						var found_next_item = find_item(item_key)
						if found_next_item != null:
							if found_next_item.index > 0:
								if (found_next_item.amount + remainder) <= self.inventory._max_stack:
									self.inventory[found_next_item.index].amount += remainder
									remainder = 0
								else:
									remainder -= (self.inventory._max_stack - self.inventory[found_next_item.index].amount)
									self.inventory[found_next_item.index].amount = self.inventory._max_stack
							else:
								if (float(remainder) / float(self.inventory._max_stack)) > 1.0:
									_push_to_inventory(item_key, self.inventory._max_stack)
									remainder -= self.inventory._max_stack
								else:
									_push_to_inventory(item_key, remainder)
									remainder = 0
						else:
							remainder = 0
			else:
				if amount > 1:
					for i in range(amount):
						_push_to_inventory(item_key, 1)
				else:
					_push_to_inventory(item_key, amount)
		else:
			if found_item["item"].stackable == true:
				_push_to_inventory(item_key, amount)
			else:
				if amount > 1:
					for i in range(amount):
						_push_to_inventory(item_key, 1)
				else:
					_push_to_inventory(item_key, amount)

func move_item(old_index: int, new_index: int) -> void:
	if self.inventory.has(new_index) and self.inventory.has(old_index):
		_swap_items(old_index, new_index)
	elif self.inventory.has(old_index) and !self.inventory.has(new_index):
		self.inventory[new_index] = self.inventory[old_index]
		self.inventory.erase(old_index)