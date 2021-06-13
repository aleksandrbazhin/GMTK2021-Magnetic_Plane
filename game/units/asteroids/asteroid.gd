extends KinematicBody2D

class_name base_asteroid

var hp = 1
export var speed = 140
export var direction = Vector2()
var go = false
var mass = 5
var attach_position

var is_pulled = false

func _ready():
	add_to_group("enemies")

func _process(delta):
	if hp <= 0:
		queue_free()
	if go == true and is_in_group("attached") == false and is_pulled == false:
		move_and_slide(direction * speed)
		rotation_degrees += 0.2
	else:
		move_and_slide(direction)



func _on_small_asteroid_body_entered(body):
	if body.is_in_group("friends"):
		body.hp -= 2
		queue_free()





func _on_VisibilityNotifier2D_screen_entered():
	go = true

func destroy():
	emit_signal("destoyed", self)
	$AnimatedSprite.play("explode")
	queue_free()
	

func move_attached(player_velocity: Vector2):
	direction = player_velocity
	#position.x = clamp(position.x, Const.MIN_X, Const.MAX_X)

func update_behavior():
	pass

func shoot_with_player(_attack):
	pass

func attach(new_attach_position: Vector2):
	print("attached")
	attach_position = new_attach_position
	is_pulled = false
	add_to_group("attached")
	remove_from_group("enemies")
	add_to_group("friends")
