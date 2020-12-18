extends KinematicBody2D

var affecting_bodies = []
var contained_by = []
export var mass = 0
export var velocity = Vector2(0,0)
var g = 100
var trajectory = null
export var radius = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	get_trajectory(delta)
	update_gravity()
	process_input()
	var collision = move_and_collide(velocity*delta)
	if collision:
		on_collide(collision)

func update_gravity():
	var gravity_force = Vector2(0, 0)
	for other_body in affecting_bodies:
		if other_body == self:
				continue
		var distance = global_transform.origin.distance_to(other_body.global_transform.origin)
		var direction = (other_body.global_transform.origin - global_transform.origin).normalized()
		var force = direction * ((g * other_body.mass * mass)/(pow(distance, 2)))
		var acceleration = force / mass
		gravity_force += acceleration
	velocity += gravity_force

func get_trajectory(delta):
	if not trajectory:
		return
	trajectory.clear_points()
	trajectory.default_color = Color(1,1,1,1)
	var projected_positions = {}
	for body in affecting_bodies:
		projected_positions[body] = {'position': body.global_transform.origin, 'velocity': body.velocity}
	projected_positions[self] = {'position': global_transform.origin, 'velocity': velocity}
	var step = 0
	while step < 1000:
		var new_projected_positions = {}
		for body in projected_positions.keys():
			var gravity_force = Vector2(0,0)
			for other_body in body.affecting_bodies:
				if other_body == body:
					continue
				var distance = projected_positions[body]['position'].distance_to(projected_positions[other_body]['position'])
				var direction = (projected_positions[other_body]['position'] - projected_positions[body]['position']).normalized()
				var force = direction * ((g * other_body.mass * body.mass)/(pow(distance, 2)))
				var acceleration = force / body.mass
				gravity_force += acceleration
			var new_velocity = projected_positions[body]['velocity'] + gravity_force
			# use the new velocity, since that's what gets passed to move_and_collide
			var new_position = projected_positions[body]['position'] + (new_velocity * delta)
			new_projected_positions[body] = {'position': new_position, 'velocity': new_velocity }
			if body == self:
				# check if we will be colliding with any other bodies - if so then stop
				# and make the color of the line red or something4
				trajectory.add_point(new_position)
		# check if we will be colliding with any other bodies - if so then stop
		# and make the color of the line red or something
		var new_position = new_projected_positions[self]['position']
		for other_body in new_projected_positions.keys():
			if other_body == self:
				continue
			if(new_position).distance_to(new_projected_positions[other_body]['position']) < 64:
				trajectory.default_color = Color(1,0,0,1)
				step = 1000
		projected_positions = new_projected_positions	
		step = step + 1
		
func on_collide(collision):
	pass

func add_to_list(list):
	list.append(self);
	contained_by.append(list)

func process_input():
	pass

func disappear():
	for list in contained_by:
		list.erase(self)
		
	pass
