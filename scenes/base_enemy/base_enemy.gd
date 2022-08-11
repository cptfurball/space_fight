extends KinematicBody2D
class_name BaseEnemy

export var max_health : float = 100
export var qte_difficulty: int = 1

var health : float = 0
var highlighted: bool = false
var selected: bool = false

signal death
signal receive_damage(damage)
signal target_code_changed(new_code)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Constants.GROUP_ENEMY)
	_setup_signal_connection()
	
	health = max_health


func _setup_signal_connection() -> void:
	connect('mouse_entered', self, '_on_mouse_entered') # warning-ignore:return_value_discarded
	connect('mouse_exited', self, '_on_mouse_exited') # warning-ignore:return_value_discarded
	connect('death', self, '_on_death') # warning-ignore:return_value_discarded
	
	Events.connect("selected_target", self, "_on_selected_target") # warning-ignore:return_value_discarded
	Events.connect("receive_damage", self, "_on_receive_damage") # warning-ignore:return_value_discarded


func _process(_delta):
	_process_check_health()


func _process_check_health():
	pass


func _input(_event) -> void:
	if highlighted and Input.is_action_just_pressed('left_click'):
		Events.emit_signal('selected_target', self)


func _on_mouse_entered() -> void:
	highlighted = true


func _on_mouse_exited() -> void:
	highlighted = false


func _on_receive_damage(target: KinematicBody2D, damage: int) -> void:
	if target == self:
		health = int(max(health - damage, 0))
		
		if health == 0:
			emit_signal("death")


func _on_death() -> void:
	Utils.spawn_explosion(global_position)
	queue_free()


func _on_selected_target(new_target) -> void:
	if new_target == self:
		selected = true
	else:
		selected = false
