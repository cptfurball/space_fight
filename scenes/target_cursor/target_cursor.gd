extends AnimatedSprite

const CURSOR_SMOOTHING : int = 10
const HIDDEN_COORDS : Vector2 = Vector2(300, 300)
const HAX_SUCCESS_THRESHOLD : float = 95.0
const HAX_MAX_VALUE : float = 100.0
const HAX_MIN_VALUE : float = 0.0
const HAX_PROGRESS_LOST_PER_FRAME : float = 0.1
const HAX_PROGRESS_GAIN_PER_PASS : float = 20.0 # Temporary implementation, follow difficulty
const HEALTH_DAMAGE : int = 2 # Temporary implementation

onready var qte : Node2D = $QTE
onready var hax_progress : TextureProgress = $HaxProgress
onready var hp : TextureProgress = $HP

var target: BaseEnemy


func _ready() -> void:
	Events.connect("selected_target", self, "_on_selected_target")
	qte.connect("qte_challenge_passed", self, "_on_qte_challenge_passed")


func _process(delta) -> void:
	if _has_target():
		_process_update_cursor(delta)
	else:
		_hide_cursor()


func _process_update_cursor(delta) -> void:
	hax_progress.value = max(hax_progress.value - HAX_PROGRESS_LOST_PER_FRAME, 0)
	visible = true
	transform.origin = transform.origin.linear_interpolate(target.transform.origin, delta * CURSOR_SMOOTHING)
	hp.value = target.current_health
	
	if hax_progress.value > HAX_SUCCESS_THRESHOLD and Input.is_action_just_pressed("launch"):
		Events.emit_signal("receive_damage_to_health", target, HEALTH_DAMAGE)


func _hide_cursor() -> void:
	transform.origin = HIDDEN_COORDS
	Utils.set_pause_node(self, true)


func _has_target() -> bool:
	return is_instance_valid(target)


func _reset_hax_progress() -> void:
	hax_progress.value = 0.0


func _on_selected_target(new_target: BaseEnemy) -> void:
	$MenuSelect.play()
	Utils.set_pause_node(self, false)
	
	_reset_hax_progress()
	
	target = new_target
	hp.max_value = target.max_health
	
	qte.generate_qte_code()


func _on_qte_challenge_passed() -> void:
	hax_progress.value = min(hax_progress.value + HAX_PROGRESS_GAIN_PER_PASS, HAX_MAX_VALUE)
