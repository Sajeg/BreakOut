extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D
@export var cast : RayCast2D

@export var path_follow : PathFollow2D
@export var player : CharacterBody2D
@export var h_flip_ratio_bigger = 0.5

var speed = 40


var player_detected = false

func _ready():
	$AnimationPlayer.play("run")
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
# 	if path_follow == null:
# 		return
	call_deferred("actor_setup")
    
func actor_setup():
	await get_tree().physics_frame
	create_path()
	
	
func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	if path_follow == null:
		return
		
	if player_detected:
		cast.global_position = global_position
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
		velocity = current_agent_position.direction_to(next_path_position) * speed
		move_and_slide()
	else:
		path_follow.progress_ratio += (speed * delta) / 100
		if path_follow.progress_ratio > h_flip_ratio_bigger:
			$"Run-sheet".flip_h = false
		else:
			$"Run-sheet".flip_h = true


func create_path():
	nav_agent.target_position = player.global_position
	if player.global_position.x < global_position.x:
		$"Run-sheet".flip_h = true
	else:
		$"Run-sheet".flip_h = false

func _on_area_2d_area_entered(area:Area2D):
	if area.name == "Player":
		player_detected = true
		path_follow.rotation = 0
		$Timer.start()
	pass
	


func _on_timer_timeout():
	create_path()
	if player_detected:
		$Timer.start()
