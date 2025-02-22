extends Panel

var structure

var node = load("res://UI/node.tscn")

var tracked_agent
var refresh_timer = 0.0 

func _ready():
	structure = [Global.number_of_receptors]
	structure.append_array(Global.network_structure)
	structure.append(2)
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
	refresh_timer += delta
	if refresh_timer >= 1:
		refresh_timer = 0
		if tracked_agent != null:
			self.show()
			self.get_child(0).get_child(0).text = "Age: " + str(int(tracked_agent.age)) + " s"
			self.get_child(0).get_child(1).text = "Energy: " + str(int(tracked_agent.energy)) + " µcal"
			self.get_child(0).get_child(2).text = "Energy Change: " + str("%0.3f" % ((tracked_agent.speed + abs(tracked_agent.rotation_change))/(2*delta))) + " µcal/s"
			self.get_child(0).get_child(3).text = "Number of Children: " + str(tracked_agent.number_of_children)
			self.get_child(0).get_child(4).text = "Colour: " + str(tracked_agent.get_node("Sprite2D").modulate)
		else:
			self.hide()

func set_agent(agent):
	"""
	Assigns the given agent to be tracked and initializes UI elements to display its state.

	Args:
		agent (Agent): The agent instance to track. If null, clears the tracked agent.
	"""
	tracked_agent = agent
	refresh_timer = 1
	if tracked_agent != null:
		var neurons = agent.network.get_neurons()
		for i in range(len(agent.receptors)):
			self.get_child(1).get_child(i).set_receptor(agent.receptors[i])
		for i in range(len(neurons)):
			self.get_child(1).get_child(i + len(agent.receptors)).set_neuron(neurons[i])
