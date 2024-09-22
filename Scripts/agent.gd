extends Node

@onready var receptors = [$Receptor_1, $Receptor_2, $Receptor_3, $Receptor_4, $Receptor_5]

var Network = load("res://Scripts/neuronNetwork.gd").NeuralNetwork
var Prefab = load("res://agent.tscn")
var Food = load("res://Scripts/food.gd")

var speed = 1
var energy = 500
var number_of_children = 0
var network = Network.create_a_random_network(5, 1, [10,12])
var bodies_in_area = []

func _ready():
	var sprite = $Sprite2D
	sprite.modulate = Color(randf(), randf(), randf())
	self.rotation = randf() * 360

func _physics_process(delta):
	var output = network.get_output(get_receptors_data())
	speed = 0.05 # output[0] * 0.1
	self.linear_velocity = Vector2.UP.rotated(self.rotation) * abs(speed) * 1000
	energy -= speed * 12
	self.rotation += (output[0] * 2 - 1) / 50
	if energy <= 0:
		self.queue_free()
	if len(bodies_in_area):
		if energy > 600:
			var child_instance = Prefab.instantiate()
			child_instance.position = self.position + Vector2(1, 1)
			child_instance.network = Network.mutate1(network)
			self.get_parent().add_child(child_instance)
			number_of_children += 1
			energy -= 300
	for body in bodies_in_area:
		if body.get_script() == Food:
			energy += 10 * 2
			body.subtract_energy(10)

func get_colour(body):
	if body == null:
		return -1
	var colour = body.get_node("Sprite2D").modulate
	return float((255 - colour[0])/255 * 0.1 + (255 - colour[1])/255 * 0.2 + (255 - colour[2])/255 * 0.3)

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
	var panel = get_node("/root/Scene/CanvasLayer/Panel")
	panel.show()
	panel.get_child(0).get_child(0).text = "  Energy: " + str(int(energy))
	panel.get_child(0).get_child(1).text = "  Number of children: " + str(number_of_children)
	panel.get_child(0).get_child(2).text = "  Colour: " + str($Sprite2D.modulate)
