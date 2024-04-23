extends Node

@onready var repceptor_1 = $Receptor_1
@onready var repceptor_2 = $Receptor_2
@onready var repceptor_3 = $Receptor_3

var speed = 1
var rot = randf()
var noise1 = FastNoiseLite.new()
var noise2 = FastNoiseLite.new()
var time = randf()
var energy = 300

func _ready():
	noise1.seed = randi()
	noise2.seed = randi()

func _process(delta):
	speed = noise1.get_noise_1d(time)
	var velocity = Vector2.UP.rotated(self.rotation) * abs(speed) * 10
	energy -= abs(speed)
	self.position += velocity
	rot = noise2.get_noise_1d(time) * 2 * PI
	time += delta
	self.rotation = rot
	if energy <= 0:
		self.queue_free()
