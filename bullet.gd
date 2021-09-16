extends KinematicBody

var speed = 20
var velocity = Vector3(1,0,0)
func _process(delta):
	var collision = move_and_collide(velocity.normalized() * speed * delta)
	if collision:
		var collider = collision.collider
		if collider.name.begins_with("enemy"):
			collider.queue_free()
		queue_free()
