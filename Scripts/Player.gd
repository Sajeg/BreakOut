extends CharacterBody2D

@onready var tooltip = get_node("tooltip")
@onready var animPlayer = get_node("AnimationPlayer")


var speed = 120
var can_speak = false
var ai_node
var is_speaking = false
var can_loot = false
var loot_node
var can_unlock = false
var unlock_node

func _physics_process(delta):
	process_input(delta)

func process_input(_delta):
	if is_speaking:
		return
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
	if event.is_action("zoom in"):
		$Camera2D.zoom += Vector2(0.1,0.1)
	elif event.is_action("zoom out"):
		$Camera2D.zoom -= Vector2(0.1,0.1)
			
	if event.is_action_pressed("interact") && can_loot:
		if loot_node.loot_overwrite != "":
			loot_node.set_looted()
			add_to_inventory(loot_node.loot_overwrite)
		else:
			loot_node.set_looted()
			add_to_inventory(vars.available_loot[randi() % vars.available_loot.size()])
		loot_node.toggle_visible(false)
	elif event.is_action_pressed("interact") && can_unlock:
		if unlock_node.locked:
			if "Key" in vars.inventory:
				vars.inventory.erase("Key")
				unlock_node.unlock()
				unlock_node.set_text("Go to\nnext\nroom")
			else:
				unlock_node.set_text("No\nKey")
		else:
			var scene = load(unlock_node.next_scene)
			get_tree().change_scene_to_packed(scene)
	elif event.is_action_pressed("interact") && can_speak:
		if not is_speaking:
			ai_node.get_parent().get_node("./Label").visible = false
			ai_node.get_parent().get_node("./Output").visible = true
			$SpeakUI.visible = true
			$SpeakUI/Name.text = "Give to " + ai_node.npc_name + ":"
			update_inventory_list()
			is_speaking = true
	elif event.is_action_pressed("exit") && can_speak:
		if is_speaking:
			ai_node.get_parent().get_node("./Label").visible = true
			ai_node.get_parent().get_node("./Output").visible = false
			$SpeakUI.visible = false
			$SpeakUI/Name.text = "Give to " + ai_node.npc_name + ":"
			is_speaking = false
	

func update_inventory_list():
	$SpeakUI/Inventory.clear()
	$SpeakUI/Inventory.add_item("Nothing")
	for item in vars.inventory:
		$SpeakUI/Inventory.add_item(item)

func add_to_inventory(item):
	vars.inventory.append(item)
	$InventoryNotification.text = item
	$InventoryNotification.visible = true
	$Timer.start()

func _on_area_2d_area_entered(area):
	if area.name == "Wizard":
		ai_node = area.get_parent().get_node("./AIManager")
		area.get_parent().get_node("./Label").visible = true
		can_speak = true
	elif area.name == "Object":
		loot_node = area.get_parent()
		can_loot = loot_node.can_loot()
		if can_loot:
			loot_node.toggle_visible(true)
	elif area.name == "Door":
		unlock_node = area.get_parent()
		can_unlock = true
		unlock_node.text_visible(true)
		if unlock_node.locked:
			unlock_node.set_text("Door is \nlocked")
		else:
			unlock_node.set_text("Go to \nnext \n room")


func _on_area_2d_area_exited(area):
	if area.name == "Wizard":
		can_speak = false
		area.get_parent().get_node("./Label").visible = false
	elif area.name == "Object":
		can_loot = false
		loot_node.toggle_visible(false)
	elif area.name == "Door":
		can_unlock = false
		unlock_node.text_visible(false)
	if !can_speak && !can_speak && !can_unlock:
		tooltip.visible = false


func _on_timer_timeout():
	$InventoryNotification.visible = false


func _on_ai_manager_new_response(_text:String, _friendship:int, _inventory:Array):
	update_inventory_list()
	$SpeakUI.request_ongoing = false
	
