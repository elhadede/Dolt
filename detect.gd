extends Area


func _on_Area_body_entered(body):
	if body.get_name().begins_with("player"):
		print("hi")
		glo.ammo += 50
		queue_free()
