extends CharacterBody2D

@onready var tooltip = get_node("tooltip")
@onready var animPlayer = get_node("AnimationPlayer")

@export var inventory = []
@export var ai: Control

var speed = 150
var can_speak = false
var is_speaking = false
var can_loot = false
var loot_node

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
		if not is_speaking:
			tooltip.visible = false
			$SpeakUI.visible = true
			$SpeakUI/Name.text = "Give to " + ai.npc_name + ":"
			for item in inventory:
				$SpeakUI/Inventory.add_item(item)
			is_speaking = true
	elif event.is_action_pressed("exit") && can_speak:
		if is_speaking:
			tooltip.visible = true
			$SpeakUI.visible = false
			$SpeakUI/Name.text = "Give to " + ai.npc_name + ":"
			is_speaking = false
	elif event.is_action_pressed("interact") && can_loot:
		if loot_node.loot_overwrite == "":
			loot_node.set_looted()
			add_to_inventory(loot_node.loot_overwrite)
		else:
			loot_node.set_looted()
			add_to_inventory(vars.avaible_loot[randi() % vars.avaible_loot.size()])
		tooltip.visible = false

func add_to_inventory(item):
	inventory.append(item)
	$InventoryNotification.text = "New Item received: " + item
	$InventoryNotification.visible = true
	$Timer.start()

func _on_area_2d_area_entered(area):
	if area.name == "Wizard":
		tooltip.visible = true
		tooltip.text = "Press E to speak"
		can_speak = true
	elif area.name == "Object":
		loot_node = area.get_parent()
		can_loot = loot_node.can_loot()
		tooltip.text = "Press E to loot"
		if can_loot:
			tooltip.visible = true


func _on_area_2d_area_exited(area):
	if area.name == "Wizard":
		tooltip.visible = false
		can_speak = false
	elif area.name == "Object":
		tooltip.visible = false
		can_loot = false


func _on_timer_timeout():
	$InventoryNotification.visible = false
