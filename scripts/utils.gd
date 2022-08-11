extends Node

const EXPLOSION_SCENE: Resource = preload("res://scenes/explosion/explosion.tscn")
const EXPLOSION_TRAUMA: float = 0.5

var window_rect: Rect2


func _ready():
	var width: float = ProjectSettings.get_setting("display/window/size/width")
	var height: float = ProjectSettings.get_setting("display/window/size/height")
	
	window_rect = Rect2(Vector2.ZERO, Vector2(width, height))


# Checks if array have the same content by comparing its hash.
# Each array is sorted before generating the hash.
func array_has_same_content(array_a: Array, array_b: Array) -> bool:
	return array_a.hash() == array_b.hash()


func generate_random_combo(list: Array, length: int) -> Array:
	var code: Array = []
	
	while code.size() < length:
		var random_code = list[randi() % list.size()]
		
		if not code.has(random_code):
			code.push_back(random_code)
	
	return code


# Generates random length for the code.
func generate_random_int(min_number: int, max_number: int) -> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	return rng.randi_range(min_number, max_number)


#(Un)pauses a single node
func set_pause_node(node : Node, pause : bool) -> void:
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)


# Spawns an explosion at a given position.
func spawn_explosion(spawn_pos: Vector2) -> void:
	Events.emit_signal("shake_camera", EXPLOSION_TRAUMA)
	var explosion: AnimatedSprite = EXPLOSION_SCENE.instance()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = spawn_pos
	explosion.play()


func is_within_window(point: Vector2) -> bool:
	return window_rect.has_point(point)
