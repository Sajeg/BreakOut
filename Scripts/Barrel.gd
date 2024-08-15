extends StaticBody2D

@export var looted = false
@export var loot_overwrite: String

func _ready():
	if looted:
		$Barrel.visible = false
		$Barrel_empty.visible = true
	else:
		$Barrel.visible = true
		$Barrel_empty.visible = false

func can_loot():
	return !looted

func set_looted():
	looted = true
	$Barrel.visible = false
	$Barrel_empty.visible = true
