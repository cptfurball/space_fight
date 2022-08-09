extends Control


onready var hp_value: Label = $HPValue
onready var sp_value: Label = $SPValue

# Runs on every frame.
# Process should only run if there is any target selected.
func _process(_delta) -> void:
	if not is_instance_valid(get_parent().target):
		visible = false
	else:
		visible = true
		_update_hp_value()
		_update_sp_value()


func _update_hp_value():
	hp_value.text = str(get_parent().target.health)


func _update_sp_value():
	sp_value.text = str(get_parent().target.shield)
