extends AnimatedSprite

const CURSOR_SMOOTHING : int = 10
const HIDDEN_COORDS : Vector2 = Vector2(300, 300)

const DAMAGE_MULTIPLIER_MAX_VALUE : float = 50.0
const DAMAGE_MULTIPLIER_MIN_VALUE : float = 1.0
const DAMAGE_MULTIPLIER_LOST_PER_FRAME : float = 0.1
const DAMAGE_MULTIPLIER_GAIN_PER_PASS : float = 20.0 # Temporary implementation, follow difficulty

onready var qte : Node2D = $QTE
onready var damage_multiplier_bar : TextureProgress = $DamageMultiplierBar
onready var health_bar : TextureProgress = $HealthBar
onready var target_select_sfx: AudioStreamPlayer = $TargetSelectSfx

var target: BaseEnemy
var damage_multiplier: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("selected_target", self, "_on_selected_target")
	qte.connect("qte_challenge_passed", self, "_on_qte_challenge_passed")


# Main process function. This is called frame by frame.
func _process(delta) -> void:
	if _has_target():
		_process_update_cursor(delta)
	else:
		_hide()


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
	_update_damage_multiplier(min(damage_multiplier + DAMAGE_MULTIPLIER_GAIN_PER_PASS, DAMAGE_MULTIPLIER_MAX_VALUE))
	Events.emit_signal("launch_attack", damage_multiplier)
