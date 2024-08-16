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
	if looted:
		$Barrel.visible = false
		$Barrel_empty.visible = true
	else:
		$Barrel.visible = true
		$Barrel_empty.visible = false

func toggle_visible(state):
	if display_mode == Mode.LEFT:
		$Label_left.visible = state
	elif display_mode == Mode.CENTER:
		$Label_center.visible = state
	elif display_mode == Mode.RIGHT:
		$Label_right.visible = state

func can_loot():
	return !looted

func set_looted():
	looted = true
	$Barrel.visible = false
	$Barrel_empty.visible = true
