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
var activation_method_index: int = 3

func get_activation_method() -> Callable:
	"""
	Returns the activation function based on the selected method.

	This method selects and returns a callable activation function based on the value of `activation_method`.
	The returned function can then be used to process input values and apply the activation function.

	Returns:
		Callable: The activation function selected by the activation_method_index` value.
	"""
	if activation_method_index == 0:
		return func(x):
			return sin(x*PI)
	if activation_method_index == 1:
		return func(x):
			return x/(abs(x)+1)
	if activation_method_index == 2:
		return func(x):
			return 1/(1+exp(-x))*2 - 1
	if activation_method_index == 3:
		return func(x):
			return exp(-pow(x,2))*2 - 1
	return func(x):
		return exp(-pow(x,2))*2 - 1

func save_as_json(path: String):
	"""
	Saves the current object as a JSON file.

	The function first checks if the provided path ends with '.json'. If not, it appends '.json'
	to the path. Then, it serializes the object into a JSON string using the object's `to_dict()` method,
	and saves this JSON data to the specified file path.

	Args:
		path (String): The file path where the JSON data should be saved.

	Returns:
		void: This function does not return a value.
	"""
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
	"""
	Loads data from a JSON file and updates the object's state with the parsed data.

	The function attempts to open the specified JSON file. If successful, it reads the content,
	parses it into a dictionary, and then updates the object's properties using the `from_dict()` method.
	If the file cannot be opened, an error message is printed.

	Args:
		path (String): The file path from which the JSON data should be loaded.

	Returns:
		null: This function doesn't return a value, but updates the object's state.
	"""
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
	"""
	Converts the settings into a dictionary for serialization or saving.

	This method creates and returns a dictionary representation of the current settings.

	Returns:
		Dictionary: A dictionary containing the settings.
	"""
	return {
		"spawned_food": spawned_food,
		"spawn_interval": spawn_interval,
		"spawn_radius": spawn_radius,
		"initial_number_of_food": initial_number_of_food,
		"initial_number_of_agents": initial_number_of_agents,
		"activation_method": activation_method_index,
		"mutation_rate": mutation_rate,
		"mutation_scale": mutation_scale,
		"number_of_receptors": number_of_receptors,
		"network_structure": network_structure
	}
	
func from_dict(dictionary: Dictionary):
	"""
	Initializes the settings from a given dictionary.

	This method sets settings based on the values in the provided dictionary.
	It is typically used for loading data or restoring the object to a saved state.

	Args:
		dictionary (Dictionary): The dictionary containing key-value pairs to set settings.
	"""
	initial_number_of_food = dictionary.get("initial_number_of_food")
	initial_number_of_agents = dictionary.get("initial_number_of_agents")
	spawned_food = dictionary.get("spawned_food")
	spawn_interval = dictionary.get("spawn_interval")
	spawn_radius = dictionary.get("spawn_radius")
	activation_method_index = dictionary.get("activation_method")
	mutation_rate = dictionary.get("mutation_rate")
	mutation_scale = dictionary.get("mutation_scale")
	number_of_receptors = dictionary.get("number_of_receptors")
	network_structure = dictionary.get("network_structure")
