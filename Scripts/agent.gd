extends Node

@onready var receptors = [$Receptor_1, $Receptor_2, $Receptor_3, $Receptor_4, $Receptor_5]

var Network = load("res://Scripts/neuronNetwork.gd").NeuralNetwork
var Prefab = load("res://Assets/agent.tscn")
var Food = load("res://Scripts/food.gd")

var speed = 1
var energy = 300
var number_of_children = 0
var network = Network.create_a_random_network(5, 1, [10,12])
var bodies_in_area = []

func _ready():
	self.rotation = randf() * 360

func _physics_process(delta):
	var output = network.get_output(get_receptors_data())
	speed = 0.05 # output[0] * 0.1
	self.linear_velocity = Vector2.UP.rotated(self.rotation) * abs(speed) * 1000
	energy -= speed * 12
	self.rotation += (output[0]*2-1) / 50
	if energy <= 0:
		self.queue_free()
	if len(bodies_in_area):
		if energy > 600:
			var child_instance = Prefab.instantiate()
			child_instance.position = self.position + Vector2(1, 1)
			child_instance.network = Network.mutate1(network)
			var color_mod = Color((randf()*2-1)/16, (randf()*2-1)/16, (randf()*2-1)/16)
			child_instance.get_node("Sprite2D").modulate = self.get_node("Sprite2D").modulate + color_mod
			self.get_parent().add_child(child_instance)
			number_of_children += 1
			energy -= 300
	for body in bodies_in_area:
		if body.get_script() == Food:
			energy += 10 * 2
			body.subtract_energy(10)

func get_colour(body):
	if body != null:
		if body.get_script() == Food:
			return 1
	return 0

func get_receptors_data():
	var signals = []
	for receptor in receptors:
		signals.append(get_colour(receptor.get_collider()))
	return signals

func _on_area_2d_body_entered(body):
	bodies_in_area.append(body)

func _on_area_2d_body_exited(body):
	bodies_in_area.erase(body)
	
func on_click():
	get_node("/root/Scene/CanvasLayer/Panel").set_agent(self)
	get_node("/root/Scene/CanvasLayer/Marker").tracked_agent = self
