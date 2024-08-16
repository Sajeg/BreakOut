extends Control

@onready var player = get_node("..")
var selected_items = []

func _on_button_pressed():
	if selected_items == ["Nothing"]:
		player.ai_node.add_message($Input.text)
	elif selected_items == []:
		player.ai_node.add_message($Input.text)
	else:
		player.ai_node.add_message($Input.text, selected_items)
		var index = vars.inventory.find(selected_items[0])
		if index != -1:
			vars.inventory.erase(selected_items[0])
		selected_items = []
	
	$Input.text = ""


func _on_ai_manager_new_response(_text, _friendship, _inventory):
	player.update_inventory_list()
# 	$Output.text = text
	#$Friendship.text = "friendship: " + str(friendship)
	#$NPCInventory.text = "NPC inventory: " + str(inventory)

func _on_inventory_item_selected(index):
	selected_items = [$Inventory.get_item_text(index)]
