extends Node2D

@export var path_follow : PathFollow2D
var speed = 30
@export var h_flip_ratio_smaller = 0.0
@export var h_flip_ratio_bigger = 0.5

func _ready():
	if path_follow == null:
		return
	$AnimationPlayer.play("run")
	
	
func _process(delta):
	if path_follow == null:
		return
	path_follow.progress_ratio += (speed * delta) / 100
	if path_follow.progress_ratio > h_flip_ratio_bigger:
		$"Run-sheet".flip_h = false
	else:
		$"Run-sheet".flip_h = true
