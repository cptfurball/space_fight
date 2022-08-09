extends Control

const SHIELD_DAMAGE: int = 1
const HEALTH_DAMAGE: int = 2

var target: BaseEnemy

onready var qte: Control = $QTE

func _ready() -> void:
	Events.connect("selected_target", self, "_on_selected_target")
	qte.connect("qte_challenge_passed", self, "_on_qte_challenge_passed")


func _on_selected_target(new_target: BaseEnemy) -> void:
	if new_target.is_in_group(Constants.GROUP_ENEMY):
		new_target.connect("death", self, "_on_target_death")
		
		if target:
			target.disconnect("death", self, "_on_target_death")
	
	target = new_target
	qte.generate_qte_code()


func _on_target_death() -> void:
	target = null


func _on_qte_challenge_passed() -> void:
	Events.emit_signal("receive_damage_to_shield", target, SHIELD_DAMAGE)


func _process(_delta) -> void:
	if Input.is_action_just_pressed("launch"):
		Events.emit_signal("receive_damage_to_health", target, HEALTH_DAMAGE)
