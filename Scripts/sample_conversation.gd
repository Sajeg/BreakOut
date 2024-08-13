extends Node2D


func _on_button_pressed():
	$AIManager.add_message($TextEdit.text)


func _on_ai_manager_new_response(text):
	$RichTextLabel.text = text
