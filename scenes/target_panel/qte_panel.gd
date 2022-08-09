extends Control


onready var qte_keys_container := $KeysContainer
onready var timer: Timer = $Timer
onready var timer_bar: TextureProgress = $TimerBar

var qte_time: float = 3.0
var qte_combo: Array
var player_input: Array

signal qte_combo_changed(new_combo)
signal qte_challenge_passed


# Runs at the beginning of the node instance.
func _ready() -> void:
	connect("qte_combo_changed", self, "_on_qte_combo_changed")
	timer.connect("timeout", self, "_on_qte_timeout")


# Generates the qte combo.
func generate_qte_code() -> void:
	var qte_combo_length = Utils.generate_random_int(
		Constants.QTE_COMBO_MIN_LENGTH, 
		Constants.QTE_COMBO_MAX_LENGTH
	)
	
	qte_combo = Utils.generate_random_combo(
		Constants.QTE_COMBO_KEY_LIST, 
		qte_combo_length
	)
	
	qte_combo.sort()
	
	emit_signal("qte_combo_changed", qte_combo)


# Runs on every frame.
# Process should only run if there is any target selected.
func _process(_delta) -> void:
	if not is_instance_valid(get_parent().target):
		visible = false
		qte_combo = []
		player_input = []
	else:
		visible = true
		_update_qte_key_color()
		_update_player_input()
		_process_qte_challenge()
		
		timer_bar.value = timer.time_left


# Checks whether the player passed the qte challenge.
func _process_qte_challenge() -> void:
	if qte_combo.size() and Utils.array_has_same_content(player_input, qte_combo):
		generate_qte_code()
		emit_signal("qte_challenge_passed")


# Processes the input from the player and store it.
# Function also sorts it in alphabetical order.
func _update_player_input() -> void:
	player_input = []
	
	for key in Constants.QTE_COMBO_KEY_LIST:
		if Input.is_action_pressed(key):
			player_input.push_back(key)
	
	if player_input.size() > 1:
		player_input.sort()


# Updates the qte key shown on the side panel.
func _update_qte_key_color() -> void:
	for key in Constants.QTE_COMBO_KEY_LIST:
		if qte_combo.has(key):
			qte_keys_container.get_node(key).color = Color.green
		else:
			qte_keys_container.get_node(key).color = Color.red


# When qte has timed out, what should we do?
func _on_qte_timeout() -> void:
	generate_qte_code()


func _on_qte_combo_changed(_new_combo) -> void:
	if get_parent().target:
		var timeout : float = Constants.QTE_DIFFICULTY_TIMEOUT[get_parent().target.qte_difficulty]
		
		timer_bar.min_value = 0
		timer_bar.max_value = timeout
		
		timer.stop()
		timer.start(timeout)
