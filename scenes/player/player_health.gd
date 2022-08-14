extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Utils.get_player_node()
	max_value = player.max_health
	value = 50
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		value = player.health
	else:
		value = 0
	pass
