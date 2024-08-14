extends Node2D


func _on_button_pressed():
	var data = {
		"text": $TextEdit.text,
		"friendship": $AIManager.friendship,
		"items": ["paper", "can of pineapple"]
	}
	$AIManager.add_message($TextEdit.text)


func _on_ai_manager_new_response(text):
	$RichTextLabel.text = text
