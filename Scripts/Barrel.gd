extends StaticBody2D

enum Mode {
	LEFT,
	CENTER,
	RIGHT
}

@export var looted = false
@export var loot_overwrite: String = ""
@export var display_mode = Mode.CENTER


func _ready():
	if display_mode == Mode.LEFT:
		$Label.text = "Press
                        E to
                          loot"
		$Label.position.x = -24
		$Label.position.y = -14
	elif display_mode == Mode.CENTER:
		$Label.text = "      Press E 
                           to           loot"
		$Label.position.x = -22
		$Label.position.y = -18
	elif display_mode == Mode.RIGHT:
		$Label.text = "Press
						 E to
					   loot"
		$Label.position.x = 5
		$Label.position.y = -14
	
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
