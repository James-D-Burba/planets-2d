extends Node2D

var planets = []

var show_path = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for body in [$Planet1, $Planet2]:
		body.add_to_list(planets);
		
	$Player.set_target($Planet1)

	$Planet1.affecting_bodies = []
	
	$Planet2.affecting_bodies = planets
	$Player.affecting_bodies = planets
	$Player.trajectory = $Trajectory
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
