extends KinematicBody
var smeg = preload("res://player.gd")
var gravity = 5
func _ready():
	pass
func _process(delta):
	var move = Vector3.ZERO
	if not is_on_floor():
		move = Vector3.DOWN * gravity * delta
	var collision = move_and_collide(move)
	if collision:
		print(collision.collider.name)
		smeg.text(10)
