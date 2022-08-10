extends AnimatedSprite


func _ready():
	connect("animation_finished", self, "queue_free")
	$ExplodeSfx.play()
	$Particles2D.emitting = true
