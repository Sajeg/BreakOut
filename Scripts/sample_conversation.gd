extends Node2D

var inventory = []

func _on_button_pressed():
	if inventory == ["Nothing"]:
		$AIManager.add_message($TextEdit.text)
	else:
		$AIManager.add_message($TextEdit.text, inventory)
		#var item_count = $ItemList.get_item_count()
		#for i in item_count - 1:
		#	if $ItemList.get_item_text(i) == inventory[0]:
		#		$ItemList.remove_item(i)
		inventory == []


func _on_ai_manager_new_response(text, friendship, inventory):
	$RichTextLabel.text = text
	$Friendship.text = "friendship: " + str(friendship)
	$NPCInventory.text = "NPC inventory: " + str(inventory)


func _on_item_list_multi_selected(index, selected):
	if selected:
		inventory.append($ItemList.get_item_text(index))
	


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	if $ItemList.get_item_text(index) in inventory:
		inventory.erase($ItemList.get_item_text(index))
	else:
		inventory.append($ItemList.get_item_text(index))
