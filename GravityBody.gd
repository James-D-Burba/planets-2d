tool
extends KinematicBody2D

export(Array, NodePath) var _affecting_bodies = []
var affecting_bodies = []
var contained_by = []
export var mass = 0
export var velocity = Vector2(0,0)
var g = 100
export var radius = 0
var handler = null
export(NodePath) var _trajectory = null
var trajectory = null
export var trace_trajectory = false
export var trajectory_color = Color(1,1,1,1)
export var trajectory_danger_color = Color(1,0,0,1)
export var fragile = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(_trajectory):
		trajectory = get_node(_trajectory)
		trajectory.default_color = trajectory_color
	for path in _affecting_bodies:
		get_node(path).add_to_array(affecting_bodies)
	
func _physics_process(delta):
	if not Engine.editor_hint:
		process_input()
		var collision = move_and_collide(velocity*delta)
		if collision:
			on_collide(collision)

func apply_gforce(force):
	var acceleration = force / mass
	velocity += acceleration
		
func on_collide(collision):
	pass

func add_to_array(array):
	array.append(self);
	contained_by.append(array)

func process_input():
	pass

func disappear():
	if trajectory:
		trajectory.queue_free()
	for array in contained_by:
		array.erase(self)
	queue_free()
