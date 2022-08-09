extends Node2D


var qte_combo: Array
var player_input: Array

signal qte_combo_changed(new_combo)
signal qte_challenge_passed


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
	_update_qte_sprite()
	_update_player_input()
	_process_qte_challenge()


# Checks whether the player passed the qte challenge.
func _process_qte_challenge() -> void:
	if qte_combo.size() and Utils.array_has_same_content(player_input, qte_combo):
		emit_signal("qte_challenge_passed")
		generate_qte_code()


# Processes the input from the player and store it.
# Function also sorts it in alphabetical order.
func _update_player_input() -> void:
	player_input = []
	
	for key in Constants.QTE_COMBO_KEY_LIST:
		if Input.is_action_pressed(key):
			player_input.push_back(key)
	
	if player_input.size() > 1:
		player_input.sort()


# Updates the qte key shown on bottom of the target.
func _update_qte_sprite() -> void:
	for key in Constants.QTE_COMBO_KEY_LIST:
		if qte_combo.has(key):
			get_node(key).play("default")
		else:
			get_node(key).play("empty")
