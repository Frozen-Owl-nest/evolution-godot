extends RigidBody2D

var energy
var sprite
var collision_shape
	
func _ready():
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	set_random_energy()

func set_random_energy():
	energy = randi_range(40,100)
	sprite.scale = Vector2(0.07,0.07) * energy / 100
	collision_shape.scale = Vector2(1,1) * energy / 100
	
func subtract_energy(energy_value):
	energy -= energy_value
	if energy <= 20:
		self.queue_free()
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	sprite.scale = Vector2(0.07,0.07) * energy / 100
	collision_shape.scale = Vector2(1,1) * energy / 100
