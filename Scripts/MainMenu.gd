extends Control

var is_number_regex
var is_structure_regex

func _ready():
	is_number_regex = RegEx.new()
	is_structure_regex = RegEx.new()
	
	is_number_regex.compile("^[1-9][0-9]*$")
	is_structure_regex.compile(r"^(\d+([-,\s]\d+)*)$")
	
	Global.load_from_json("res://Configs/default.json")
	load_settings()


func _on_new_simulation_button_pressed():
	Global.load_from_json("default.json")
	
	get_node("WorldSettingsPanel").show()
	get_node("OpenScreen").hide()


func _on_cancel_button_pressed():
	get_node("WorldSettingsPanel").hide()
	get_node("GeneralSettingsPanel").hide()
	get_node("OpenScreen").show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_continue_pressed():
	get_node("WorldSettingsPanel").hide()
	get_node("AgentSettingsPanel").show()


func _on_back_button_pressed():
	get_node("WorldSettingsPanel").show()
	get_node("AgentSettingsPanel").hide()


func _on_confirm_pressed():
	Global.spawn_interval = 5
	Global.spawn_radius = 1000
	get_tree().change_scene_to_file("res://Scenes/scene.tscn")


func _on_initial_number_of_agents_input_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/InitialNumberOfAgentsInput")
	if !is_number_regex.search(text_field.text):
		text_field.text = str(Global.initial_number_of_agents)
	else:
		Global.initial_number_of_agents = int(text_field.text)


func _on_initial_number_of_food_input_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/InitialNumberOfFoodInput")
	if !is_number_regex.search(text_field.text):
		text_field.text = str(Global.initial_number_of_food)
	else:
		Global.initial_number_of_food = int(text_field.text)


func _on_food_spawn_interval_input_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/FoodSpawnIntervalInput")
	if !is_number_regex.search(text_field.text):
		text_field.text = str(Global.spawn_interval)
	else:
		Global.spawn_interval = int(text_field.text)


func _on_spawn_radius_input_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/SpawnRadiusInput")
	if !is_number_regex.search(text_field.text):
		text_field.text = str(Global.spawn_radius)
	else:
		Global.spawn_radius = int(text_field.text)


func _on_number_of_spawned_food_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/NumberOfSpawnedFood")
	if !is_number_regex.search(text_field.text):
		text_field.text = str(Global.spawned_food)
	else:
		Global.spawned_food = int(text_field.text)


func _on_activation_function_input_item_selected(index):
	Global.activation_method_index = index

func _on_number_of_receptors_input_text_changed():
	var text_field = get_node("AgentSettingsPanel/MainGridContainer/NumberOfReceptorsInput")
	if !is_number_regex.search(text_field.text) or int(text_field.text) not in range(1,8):
		text_field.text = str(Global.number_of_receptors)
	else:
		Global.number_of_receptors = int(text_field.text)

func _on_mutation_rate_text_changed():
	var text_field = get_node("AgentSettingsPanel/MainGridContainer/MutationRate")
	if !is_number_regex.search(text_field.text) or int(text_field.text) not in range(1,101):
		text_field.text = str(Global.mutation_rate)
	else:
		Global.mutation_rate = int(text_field.text)


func _on_mutation_scale_text_changed():
	var text_field = get_node("AgentSettingsPanel/MainGridContainer/MutationScale")
	if !is_number_regex.search(text_field.text) or int(text_field.text) not in range(1,101):
		text_field.scale = str(Global.mutation_scale)
	else:
		Global.mutation_rate = int(text_field.text)

func _on_number_of_layers_input_text_changed():
	var text_field = get_node("AgentSettingsPanel/MainGridContainer/NumberOfLayersInput")
	if !is_number_regex.search(text_field.text) or int(text_field.text) not in range(1,6):
		text_field.text = str(len(Global.network_structure))
	else:
		Global.network_structure.resize(int(text_field.text))
		Global.network_structure.fill(3)
	var container = get_node("AgentSettingsPanel/LayersGridContainer")
	for control in container.get_children():
		control.queue_free()

	for i in range(int(text_field.text)):
		var label = Label.new()
		var line_edit = LineEdit.new()
		
		label.text = "\t Layer " + str(i + 1)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		container.add_child(label)
		container.add_child(line_edit)
		line_edit.text = str(Global.network_structure[i])
		line_edit.connect("text_changed", _on_layer_input_text_changed)
		line_edit.custom_minimum_size.x = 300


func _on_layer_input_text_changed(input):
	var container = get_node("AgentSettingsPanel/LayersGridContainer")
	if !is_number_regex.search(input):
		for i in range(container.get_child_count()):
			if i % 2 == 1:
				container.get_children()[i].text = str(Global.network_structure[(i-1)/2])
	else:
		for i in range(container.get_child_count()):
			if i % 2 == 1:
				Global.network_structure[(i-1)/2] = int(container.get_children()[i].text)


func load_settings():
	get_node("WorldSettingsPanel/GridContainer/InitialNumberOfAgentsInput").text = str(Global.initial_number_of_agents)
	get_node("WorldSettingsPanel/GridContainer/InitialNumberOfFoodInput").text = str(Global.initial_number_of_food)
	get_node("WorldSettingsPanel/GridContainer/FoodSpawnIntervalInput").text = str(Global.spawn_interval)
	get_node("WorldSettingsPanel/GridContainer/SpawnRadiusInput").text = str(Global.spawn_radius)
	get_node("WorldSettingsPanel/GridContainer/NumberOfSpawnedFood").text = str(Global.spawned_food)
	get_node("AgentSettingsPanel/MainGridContainer/ActivationFunctionInput").selected = Global.activation_method_index
	get_node("AgentSettingsPanel/MainGridContainer/NumberOfLayersInput").text = str(len(Global.network_structure))
	get_node("AgentSettingsPanel/MainGridContainer/NumberOfReceptorsInput").text = str(Global.number_of_receptors)
	get_node("AgentSettingsPanel/MainGridContainer/MutationRate").text = str(Global.mutation_rate)
	get_node("AgentSettingsPanel/MainGridContainer/MutationScale").text = str(Global.mutation_scale)
	
	var layer_container = get_node("AgentSettingsPanel/LayersGridContainer")
	for i in range(len(Global.network_structure)):
		var label = Label.new()
		var line_edit = LineEdit.new()

		label.text = "\t Layer " + str(i + 1)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		layer_container.add_child(label)
		layer_container.add_child(line_edit)
		line_edit.text = str(Global.network_structure[i])
		line_edit.connect("text_changed", _on_layer_input_text_changed)
		line_edit.custom_minimum_size.x = 300


func _on_save_pressed():
	get_node("SaveSettingsDialog").show()


func _on_load_pressed():
	get_node("LoadSettingsDialog").show()


func _on_save_settings_dialog_file_selected(path):
	Global.save_as_json(path)


func _on_load_settings_dialog_file_selected(path):
	Global.load_from_json(path)
	load_settings()


func _on_apply_button_pressed():
	var screen_mode = get_node("GeneralSettingsPanel/GridContainer/ScreenModeInput").text
	var resolution = get_node("GeneralSettingsPanel/GridContainer/ResolutionInput").text.split("x")
	var fps_limit = get_node("GeneralSettingsPanel/GridContainer/FPSLimitInput").text
	
	if screen_mode == "Fullscreen":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	get_window().size = Vector2(int(resolution[0]), int(resolution[1]))
	if fps_limit == "Off":
		Engine.max_fps = 1000
	else:
		Engine.max_fps = int(fps_limit)


func _on_settings_button_pressed():
	get_node("GeneralSettingsPanel").show()
	get_node("OpenScreen").hide()


func _on_screen_mode_input_item_selected(index):
	get_node("GeneralSettingsPanel/GridContainer/ResolutionInput").disabled = !index
