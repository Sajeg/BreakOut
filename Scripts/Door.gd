extends StaticBody2D

@export var next_scene: PackedScene

@export var locked = true

func _ready():
	if !locked:
		$Sprite2D.visible = false

func unlock():
	$Sprite2D.visible = false
	locked = false

func text_visible(state):
	$Label.visible = state

func set_text(text):
	$Label.text = text