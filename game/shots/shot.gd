extends Area2D

class_name Shot

var direction = Vector2(1, 1)

var speed = 600

var damage = 1


func _process(delta):
	
	direction = direction.normalized() * speed
	position += direction * delta


func _on_shot_body_entered(body):
	if body.is_in_group("enemies"):
		speed = 0.0
		body.hp -= damage
		play_shot_sound()
		$AnimatedSprite.play("explode")
		if not $AnimatedSprite.is_connected("animation_finished", self, "queue_free"):
# warning-ignore:return_value_discarded
			$AnimatedSprite.connect("animation_finished", self, "queue_free")


func play_shot_sound():
	if !$ShotSound.is_playing():
		$ShotSound.play()
