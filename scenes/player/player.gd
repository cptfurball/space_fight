extends KinematicBody2D
class_name Player

export var max_health : float = 100

var health : float = 0
var is_force_field_enabled : bool = false
var force_field_modulate_hue : float = 0.0

signal death
signal receive_damage(damage)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Constants.GROUP_PLAYER)
	_setup_signal_connection()
	
	health = max_health


func _process(_delta) -> void:
	if (Input.is_action_pressed("force_field_e")
		and Input.is_action_pressed("force_field_q")
		and Input.is_action_pressed("force_field_w")
		and Input.is_action_pressed("force_field_r")):
		is_force_field_enabled = true
	else:
		is_force_field_enabled = false
	
	_modulate_sprite_color(_delta)

func _modulate_sprite_color(delta):
	if is_force_field_enabled:
		force_field_modulate_hue += delta * 3
		
		if force_field_modulate_hue > 1.0:
			force_field_modulate_hue = 0.0
		
		$Sprite.modulate = Color.white.from_hsv(force_field_modulate_hue, 1.0, 1.0)
	else:
		$Sprite.modulate = Color.white
	


func _setup_signal_connection() -> void:
	connect('death', self, '_on_death') # warning-ignore:return_value_discarded
	Events.connect("receive_damage", self, "_on_receive_damage") # warning-ignore:return_value_discarded


func _on_receive_damage(target: KinematicBody2D, damage: int) -> void:
	print(target)
	if target == self and not is_force_field_enabled:
		health = int(max(health - damage, 0))
		
		if health == 0:
			emit_signal("death")


func _on_death() -> void:
	Utils.spawn_explosion(global_position)
	queue_free()
