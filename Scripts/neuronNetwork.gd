extends Node

class Neuron:
	var weights: Array
	var bias: float
	var activated: bool
	var activation: Callable

	static func create_a_random_neuron(input_size: int) -> Neuron:
		var weight_list = []
		var bias = randf() * 2 - 1 
		
		for i in range(input_size):
			weight_list.append(randf() * 2 - 1)
		return Neuron.new(bias, weight_list)

	func _init(bias: float, weights: Array):
		self.bias = bias
		self.weights = weights
		self.activation = Global.get_activation_method()

	func activate(inputs: Array) -> float:
		var sum = bias
		for i in range(inputs.size()):
			sum += inputs[i] * weights[i]
		var ret = self.activation.call(sum)
		activated = ret >= 0.5
		return ret

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
	var layers: Array = []

	static func create_a_random_network(input_size: int, ouput_size: int, hiden_size: Array):
		var layer_sizes = hiden_size.duplicate()
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

	func mutate():
		var mutation_chance = float(Global.mutation_rate) / 100
		var mutation_scale = float(Global.mutation_scale) / 100

		var new_layers = []
		for layer in self.layers:
			var new_neurons = []
			for neuron in layer.neurons:
				var new_bias = neuron.bias
				if randf() < mutation_chance:
					new_bias += (randf() * 2 - 1) * mutation_scale
				var new_weights = []
				for weight in neuron.weights:
					var new_weight = weight
					if randf() < mutation_chance:
						new_weight += (randf() * 2 - 1) * mutation_scale
					new_weights.append(new_weight)

				new_neurons.append(Neuron.new(new_bias, new_weights))
			new_layers.append(Layer.new(new_neurons))

		return NeuralNetwork.new(new_layers)

static func mutate2(network_1, network_2):
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
	
static func zip(list1, list2):
	var zipped = []
	for i in range(min(len(list1), len(list2))):
		zipped.append([list1[i], list2[i]])
	return zipped
