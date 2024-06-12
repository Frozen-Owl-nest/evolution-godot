extends Node

class Neuron:
	var weights: Array
	var bias: float

	func _init(input_size: int):
		weights = []
		for i in range(input_size):
			weights.append(randf() * 2 - 1)
			bias = randf() * 2 - 1 

	func activate(inputs: Array) -> float:
		var sum = bias
		for i in range(inputs.size()):
			sum += inputs[i] * weights[i]
		return sigmoid(sum)

	func sigmoid(x: float) -> float:
		return 1.0 / (1.0 + exp(-x))
		
	func _to_string():
		return str(weights)

class Layer:
	var input_size: int
	var neurons: Array = []

	func _init(input_size: int, neuron_count: int):
		input_size = input_size
		for i in range(neuron_count):
			neurons.append(Neuron.new(input_size))

	func feed_forward(inputs: Array) -> float:
		return neurons[0].activate(inputs)
		
	func get_outputs(input: Array) -> Array:
		var outputs = []
		for neuron in neurons:
			outputs.append(neuron.activate(input))
		return outputs
		
	func _to_string():
		return str(neurons)

class NeuralNetwork:
	var input_size: int
	var layers: Array = []

	func _init(input_size: int, ouput_size: int, hiden_size: Array):
		input_size = input_size
		var layer_sizes = hiden_size
		layer_sizes.append(ouput_size)
		for neuron_count in layer_sizes:
			layers.append(Layer.new(input_size, neuron_count))
			input_size = neuron_count
	
	func get_output(input: Array) -> Array:
		var output
		for layer in layers:
			output = layer.get_outputs(input)
			input = output
		return output

	func feed_forward(inputs: Array) -> float:
		return layers[0].activate(inputs)
