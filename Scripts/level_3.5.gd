extends Node2D


func _ready():
	$AnimationPlayer.play("destroy1")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "destroy1":
		$crate3.destroy()
		$AnimationPlayer.play("rotate_back")
