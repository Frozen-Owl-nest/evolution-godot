extends Node

var Agent = load("res://agent.tscn")

func _ready():
	for i in range(10):
		var agent_instance = Agent.instantiate()
		self.get_parent().add_child.call_deferred(agent_instance)
		agent_instance.position = Vector2(randf_range(-1000, 1000),randf_range(-1000, 1000))
