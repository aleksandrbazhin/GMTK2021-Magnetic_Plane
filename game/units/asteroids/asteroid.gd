extends KinematicBody2D

class_name base_asteroid

var hp = 1
export var speed = 140
export var direction = Vector2()
var go = false
var mass = 5
var attach_position
var is_pulled = true
var is_pullable = true
var end = false

var end_speed = randi()%100

signal destoyed()

func _ready():
	add_to_group("asteroids")
	add_to_group("enemies")
	

func _process(delta):
	if hp <= 0:
		queue_free()
	if go == true and is_in_group("attached") == false and end == false:
		move_and_slide(direction * speed)
		rotation_degrees += 0.2
	else:
		move_and_slide(direction * end_speed)



func _on_small_asteroid_body_entered(body):
	if body.is_in_group("friends") and not body.is_in_group("asteroids"):
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
	attach_position = new_attach_position
	is_pulled = false
	end_speed = 1
	add_to_group("attached")
	remove_from_group("enemies")
	add_to_group("friends")

func on_attached_destroyed():
	queue_free()
