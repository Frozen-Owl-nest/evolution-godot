extends Node

class Neuron:
	var weights: Array
	var bias: float
	var activated: bool

	static func create_a_random_neuron(input_size: int) -> Neuron:
		var weight_list = []
		var bias = randf() * 2 - 1 
		
		for i in range(input_size):
			weight_list.append(randf() * 2 - 1)
		return Neuron.new(bias, weight_list)

	func _init(bias: float, weights: Array):
		self.bias = bias
		self.weights = weights

	func activate(inputs: Array) -> float:
		var sum = bias
		for i in range(inputs.size()):
			sum += inputs[i] * weights[i]
		return relu(sum)

	func relu(x: float) -> float:
		if x > 0:
			activated = true
			return x
		else:
			activated = false
			return 0.0

class Layer:
	var neurons: Array = []
	var signals: Array = []
	
	static func create_a_random_layer(input_size: int, neuron_count: int) -> Layer:
		var neuron_list = []
		for i in range(neuron_count):
			neuron_list.append(Neuron.create_a_random_neuron(input_size))
		return Layer.new(neuron_list)

	func _init(neuron_list: Array):
		neurons = neuron_list

	func get_outputs(input: Array) -> Array:
		var outputs = []
		for neuron in neurons:
			outputs.append(neuron.activate(input))
		signals = outputs
		return outputs

class NeuralNetwork extends Node:
	static var mutation_rate: float = 0.3
	
	var layers: Array = []

	static func create_a_random_network(input_size: int, ouput_size: int, hiden_size: Array):
		var layer_sizes = hiden_size
		var layer_list = []
		
		layer_sizes.append(ouput_size)
		for neuron_count in layer_sizes:
			layer_list.append(Layer.create_a_random_layer(input_size, neuron_count))
			input_size = neuron_count
		return NeuralNetwork.new(layer_list)
		
	func _init(layer_list : Array):
		layers = layer_list
	
	func get_output(input: Array) -> Array:
		var output
		for layer in layers:
			output = layer.get_outputs(input)
			input = output
		return output

	func get_neurons():
		var neurons = []
		for layer in layers:
			for neuron in layer.neurons:
				neurons.append(neuron)
		return neurons

	func get_colour():
		var neurons = []
		for layer in layers:
			for neuron in layer.neurons:
				neurons.append(neuron)

	static func mutate1(network):
		var new_layers = []
		for layer in network.layers:
			var new_neurons = []
			for neuron in layer.neurons:
				var new_weights = []
				var bias = neuron.bias
				if randf() < NeuralNetwork.mutation_rate:
					bias += (randf() * 2 - 1)/2/5
				for weight in neuron.weights:
					var new_weight = weight
					if randf() < NeuralNetwork.mutation_rate:
						new_weight += (randf() * 2 - 1)/2/5 
					new_weights.append(new_weight)
				new_neurons.append(Neuron.new(bias, new_weights))
			new_layers.append(Layer.new(new_neurons))
		return NeuralNetwork.new(new_layers)

func mutate2(network_1, network_2):
	var new_layers = []
	for layers in zip(network_1.layers, network_2.layers):
		var new_neurons = []
		for neurons in zip(layers[0].neurons, layers[1].neurons):
			var new_weights = []
			var bias = (neurons[0].bias + neurons[1].bias)/2
			for weights in zip(neurons[0].weights, neurons[1].weights):
				new_weights.append((weights[0] + weights[1])/2)
			new_neurons.append(Neuron.new(bias, new_weights))
		new_layers.append(Layer.new(new_neurons))
	return NeuralNetwork.new(new_layers)
	
func zip(list1, list2):
	var zipped = []
	for i in range(min(len(list1), len(list2))):
		zipped.append([list1[i], list2[i]])
	return zipped
