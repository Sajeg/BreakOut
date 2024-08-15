extends Control

@onready var player = get_node("..")

func _on_button_pressed():
	if player.inventory == ["Nothing"]:
		player.ai.add_message($Input.text)
	else:
		player.ai.add_message($Input.text, player.inventory)
		player.inventory == []


func _on_ai_manager_new_response(text, friendship, inventory):
	$Output.text = text
	#$Friendship.text = "friendship: " + str(friendship)
	#$NPCInventory.text = "NPC inventory: " + str(inventory)


func _on_item_list_multi_selected(index, selected):
	# To-Do
	pass


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	# To-Do
	pass
