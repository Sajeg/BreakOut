extends Node2D


func _ready():
	if !vars.animation_played:
		$Scene/AnimationPlayer.play("talk")
	else:
		$Scene.visible = false

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "talk":
		$Scene/AnimationPlayer.play("kill")
	else:
		vars.animation_played = true


func _on_caught_animation_area_entered(area:Area2D):
	if area.name == "Player" && !vars.spikes:
		$Scene/AnimationPlayer.stop()
		$Scene/Talk.stop()
		$Scene/Kill.stop()
		$Scene/Caught.play()
		$Player.got_caught = true
		$Player/AnimationPlayer.stop()
		$Player/Camera2D.zoom = Vector2(3,3)
		$Player/CaughtLabel.visible = true
		$Player/CaughtAnimation.play("end")
