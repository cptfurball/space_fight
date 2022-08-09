extends Node2D

const projectile_scene := preload("res://scenes/base_projectile/base_projectile.tscn")

var target: Node2D 

var max_projectiles: int = 3
var projectiles: Array = []
