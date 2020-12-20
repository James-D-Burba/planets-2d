tool
extends Node

export(Array, NodePath) var _bodies = []

var bodies = []

export var g = 100
var path_steps = 500

func _ready():
	for path in _bodies:
		print(path)
		var body = get_node(path)
		add_body(body)

func add_body(body):
	body.handler = self
	body.add_to_array(bodies)
	
func apply_gravity():
	for body in bodies:
		for other_body in body.affecting_bodies:
			if other_body == self:
				continue
			var distance = body.global_transform.origin.distance_to(other_body.global_transform.origin)
			var direction = (other_body.global_transform.origin - body.global_transform.origin).normalized()
			var force = direction * ((g * other_body.mass * body.mass)/(pow(distance, 2)))
			body.apply_gforce(force)
			
func update_paths(delta):
	var current_step = {}
	for body in bodies:
		if body.trajectory:
			body.trajectory.clear_points()
			body.trajectory.default_color = body.trajectory_color
		current_step[body] = {'position': body.global_transform.origin, 'velocity': body.velocity}
	var step = 0
	var temp_step = current_step
	while step < path_steps:
		var next_step = {}
		for body in current_step.keys():
			var total_force = Vector2(0,0)
			for other_body in body.affecting_bodies:
				if other_body == self:
					continue
				var distance = current_step[body]['position'].distance_to(current_step[other_body]['position'])
				var direction = (current_step[other_body]['position'] - current_step[body]['position']).normalized()
				var force = direction * ((g * other_body.mass * body.mass)/(pow(distance, 2)))
				var acceleration = force / body.mass
				total_force += acceleration
			var new_velocity = current_step[body]['velocity'] + total_force
			# use the new velocity, since that's what gets passed to move_and_collide
			var new_position = current_step[body]['position'] + (new_velocity * delta)
			next_step[body] = {'position': new_position, 'velocity': new_velocity }
			if body.trajectory:
				body.trajectory.add_point(new_position)
		var bodies_to_delete = []
		for body in next_step.keys():
			for other_body in next_step.keys():
				if body == other_body or not body.fragile:
					if not Engine.editor_hint:
						continue
				if next_step[body]['position'].distance_to(next_step[other_body]['position']) < body.radius + other_body.radius:
					bodies_to_delete.append(body)
		for body in bodies_to_delete:
			#add the final point, if we haven't already added it
			if body.trajectory:
				body.trajectory.default_color = body.trajectory_danger_color
			next_step.erase(body)
		# todo: how does this work? Does it change the reference?
		# basically we want two dictionaries without having to allocate new memory that switch
		# is that what this does?
		# it wasn't - figure out how to do that
		current_step = next_step
		step = step + 1

func _physics_process(delta):
	update_paths(delta)
	if not Engine.editor_hint:
		apply_gravity()
