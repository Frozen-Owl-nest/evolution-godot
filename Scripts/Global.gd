extends Node

var spawned_food: int = 50
var spawn_interval: int = 5
var spawn_radius: int = 4000
var initial_number_of_food: int = 500
var initial_number_of_agents: int = 50
var mutation_rate: int = 40
var mutation_scale: int = 20
var number_of_receptors: int = 5
var network_structure: Array = [3, 4]
var activation_method: int = 3

func get_activation_method() -> Callable:
	if activation_method == 0:
		return func(x):
			return sin(x*PI)
	if activation_method == 1:
		return func(x):
			return x/(abs(x)+1)
	if activation_method == 2:
		return func(x):
			return 1/(1+exp(-x))*2 - 1
	if activation_method == 3:
		return func(x):
			return exp(-pow(x,2))*2 - 1
	return func(x):
		return exp(-pow(x,2))*2 - 1

func save_as_json(path: String):
	if path.right(5) != ".json":
		path += ".json"
	var json_data = JSON.stringify(self.to_dict(), "\t")
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(json_data)
		file.close()
	else:
		print("Could not create a file: " + path)

func load_from_json(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var result = JSON.parse_string(json_string)
		self.from_dict(result)
	else:
		print("Could not open file: " + path)
	return null

func to_dict() -> Dictionary:
	return {
		"spawned_food": spawned_food,
		"spawn_interval": spawn_interval,
		"spawn_radius": spawn_radius,
		"initial_number_of_food": initial_number_of_food,
		"initial_number_of_agents": initial_number_of_agents,
		"activation_method": activation_method,
		"mutation_rate": mutation_rate,
		"mutation_scale": mutation_scale,
		"number_of_receptors": number_of_receptors,
		"network_structure": network_structure
	}
	
func from_dict(dictionary: Dictionary):
	initial_number_of_food = dictionary.get("initial_number_of_food")
	initial_number_of_agents = dictionary.get("initial_number_of_agents")
	spawned_food = dictionary.get("spawned_food")
	spawn_interval = dictionary.get("spawn_interval")
	spawn_radius = dictionary.get("spawn_radius")
	activation_method = dictionary.get("activation_method")
	mutation_rate = dictionary.get("mutation_rate")
	mutation_scale = dictionary.get("mutation_scale")
	number_of_receptors = dictionary.get("number_of_receptors")
	network_structure = dictionary.get("network_structure")
