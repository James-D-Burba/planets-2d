extends "res://GravityBody.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	mass = 1
	pass # Replace with function body.

func on_collide(collision):
	disappear()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass