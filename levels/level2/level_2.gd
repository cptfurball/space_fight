extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartTimer.start(3.0)
	Utils.set_pause_node(self, true)
	$Player.connect("death", self, "_return_to_main_menu")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Enemies.get_child_count() == 0:
		if $Win.visible == false:
			$WinTimer.start(3.0)
		
		$Win.visible = true


func _return_to_main_menu():
	get_tree().change_scene("res://levels/death.tscn")


func _on_Timer_timeout():
	Utils.set_pause_node(self, false)
	$Start.visible = false
	pass # Replace with function body.


func _on_WinTimer_timeout():
	print('wiiinn')
	get_tree().change_scene("res://levels/level3/level_3.tscn")
	pass # Replace with function body.
