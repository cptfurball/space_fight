extends AnimatedSprite

const CURSOR_SMOOTHING : int = 10
const HIDDEN_COORDS : Vector2 = Vector2(300, 300)

const DAMAGE_MULTIPLIER_MAX_VALUE : float = 10.0
const DAMAGE_MULTIPLIER_MIN_VALUE : float = 1.0
const DAMAGE_MULTIPLIER_LOST_PER_FRAME : float = 0.01
const DAMAGE_MULTIPLIER_GAIN_PER_PASS : float = 2.0 # Temporary implementation, follow difficulty

export(NodePath) var target_container_node_path : NodePath

onready var qte : Node2D = $QTE
onready var damage_multiplier_bar : TextureProgress = $DamageMultiplierBar
onready var health_bar : TextureProgress = $HealthBar
onready var target_select_sfx: AudioStreamPlayer = $TargetSelectSfx
onready var target_container : Node2D

var target: BaseEnemy
var damage_multiplier: float = 0.0

var target_index: int = 0
var target_size: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("selected_target", self, "_on_selected_target")
	qte.connect("qte_challenge_passed", self, "_on_qte_challenge_passed")
	target_size = get_tree().current_scene.get_node_or_null("Enemies").get_children().size()
	
	target_container = get_node_or_null(target_container_node_path)
	_cycle_target()


# Main process function. This is called frame by frame.
func _process(delta) -> void:
	if Input.is_action_just_pressed("cycle_target"):
		_cycle_target()
	
	if _has_target():
		_process_update_cursor(delta)
	else:
		_cycle_target()
#		_hide()


func _cycle_target():
	var targets = target_container.get_children()
	
	target_index += 1
	
	if target_index >= target_size:
		target_index = 0
	
	target = targets[target_index]
	Events.emit_signal("selected_target", target)


# This is a subset of the main process function. This is to keep code clean.
# Continuously update the cursor information frame by frame.
func _process_update_cursor(delta) -> void:
	visible = true
	transform.origin = transform.origin.linear_interpolate(target.transform.origin, delta * CURSOR_SMOOTHING)
	health_bar.value = target.health
	
	_update_damage_multiplier(max(damage_multiplier - DAMAGE_MULTIPLIER_LOST_PER_FRAME, DAMAGE_MULTIPLIER_MIN_VALUE))


# Hides itself (current node) to an offscreen location and pause it.
func _hide() -> void:
	transform.origin = HIDDEN_COORDS
	Utils.set_pause_node(self, true)


# Checks whether target is a valid target.
func _has_target() -> bool:
	return is_instance_valid(target)


# Updates the damage multiplier with new value.
func _update_damage_multiplier(value) -> void:
	damage_multiplier = value
	damage_multiplier_bar.value = damage_multiplier


# Reset the damage multipliers to the min value.
func _reset_damage_multipler() -> void:
	damage_multiplier = DAMAGE_MULTIPLIER_MIN_VALUE
	damage_multiplier_bar.value = damage_multiplier


# On selected target
func _on_selected_target(new_target: BaseEnemy) -> void:
	Utils.set_pause_node(self, false)
	
	target_select_sfx.play()
	_reset_damage_multipler()
	
	target = new_target
	health_bar.max_value = target.max_health
	
	qte.generate_qte_combo()


# Handle event when player passed the QTE challenge.
func _on_qte_challenge_passed() -> void:
	Events.emit_signal("launch_attack", damage_multiplier)
	_update_damage_multiplier(min(damage_multiplier + DAMAGE_MULTIPLIER_GAIN_PER_PASS, DAMAGE_MULTIPLIER_MAX_VALUE))
