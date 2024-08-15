extends CharacterBody2D

@onready var tooltip = get_node("tooltip")
@onready var animPlayer = get_node("AnimationPlayer")

@export var inventory = []

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
		animPlayer.play("idle")
	else:
		$"Idle-sheet".flip_h = needs_flip
		$"Run-sheet".flip_h = needs_flip
		animPlayer.play("walk")

func _input(event):
	if event.is_action_pressed("interact") && can_speak:
		#if is_speaking:
		#	tooltip.visible = true
		#	$SpeakUI.visible = false
		#	is_speaking = false
		#else:
			tooltip.visible = false
			$SpeakUI.visible = true
			is_speaking = true

func _on_area_2d_area_entered(area):
	if area.name == "Wizard":
		tooltip.visible = true
		can_speak = true


func _on_area_2d_area_exited(area):
	if area.name == "Wizard":
		tooltip.visible = false
		can_speak = false


func _on_button_pressed():
	pass # Replace with function body.
