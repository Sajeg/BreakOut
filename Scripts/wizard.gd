extends CharacterBody2D


func _ready():
	$AnimationPlayer.play("idle")
	
func display_text(text):
	$Output.text = text