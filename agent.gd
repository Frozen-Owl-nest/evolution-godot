extends Node

@onready var repceptor_1 = $Receptor_1
@onready var repceptor_2 = $Receptor_2
@onready var repceptor_3 = $Receptor_3

var Network = preload("res://neuronNetwork.gd").NeuralNetwork

var speed = 1
var rot = randf()
var noise1 = FastNoiseLite.new()
var noise2 = FastNoiseLite.new()
var time = randf()
var energy = 300
var network = Network.new(4, 2, [2,2])

func _ready():
	noise1.seed = randi()
	noise2.seed = randi()

func _process(delta):
	var output = network.get_output([int(repceptor_1.is_colliding()), int(repceptor_2.is_colliding()), int(repceptor_3.is_colliding()), energy/1000])
	speed = output[0]
	print(network.get_output([time, energy]))
	var velocity = Vector2.UP.rotated(self.rotation) * abs(speed) * 10
	energy -= abs(speed)
	self.position += velocity
	rot = output[1] * 2 * PI
	time += delta
	self.rotation = rot
	if energy <= 0:
		self.queue_free()
