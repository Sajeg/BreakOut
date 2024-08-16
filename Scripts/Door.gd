extends StaticBody2D

@export var next_scene: PackedScene

@export var locked = true

func _ready():
	if !locked:
		visible = false

func unlock():
	visible = false
	locked = false

func text_visible(state):
	$Label.visible = state

func set_text(text):
	$Label.text = text