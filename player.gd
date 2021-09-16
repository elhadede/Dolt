extends KinematicBody

var bulletpath = load("res://bullet.tscn")
var speed = 13
var ground_acceleration = 8
var air_acceleration = 2
var acceleration = ground_acceleration
var jump = 4.5
var gravity = 9.8
var stick_amount = 10
var mouse_sensitivity = 4 
var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
var grounded = true
var CorrectSound = preload("res://1.wav")


func _ready():
	$Head/Sprite3D/Viewport/ammo.text = "AMMO : " + str(glo.ammo)
func _input(event):
	if event.is_action_released("run"):
		$CollisionShape.shape.radius = 1
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
		$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90)
	direction = Vector3()
	direction.z = -Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
	direction.x = -Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right")
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if glo.ammo > 0:
			text(-1)
			$AudioStreamPlayer2D.stream = CorrectSound
			$AudioStreamPlayer2D.play()
			var bullet = bulletpath.instance()
			get_parent().add_child(bullet)
			bullet.global_transform.origin = $Head/Gun/emit.global_transform.origin
			bullet.rotation = $Head/Gun/emit.global_transform.basis.get_euler()
			bullet.velocity =  $Head/Gun/emit.global_transform.origin - $Head/Gun.global_transform.origin
func text(num):
	glo.ammo += num
	$Head/Sprite3D/Viewport/ammo.text = "AMMO : " + str(glo.ammo)
func normal():
	speed = 13
func _physics_process(delta):
	text(0)
	if Input.is_action_just_pressed("run") and is_on_floor():
		$CollisionShape.shape.radius = 0.1
		speed = 20
		$timer.connect("timeout", self, "normal")
		$timer.set_wait_time(0.7)
		$timer.start()
	if is_on_floor():
		gravity_vec = -get_floor_normal() * stick_amount
		acceleration = ground_acceleration
		grounded = true
	else:
		if grounded:
			gravity_vec = Vector3.ZERO
			grounded = false
		else:
			gravity_vec += Vector3.DOWN * gravity * delta
			acceleration = air_acceleration

	if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()):
		grounded = false
		gravity_vec = Vector3.UP * jump

	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	movement.z = velocity.z + gravity_vec.z
	movement.x = velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	move_and_slide(movement, Vector3.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if(collision.collider.name.begins_with("level") and not is_on_floor()):
			gravity = 3
			var is_l = get_slide_collision(0).normal.dot(global_transform.basis.x.normalized())
			var is_r = get_slide_collision(0).normal.dot(-(global_transform.basis.x).normalized())
			#print(str(is_l) +" | "+ str(is_r))
			if is_l > 0:
				rotation_degrees.z = -45
			elif is_r > 0:
				rotation_degrees.z = 45
			else:
				rotation_degrees.z = 0
		else:
			gravity = 9.8
			rotation_degrees.z = 0
