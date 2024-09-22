extends Control

func _ready():
	self.get_child(1).text = "Weights: " + str(self.get_meta("Weights")) + "\n" + \
		"Bias: " + str(self.get_meta("Bias"))

func _on_area_2d_mouse_entered():
	self.get_child(1).visible = true

func _on_area_2d_mouse_exited():
	self.get_child(1).visible = false
