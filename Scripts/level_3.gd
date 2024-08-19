extends Node2D

func _ready():
	if !vars.played_voice_3:
		$Player/MultipleSkeletons.play()
	