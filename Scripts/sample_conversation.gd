extends Node2D

var text
var friendship
var inventory

func _on_button_pressed():
	$AIManager.add_message($TextEdit.text, ["Pen"])


func _on_ai_manager_new_response(text, friendship, inventory):
	$RichTextLabel.text = text
	$Friendship.text = "friendship: " + str(friendship)
	$NPCInventory.text = "NPC inventory: " + str(inventory)
