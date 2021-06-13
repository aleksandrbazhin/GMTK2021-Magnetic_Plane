extends KinematicBody2D

class_name base_asteroid

var hp = 1
export var speed = 140
export var direction = Vector2()
var go = false

func _ready():
	add_to_group("enemies")

func _process(delta):
	if hp <= 0:
		queue_free()
	if go == true:
		position += direction * speed * delta
		rotation_degrees += 0.2


func _on_small_asteroid_body_entered(body):
	if body.is_in_group("friends"):
		body.hp -= 2
		queue_free()




func _on_VisibilityNotifier2D_screen_exited():
	if go == true:
		queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	go = true
