extends Position2D


# Target code to be displayed.
var target_code: Array = [] setget _set_target_code

onready var key_container: Node2D = $KeyContainer


# Runs when instantiation is completed.
func _ready() -> void:
	visible = false


# Sets the target_code variable + redrawing the display accordingly.
func _set_target_code(val) -> void:
	# Using self here as we want the setter to run instead of directly set the codes.
	target_code = val
	_redraw_display()


# Redraws the code display to reflect the latest state.
func _redraw_display() -> void:
	for child in key_container.get_children():
		child.visible = false
	
	for key in target_code:
		key_container.get_node(key.capitalize()).visible = true
