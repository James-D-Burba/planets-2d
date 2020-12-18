extends Control

var paths = {}
var predictions = []
var max_points = 1000
var distance = 50

func _ready():
	pass # Replace with function body.

func _draw():
	for key in paths.keys():
		for point in paths[key]:
			draw_circle(point, 3, Color(0,0,0,1))
	for point in predictions:
		draw_circle(point, 3, Color(1,1,1,1))

func add_point(body, point):
	if not paths.has(body):
		paths[body] = [point]
	elif point.distance_to(paths[body][0]) < distance:
		return
	else:
		paths[body].push_front(point)
	if paths[body].size() > max_points:
		paths[body].resize(max_points)
	update()

func add_prediction(points):
	predictions = points
	update()
