extends Control

var tracked_neuron
var tracked_receptor
var sprite

func _ready():
	sprite = $Sprite2D

func set_neuron(neuron):
	tracked_neuron = neuron
	tracked_receptor = null
	self.get_child(1).text = "Weights: " + str(tracked_neuron.weights) + "\n" + \
		"Bias: " + str(tracked_neuron.bias)
		
func set_receptor(receptor):
	tracked_receptor = receptor
	tracked_neuron = null
	self.get_child(1).text = "Raycasr2D"

func _process(delta):
	if tracked_neuron:
		if tracked_neuron.activated:
			sprite.modulate = Color.GREEN
		else:
			sprite.modulate = Color.RED
	#elif tracked_receptor:
		#if tracked_receptor.get_collider():
			#sprite.modulate = Color.GREEN
		#else:
			#sprite.modulate = Color.RED

func _on_area_2d_mouse_entered():
	self.get_child(1).visible = true

func _on_area_2d_mouse_exited():
	self.get_child(1).visible = false
