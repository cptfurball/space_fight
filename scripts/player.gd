extends Node2D

const projectile_scene := preload("res://scenes/base_projectile/base_projectile.tscn")

var target: BaseEnemy 

var max_projectiles: int = 3
var projectiles: Array = []



func _ready() -> void:
	Events.connect("selected_target", self, "_on_selected_target")
	Events.connect("launch_attack", self, "_on_launch_attack")


func _process(_delta) -> void:
	pass


func _on_launch_attack(damage_multiplier: float):
	var p = projectile_scene.instance()
	p.global_position = global_position
	p.init(target)
	get_node('../').add_child(p)


func _on_selected_target(new_target: BaseEnemy) -> void:
	target = new_target
