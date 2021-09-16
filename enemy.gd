extends KinematicBody


var movement = Vector3()
var gravity_vec = Vector3()
var speed = 10
var gravity = 4
func _physics_process(delta):
	var player = get_parent().get_node("player")
	var vec2player = (player.translation -  translation).normalized()
	move_and_collide(vec2player * speed * delta)
	#follow(delta)
	#var from = camera.project_ray_origin(transform.origin)
	#var to = from + camera.project_ray_normal((player.transform.origin) * 2000
	#var space_state = get_world().direct_space_state
	#var result = space_state.intersect_ray(from, to,[self], collision_mask)
	#if(result):
	#	if result.collider.name.begins_with("player"):
#func follow(delta):
	#if not is_on_floor():
	#	gravity_vec += Vector3.DOWN * gravity * delta
	#var vec2player = (player.translation -  translation).normalized()
	#movement.x = vec2player.x
	#movement.y = gravity_vec.y
	#movement.z = vec2player.z
	#move_and_collide(movement * speed * delta)
