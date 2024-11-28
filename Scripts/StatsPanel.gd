extends Panel

var structure

var node = load("res://UI/node.tscn")

var tracked_agent

func _ready():
	structure = [Global.number_of_receptors]
	structure.append_array(Global.network_structure)
	structure.append(1)
	var distance_x = (self.get_child(1).get_rect().size.x - len(structure))/(len(structure) + 1)
	for x in range(len(structure)):
		var distance_y = (self.get_child(1).get_rect().size.y - structure[x])/(structure[x] + 1)
		for y in range(structure[x]):
			var node_instance = node.instantiate()
			node_instance.position = Vector2(distance_x + x * distance_x, distance_y + distance_y*y)
			node_instance.scale = Vector2(0.3, 0.3)
			node_instance.set_meta("Weights", [1,10,2])
			node_instance.set_meta("Bias", y)
			self.get_child(1).add_child(node_instance)
			
func _process(delta):
	if tracked_agent != null:
		self.show()
		self.get_child(0).get_child(0).text = "  Energy: " + str(int(tracked_agent.energy))
		self.get_child(0).get_child(1).text = "  Number of children: " + str(tracked_agent.number_of_children)
		self.get_child(0).get_child(2).text = "  Colour: " + str(tracked_agent.get_node("Sprite2D").modulate)
	else:
		self.hide()

func set_agent(agent):
	tracked_agent = agent
	var neurons = agent.network.get_neurons()
	for i in range(len(agent.receptors)):
		self.get_child(1).get_child(i).set_receptor(agent.receptors[i])
	for i in range(len(neurons)):
		self.get_child(1).get_child(i + len(agent.receptors)).set_neuron(neurons[i])
