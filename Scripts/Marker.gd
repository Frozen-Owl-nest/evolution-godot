extends Sprite2D

var camera
var tracked_agent

func _ready():
	camera = get_node("/root/Scene/Camera2D")

func _process(delta):
	var viewport = get_viewport_rect()
	if tracked_agent != null:
		self.show()
		self.position = camera.to_local(tracked_agent.position) * camera.zoom + viewport.size/2
		self.scale = 0.5 * camera.zoom
	else:
		self.hide()
