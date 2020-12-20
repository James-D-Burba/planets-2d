tool
extends "res://GravityBody.gd"

var Bullet = preload("res://Bullet.tscn")

var acceleration = 10
var thrust = Vector2(0,0)
export(NodePath) var _target = null
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if _target:
		target = get_node(_target)
	pass


func process_input():
	$Cursor.global_transform.origin = get_global_mouse_position()
	look_at($Cursor.global_transform.origin)
	if target:
		$Pointer.look_at(target.global_transform.origin)
	if Input.is_action_pressed("thrust_forward"):
		velocity += Vector2(1,0).rotated(rotation) * acceleration
		$Particles2D.emitting = true
	else: 
		$Particles2D.emitting = false
	if Input.is_action_pressed("shoot"):
		var bullet = Bullet.instance()
		bullet.global_transform.origin = $Cannon.global_transform.origin
		bullet.transform.rotated(rotation)
		get_tree().get_root().add_child(bullet)
		bullet.velocity = Vector2(1,0).rotated(rotation) * 300
		
func on_collide(collision):
	disappear()

func set_target(_target):
	target = _target
