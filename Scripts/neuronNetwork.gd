extends Node

class Neuron:
	var weights: Array
	var bias: float
	var activated: bool
	var activation: Callable

	static func create_a_random_neuron(input_size: int) -> Neuron:
		"""
		Creates a new neuron with random weights and bias.

		Args:
			input_size (int): The number of inputs for the neuron.
			
		Returns:
			Neuron: A neuron instance with randomized weights and bias.
		"""
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
		"""
		Calculates the output of the neuron given the inputs.

		Args:
			inputs (Array): The input values to the neuron.
			
		Returns:
			float: The activated output of the neuron after applying the activation function.
		"""
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
		"""
		Creates a new layer with randomly initialized neurons.

		Args:
			input_size (int): The number of inputs each neuron in the layer will receive.
			neuron_count (int): The number of neurons in the layer.
			
		Returns:
			Layer: A newly created layer containing the specified number of neurons.
		"""
		var neuron_list = []
		for i in range(neuron_count):
			neuron_list.append(Neuron.create_a_random_neuron(input_size))
		return Layer.new(neuron_list)

	func _init(neuron_list: Array):
		neurons = neuron_list

	func get_outputs(input: Array) -> Array:
		"""
		Calculates and returns the outputs of the neurons in the layer based on the provided input.

		For each neuron, the function calls its `activate` method to compute the output using the given input.

		Args:
			input (Array): The input values to be fed into the neurons for activation.

		Returns:
			Array: A list of outputs from each neuron in the layer.
		"""
		var outputs = []
		for neuron in neurons:
			outputs.append(neuron.activate(input))
		signals = outputs
		return outputs

class NeuralNetwork extends Node:
	var layers: Array = []

	static func create_a_random_network(input_size: int, ouput_size: int, hiden_size: Array):
		"""
		Creates a random neural network with a specified structure.

		The function generates a neural network with random weights and biases for each layer. The structure is determined
		by the given input size, output size, and the array of hidden layer sizes.

		Args:
			input_size (int): The number of input neurons in the network.
			output_size (int): The number of output neurons in the network.
			hidden_size (Array): An array containing the number of neurons for each hidden layer.

		Returns:
			NeuralNetwork: A new neural network object with random weights and biases in each layer.
		"""
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
		"""
		Computes the output of the neural network for a given input.

		The function iterates over all layers in the network, feeding the input through
		each layer sequentially. The output from one layer becomes the input for the next.

		Args:
			input (Array): The input array to be passed through the network.

		Returns:
			Array: The output of the network after processing the input through all layers.
		"""
		var output
		for layer in layers:
			output = layer.get_outputs(input)
			input = output
		return output

	func get_neurons():
		"""
		Retrieves all the neurons from all the layers in the network.

		The function iterates over each layer in the network, and then over each neuron
		within those layers, appending them to a list which is returned at the end.

		Returns:
			Array: A list containing all neurons from all layers in the network.
		"""
		var neurons = []
		for layer in layers:
			for neuron in layer.neurons:
				neurons.append(neuron)
		return neurons

	func mutate():
		"""
		Performs a mutation on the neural network by modifying the weights and biases of neurons.

		The mutation chance is determined by `Global.mutation_rate`, and the magnitude of mutation is controlled by `Global.mutation_scale`.

		Changes are applied to each neuron in the network, and the resulting mutated network is returned.

		Returns:
			NeuralNetwork: A new neural network with mutated weights and biases.
		"""
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
