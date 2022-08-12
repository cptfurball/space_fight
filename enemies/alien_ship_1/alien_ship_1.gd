extends BaseEnemy

const MISSILE : Resource = preload("res://projectiles/energy_orb.tscn")


func _on_Timer_timeout():
	var missile = MISSILE.instance()
	missile.launch_at_dir($Position2D.global_position, Vector2.DOWN)
	get_tree().current_scene.add_child(missile)
