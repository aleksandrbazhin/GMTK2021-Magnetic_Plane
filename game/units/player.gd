extends KinematicBody2D

class_name Player

signal mass_changed

const MAX_SPEED := 400

var hp := 10.0
var mass := Const.INITIAL_PLAYER_MASS
var speed := MAX_SPEED
var velocity = Vector2()
var pullable_count_in_the_field := 0

onready var magnetic_field = $MagnetArea2D



func _ready():
	add_to_group("friends")

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		shoot_to(get_global_mouse_position())

func _process(_delta):
	display_info()

func display_info():
	$Label.text = "HP: %s\nMass: %d" % [str(hp), mass]


func shoot_to(target_position: Vector2):
	var shot = preload("res://game/shots/shot.tscn").instance()
	shot.direction = target_position - position
	shot.position = position
	get_parent().add_child(shot)
	shot.look_at(target_position)
	shot.get_node("AnimatedSprite").rotation_degrees = -90
	for attached_enemy in get_tree().get_nodes_in_group("attached"):
		attached_enemy.shoot_with_player(target_position)


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * (speed - mass / 100.0 * 20.0)
	position.x = clamp(position.x, Const.MIN_X, Const.MAX_X)


func _physics_process(_delta):
	if is_equal_approx(hp, 10):
		$hp_circle.modulate = Color(0.22,1,0.44,1)
	elif is_equal_approx(hp, 6):
		$hp_circle.modulate = Color(0.87,0.82,0.36,1)
	elif is_equal_approx(hp, 4):
		$hp_circle.modulate = Color(0.89,0.34,0.31,1)
	elif hp <= 0:
		queue_free()
	get_input()
	get_tree().call_group("attached", "move_attached", velocity)
	if velocity == Vector2(0,0):
		$AnimatedSprite.play("stay")
	else:
		$AnimatedSprite.play("default")
	velocity = move_and_slide(velocity)
	

func destroy():
	get_tree().call_group("attached", "queue_free")
	queue_free()

func attach_enemy(enemy):
	mass += enemy.mass
	enemy.is_pulled = false
	magnetic_field.remove_pulled(enemy)
	enemy.attach(position - enemy.position)
	enemy.connect("destoyed", self, "on_attached_destroyed")
	emit_signal("mass_changed")

func _on_Area2D_body_entered(body):
	if body.get("is_pulled") != null and body.is_pulled == true:
		print(body)
		attach_enemy(body)

func on_attached_destroyed(body):
	if is_instance_valid(body):
		mass -= body.mass
	emit_signal("mass_changed")	
