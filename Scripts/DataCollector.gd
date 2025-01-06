extends Node

var agent_list = []
var food_list = []

var time_series = []

func _on_timer_timeout():
	time_series.append([len(agent_list),len(food_list)])
	
func export_data(path: String):
	"""
	Exports time series data to a CSV file at the specified path.
	
	Args:
		path (String): The file path where the data should be exported.
	"""
	var file = FileAccess.open(path, FileAccess.WRITE)

	# Iterate over each row in the time series data.
	for row in time_series:
		var line = ""
		# Concatenate values from the row into a comma-separated string.
		for value in row:
			line += str(value) + ","
		# Remove the trailing comma from the line.
		line = line.substr(0, line.length() - 1)
		# Write the line to the file.
		file.store_line(line)

	file.close()
