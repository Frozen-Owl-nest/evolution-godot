extends Panel

var is_paused: bool = false

func _input(event):
	if event is InputEventKey:
		if event.get_keycode_with_modifiers() == KEY_ESCAPE and event.pressed:
			is_paused = !is_paused
			get_tree().paused = is_paused
			if is_paused:
				self.show()
			else:
				self.hide()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_export_data_button_pressed():
	get_node("/root/Scene/CanvasLayer/ExportDataDialog").show()


func _on_export_data_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var time_series = get_node("/root/Scene/DataCollector").time_series
	for row in time_series:
		var line = ""
		for value in row:
			line+=str(value)+","
		line = line.substr(0, line.length() - 1)
		file.store_line(line)
	file.close()


func _on_timer_timeout():
	var path = "Experiment_" + str(Global.mutation_rate) + ".csv"
	var time_series = get_node("/root/Scene/DataCollector").export_data(path)
