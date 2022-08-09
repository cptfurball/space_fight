extends KinematicBody2D


var target: Node2D
var speed: float = 100
var target_dir: Vector2 = Vector2.ZERO
var damage: int = 2

func init(new_target: Node2D):
	target = new_target

func _process(delta):
	if is_instance_valid(target):
		var target_pos: Vector2 = target.transform.origin
		target_dir = transform.origin.direction_to(target_pos)
		var velocity: Vector2 = target_dir * speed
		
		move_and_slide(velocity)
		
		if get_slide_count() > 0:
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.is_in_group('enemy'):
					target.emit_signal('receive_damage', damage)
					break
			
			queue_free()
	elif not target_dir == Vector2.ZERO:
		var velocity: Vector2 = target_dir * speed
		
		move_and_slide(velocity)
		
		if get_slide_count() > 0:
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.is_in_group('enemy'):
					target.emit_signal('receive_damage', damage)
					break
			
			queue_free()
