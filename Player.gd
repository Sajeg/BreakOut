extends CharacterBody2D

var speed = 150
var can_speak = false
var is_speaking = false
var can_loot = false

func _physics_process(delta):
	process_input(delta)

func process_input(delta):
	if is_speaking:
		return
	var is_walking = false
	var input_vector = Vector2.ZERO
	velocity.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * speed
	velocity.y = (Input.get_action_strength("down") - Input.get_action_strength("up")) * speed
	var is_idling = is_zero_approx(velocity.y) && is_zero_approx(velocity.x)
	var needs_flip = velocity.x < 0
	
	move_and_slide()
	
	if (is_idling):
		$AnimationPlayer.play("idle")
	else:
		$"Idle-sheet".flip_h = needs_flip
		$"Run-sheet".flip_h = needs_flip
		$AnimationPlayer.play("walk")

func _input(event):
	if event.is_action("interact") && can_speak:
		if is_speaking:
			is_speaking = false
		else: 
			is_speaking = true


func _on_area_2d_body_entered(body):
	print(body)
	if body.name == "Wizard":
		can_speak = true


func _on_area_2d_body_exited(body):
	if body.name == "Wizard":
		can_speak = false
