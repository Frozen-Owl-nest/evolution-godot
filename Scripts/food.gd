extends RigidBody2D

var energy
var sprite
var collision_shape
	
func _ready():
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	set_random_energy()

func set_random_energy():
	"""
	Sets a random energy level between 40 and 100. Adjusts the scale of the 
	sprite and collision shape based on the new energy value.
	"""
	energy = randi_range(40,100)
	sprite.scale = Vector2(0.07,0.07) * energy / 100
	collision_shape.scale = Vector2(1,1) * energy / 100
	
func subtract_energy(energy_value):
	"""
	Decreases the energy by the specified amount. If energy falls to 20 or below,
	the object is removed. Scales the sprite and collision shape relative to the 
	current energy level.

	Args:
		energy_value (float): The amount of energy to subtract from the current energy.
	"""
	energy -= energy_value
	if energy <= 20:
		self.queue_free()
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	sprite.scale = Vector2(0.07,0.07) * energy / 100
	collision_shape.scale = Vector2(1,1) * energy / 100
