extends RigidBody2D

var data_collector

var Network = load("res://Scripts/neuronNetwork.gd").NeuralNetwork
var Prefab = load("res://Assets/agent.tscn")
var Food = load("res://Scripts/food.gd")

var speed = 1
var energy = 300
var number_of_children = 0
var network = Network.create_a_random_network(Global.number_of_receptors, 1, Global.network_structure)
var bodies_in_area = []
var receptors = []

func _ready():
	data_collector = get_node("/root/Scene/DataCollector")
	if data_collector:
		data_collector.agent_list.append(self)
	self.rotation = randf() * 360
	for i in range(1, Global.number_of_receptors + 1):
		var ray = RayCast2D.new()
		ray.target_position = Vector2(0,-100)
		if Global.number_of_receptors%2 == 1:
			ray.rotation_degrees = (i - i % 2) / 2 * 45 * pow(-1, i)
		else:
			ray.rotation_degrees = ((i + 1 - (i+1) % 2) / 2 * 30 - 15)* pow(-1, i)
		self.add_child(ray)
		receptors.append(ray)
		ray.enabled = true

func _physics_process(delta):
	var output = network.get_output(get_receptors_data())
	speed = 0.05 # output[0] * 0.1
	linear_velocity = Vector2.UP.rotated(self.rotation) * abs(speed) * 1000
	energy -= speed * 12
	rotation += (output[0]*2-1) / 50
	if energy <= 0:
		if data_collector:
			data_collector.agent_list.erase(self)
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
	get_node("/root/Scene/CanvasLayer/StatsPanel").set_agent(self)
	get_node("/root/Scene/CanvasLayer/Marker").tracked_agent = self
