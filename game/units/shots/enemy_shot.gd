extends Area2D

class_name EnemyShot

var direction = Vector2(1, 1)

var speed = 400

var damage = 1


func _process(delta):
	direction = direction.normalized() * speed
	position += direction * delta



func _on_shot_body_entered(body):
	if body.is_in_group("friends"):
		body.hp -= damage
		queue_free()
