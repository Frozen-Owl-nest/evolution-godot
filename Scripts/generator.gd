extends Node

var Agent = load("res://Assets/agent.tscn")
var Food = load("res://Assets/food.tscn")

var agent_list = []
var food_list = []

var spawn_countdown = Global.spawn_interval
var spawn_radius = Global.spawn_radius

func _ready():
	for i in range(Global.initial_number_of_agents):
		var agent_instance = Agent.instantiate()
		var theta = randf() * TAU
		
		self.get_parent().add_child.call_deferred(agent_instance)
		agent_instance.position = polar_to_catesian(theta, randf() * Global.spawn_radius)
		agent_instance.get_node("Sprite2D").modulate = Color(randf(), randf(), randf())
		agent_list.append(agent_instance)
	
	for i in range(Global.initial_number_of_food):
		var food_instance = Food.instantiate()
		var theta = randf() * TAU
		
		self.get_parent().add_child.call_deferred(food_instance)
		food_instance.scale = Vector2(randf_range(1, 3),randf_range(1, 3))
		food_instance.position = polar_to_catesian(theta, randf() * Global.spawn_radius)
		food_list.append(food_instance)

func _process(delta):
	spawn_countdown -= delta
	if spawn_countdown <= 0:
		for i in range(int(Global.spawned_food)):
			var food_instance = Food.instantiate()
			var theta = randf() * TAU
			self.get_parent().add_child.call_deferred(food_instance)
			food_instance.scale = Vector2(randf_range(1, 3),randf_range(1, 3))
			food_instance.position = polar_to_catesian(theta, randf() * Global.spawn_radius)
			food_list.append(food_instance)
		spawn_countdown = Global.spawn_interval
		
func polar_to_catesian(theta: float, radius: float):
	"""
	Converts polar coordinates (angle and radius) to Cartesian coordinates.

	Args:
		theta (float): The angle in radians.
		radius (float): The distance from the origin.

	Returns:
		Vector2: The Cartesian coordinates (x, y) as a Vector2 object.
	"""
	return Vector2(radius * cos(theta), radius * sin(theta))
