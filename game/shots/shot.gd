extends Area2D

class_name Shot

var direction = Vector2(1, 1)
var speed = 600
var damage = 1


var target = null

func _ready():
	$AnimatedSprite.play("default")

func _process(delta):
	if target == null:
		direction = direction.normalized() * speed
		position += direction * delta


func _on_shot_area_entered(area):
	if area.is_in_group("enemies"):
		if area.hp != null:
			area.hp -= damage
			$AnimatedSprite.play("explode")



func _on_shot_body_entered(body):
	if body.is_in_group("enemies"):
		target = body
		$AnimatedSprite.play("explode")


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 3 and $AnimatedSprite.animation == "default":
		$AnimatedSprite.playing = false


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explode":
		if is_instance_valid(target) and target != null:
			target.hp -= damage
		queue_free()
