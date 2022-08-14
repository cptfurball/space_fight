extends BaseEnemy

const MISSILE : Resource = preload("res://projectiles/energy_orb.tscn")


func _on_Timer_timeout():
	var player = Utils.get_player_node()
	if player:
		var missile = MISSILE.instance()
		missile.launch(global_position, player)
	#	missile.launch_at_dir($Position2D.global_position, Vector2.DOWN)
		get_tree().current_scene.add_child(missile)
