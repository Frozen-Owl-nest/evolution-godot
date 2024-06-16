extends Node

@onready var repceptor_1 = $Receptor_1
@onready var repceptor_2 = $Receptor_2
@onready var repceptor_3 = $Receptor_3

var Network = load("res://Scripts/neuronNetwork.gd").NeuralNetwork
var Prefab = load("res://agent.tscn")

var speed = 1
var rot = randf()
var mutation_rate: float = 1
var time = randf()
var network = Network.new(4, 3, [2,3])

func _physics_process(delta):
	var output = network.get_output([int(repceptor_1.is_colliding()), int(repceptor_2.is_colliding()), int(repceptor_3.is_colliding()), self.get_meta('energy')/1000])
	speed = output[0] * 0.1
	self.linear_velocity = Vector2.UP.rotated(self.rotation) * abs(speed) * 1000
	print(self.rotation)
	self.set_meta('energy', self.get_meta('energy') - abs(speed))
	rot = output[1] * 2 * PI
	time += delta
	self.rotation = rot
	if self.get_meta('energy') <= 0:
		self.queue_free()
	if output[2] > 0.5 and self.get_meta('energy') > 500:
		var child_instance = Prefab.instantiate()
		child_instance.position = self.position
		self.get_parent().add_child(child_instance)
		self.set_meta('energy', self.get_meta('energy') - 500)

func mutate():
	var new_network = network.Duplicate()
	for layer in new_network.layers:
		for neuron in layer.neurons:
			for i in range(neuron.weights.size()):
				if randf() < mutation_rate:
					neuron.weights[i] += randf() * 2 - 1
					if randf() < mutation_rate:
						neuron.bias += randf() * 2 - 1 
	return new_network

