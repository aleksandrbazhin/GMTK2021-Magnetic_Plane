extends Area2D

class_name Shot

var direction = Vector2(1, 1)

var speed = 600

var damage = 1


func _process(delta):
	direction = direction.normalized() * speed
	position += direction * delta


func _on_shot_area_entered(area):
	if area.is_in_group("enemies"):
		area.health -= damage
		queue_free()


func _on_shot_body_entered(body):
	if body.is_in_group("enemies"):
		body.hp -= damage
		queue_free()
