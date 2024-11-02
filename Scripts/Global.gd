extends Node

var spawned_food: int = 50
var spawn_interval: int = 5
var spawn_radius: int = 4000
var initial_number_of_food: int = 500
var initial_number_of_agents: int = 50
var activation_method

func get_activation_method() -> Callable:
	if activation_method == "Sinusoid":
		return func(x):
			return sin(x*PI)
	if activation_method == "Softsign":
		return func(x):
			return x/(abs(x)+1)
	if activation_method == "Logistic Activation":
		return func(x):
			return 1/(1+exp(-x))
	if activation_method == "Gaussin Activation":
		return func(x):
			return exp(-pow(x,2))
	return func(x):
		return exp(-pow(x,2))
