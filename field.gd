extends Node2D


var agets_in = []

func _process(delta):
	for agent in agets_in:
		agent.set_meta('energy', agent.get_meta('energy') + 1);

func _on_area_2d_body_entered(body):
	agets_in.append(body)


func _on_area_2d_body_exited(body):
	agets_in.erase(body)
