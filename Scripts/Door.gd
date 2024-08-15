extends StaticBody2D

@export var next_scene: PackedScene

@export var locked = true

func unlock():
	visible = false
	locked = false