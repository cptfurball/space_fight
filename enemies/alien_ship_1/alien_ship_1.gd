extends BaseEnemy

const MISSILE : Resource = preload("res://projectiles/energy_orb.tscn")


export(float) var attack_interval_max : float = 1.0
export(float) var attack_interval_min : float = 3.0


func _ready() -> void :
	$Timer.wait_time = rand_range(attack_interval_max, attack_interval_min)
	Events.connect("receive_damage", self, "_reset_attack_timer")


func _on_Timer_timeout():
	var player = Utils.get_player_node()
	if player:
		var missile = MISSILE.instance()
		missile.launch(global_position, player)
	#	missile.launch_at_dir($Position2D.global_position, Vector2.DOWN)
		get_tree().current_scene.add_child(missile)


func _reset_attack_timer(target, b):
	if target == self:
		$Timer.start()
