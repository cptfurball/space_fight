extends Node2D

const projectile_scene := preload("res://projectiles/missile.tscn")

#var target: BaseEnemy 

func _ready() -> void:
#	Events.connect("selected_target", self, "_on_selected_target")
	Events.connect("launch_attack", self, "_on_launch_attack")


func _on_launch_attack(target : BaseEnemy, damage_multiplier: float):
	if is_instance_valid(target):
		var projectile = projectile_scene.instance()
		projectile.launch(global_position, target, damage_multiplier)
		get_tree().current_scene.add_child(projectile)

#
#func _on_selected_target(new_target: BaseEnemy) -> void:
#	target = new_target
