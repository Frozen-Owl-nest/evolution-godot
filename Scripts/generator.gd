extends Node

var Agent = load("res://agent.tscn")
var Food = load("res://food.tscn")

var agent_list = []
var food_list = []

var countdown = 5

func _ready():
	for i in range(60):
		var agent_instance = Agent.instantiate()
		self.get_parent().add_child.call_deferred(agent_instance)
		agent_instance.position = Vector2(randf_range(0, 2000),randf_range(0, 2000))
		agent_list.append(agent_instance)
	
	for i in range(500):
		var food_instance = Food.instantiate()
		self.get_parent().add_child.call_deferred(food_instance)
		food_instance.scale = Vector2(randf_range(1, 3),randf_range(1, 3))
		food_instance.position = Vector2(randf_range(0, 2000),randf_range(0, 2000))
		food_list.append(food_instance)

func _process(delta):
	countdown -= delta
	if countdown <= 0:
		for i in range(50):
			var food_instance = Food.instantiate()
			self.get_parent().add_child.call_deferred(food_instance)
			food_instance.scale = Vector2(randf_range(1, 3),randf_range(1, 3))
			food_instance.position = Vector2(randf_range(0, 2000),randf_range(0, 2000))
			food_list.append(food_instance)
		countdown = 5
	
