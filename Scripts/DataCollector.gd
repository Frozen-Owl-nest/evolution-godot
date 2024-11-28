extends Node

var agent_list = []
var food_list = []

var time_series = []

func _on_timer_timeout():
	time_series.append([len(agent_list),len(food_list)])
