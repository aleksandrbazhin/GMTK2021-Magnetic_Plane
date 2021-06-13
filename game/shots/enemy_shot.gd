extends Area2D

class_name EnemyShot

var direction = Vector2(1, 1)

var speed = 400

var damage = 1
var is_friendly := false


func _process(delta):
	direction = direction.normalized() * speed
	position += direction * delta


func _on_shot_body_entered(body):
	if (body.is_in_group("friends") and not is_friendly) or (body.is_in_group("enemies") and is_friendly):
		speed = 0.0
		body.hp -= damage
		$AnimatedSprite.play("explode")
		if not $AnimatedSprite.is_connected("animation_finished", self, "queue_free"):
# warning-ignore:return_value_discarded
			$AnimatedSprite.connect("animation_finished", self, "queue_free")
		

