extends Control

var regex

func _ready():
	regex = RegEx.new()
	regex.compile("^[1-9][0-9]*$")

func _on_new_simulation_button_pressed():
	get_node("WorldSettingsPanel").show()
	get_node("VBoxContainer").hide()

func _on_cancel_button_pressed():
	get_node("WorldSettingsPanel").hide()
	get_node("VBoxContainer").show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_continue_pressed():
	Global.initial_number_of_agents= int(get_node("WorldSettingsPanel/GridContainer/InitialNumberOfAgentsInput").text)
	Global.initial_number_of_food  = int(get_node("WorldSettingsPanel/GridContainer/InitialNumberOfFoodInput").text)
	Global.spawn_interval = int(get_node("WorldSettingsPanel/GridContainer/FoodSpawnIntervalInput").text)
	Global.spawn_radius = int(get_node("WorldSettingsPanel/GridContainer/FoodSpawnIntervalInput").text)
	
	print(Global.initial_number_of_agents)
	print(Global.initial_number_of_food)
	print(Global.spawn_interval)
	print(Global.spawn_radius)
	
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
	if !regex.search(text_field.text):
		text_field.text = str(Global.initial_number_of_agents)

func _on_initial_number_of_food_input_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/InitialNumberOfFoodInput")
	if !regex.search(text_field.text):
		text_field.text = str(Global.initial_number_of_food)

func _on_food_spawn_interval_input_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/FoodSpawnIntervalInput")
	if !regex.search(text_field.text):
		text_field.text = str(Global.spawn_interval)

func _on_spawn_radius_input_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/SpawnRadiusInput")
	if !regex.search(text_field.text):
		text_field.text = str(Global.spawn_radius)

func _on_number_of_spawned_food_text_changed():
	var text_field = get_node("WorldSettingsPanel/GridContainer/NumberOfSpawnedFood")
	if !regex.search(text_field.text):
		text_field.text = str(Global.spawned_food)
