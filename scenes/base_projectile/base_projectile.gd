extends KinematicBody2D

const explosion = preload("res://scenes/base_enemy/explosion.tscn")

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
		$Trail.add_point(global_position)
		move_and_slide(velocity)
		
		if get_slide_count() > 0:
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.is_in_group('enemy'):
					print('found enemy')
					
					Events.emit_signal("shake_camera", 0.3)
					target.emit_signal('receive_damage', damage)
					Utils.set_pause_node(self, true)
					break
			_spawn_explosion()
			
	elif not target_dir == Vector2.ZERO:
		var velocity: Vector2 = target_dir * speed
		
		move_and_slide(velocity)
		
		if get_slide_count() > 0:
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.is_in_group('enemy'):
					Events.emit_signal("shake_camera", 0.3)
					target.emit_signal('receive_damage', damage)
					Utils.set_pause_node(self, true)
					
					break
			
			_spawn_explosion()

func _spawn_explosion():
	var e = explosion.instance()
	add_child(e)
	e.connect("animation_finished", self, "queue_free")
	e.play("default")
