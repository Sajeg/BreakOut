extends Node2D

var speed = 5

func _process(delta):
	process_input()

func process_input():
	if Input.is_action_pressed("down"):
		position.y += speed
		$AnimationPlayer.play("walk")
	if Input.is_action_pressed("up"):
		position.y -= speed
		$AnimationPlayer.play("walk")
	if Input.is_action_pressed("right"):
		position.x += speed
		$AnimationPlayer.play("walk")
	if Input.is_action_pressed("left"):
		position.x -= speed
		$AnimationPlayer.play("walk")
