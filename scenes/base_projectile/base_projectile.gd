extends KinematicBody2D


export(float, 1, 20, 0.1) var damage: float = 2
export(float, 50, 250) var speed: float = 250

var target: Node2D
var damage_multiplier: float = 1.0

var target_dir: Vector2 = Vector2.UP
var velocity: Vector2


func _ready() -> void:
	add_to_group(Constants.GROUP_PROJECTILE)


func _process(delta):
	if not Utils.is_within_window(global_position):
		_explode()
	
	$Trail.add_point(global_position)
	
	_process_movement()
	_process_collision()


func launch(current_position: Vector2, new_target: Node2D, new_damage_multiplier: float = 1.0):
	global_position = current_position
	target = new_target
	damage_multiplier = new_damage_multiplier
	$LaunchSfx.play()


func _process_movement():
	if is_instance_valid(target):
		var target_pos: Vector2 = target.transform.origin
		target_dir = transform.origin.direction_to(target_pos)
	
	velocity = target_dir * speed
	move_and_slide(velocity)


func _process_collision():
	var slides: int = get_slide_count()
	
	for i in slides:
		var collision = get_slide_collision(i)
		
		if collision.collider.is_in_group(Constants.GROUP_ENEMY):
			_collide_with_enemy(collision.collider)
		
		break
	
	if slides > 0:
		_explode()


func _collide_with_enemy(collider) -> void:
	Events.emit_signal("receive_damage", collider, damage * damage_multiplier)


func _collide_with_player(collider) -> void:
	Events.emit_signal("receive_damage", collider, damage)


func _explode():
	Utils.spawn_explosion(global_position)
	queue_free()
