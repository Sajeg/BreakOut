extends StaticBody2D


func destroy():
	$AnimationPlayer.play("break")
	$Effect.play()
