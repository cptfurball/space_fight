extends Node2D

const projectile_scene := preload("res://scenes/base_projectile/base_projectile.tscn")

var target: BaseEnemy 

var max_projectiles: int = 3
var projectiles: Array = []



func _ready() -> void:
	Events.connect("selected_target", self, "_on_selected_target")


func _process(_delta) -> void:
	if Input.is_action_just_pressed("launch") and is_instance_valid(target):
		var p = projectile_scene.instance()
		p.global_position = global_position
		p.init(target)
		get_node('../').add_child(p)


func _on_selected_target(new_target: BaseEnemy) -> void:
	target = new_target
