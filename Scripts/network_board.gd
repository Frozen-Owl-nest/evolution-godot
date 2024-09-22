extends Panel

var structure

var node = load("res://node.tscn")

var network

func _ready():
	structure = [5,10,12,1]
	var distance_x = (self.get_rect().size.x - len(structure))/(len(structure) + 1)
	for x in range(len(structure)):
		var distance_y = (self.get_rect().size.y - structure[x])/(structure[x] + 1)
		for y in range(structure[x]):
			var node_instance = node.instantiate()
			node_instance.position = Vector2(distance_x + x * distance_x, distance_y + distance_y*y)
			node_instance.scale = Vector2(0.3, 0.3)
			node_instance.set_meta("Weights", [1,10,2])
			node_instance.set_meta("Bias", y)
			self.add_child(node_instance)

