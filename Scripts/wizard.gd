extends CharacterBody2D


func _ready():
	$AnimationPlayer.play("idle")
	
func display_text(text):
	$Output.text = text
	
func change_visible(state):
	$Output.visible = state