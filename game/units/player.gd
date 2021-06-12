extends KinematicBody2D


var hp = 3
var mass = 10
var speed = 400
var velocity = Vector2()

func _ready():
	add_to_group("friends")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var shot = preload("res://game/units/shots/shot.tscn").instance()
		var click_position := get_global_mouse_position()
		shot.direction = click_position - position
		shot.position = position
		get_parent().add_child(shot)
		shot.look_at(click_position)


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
	velocity = velocity.normalized() * (speed  - mass / 100 * 20)
	position.x = clamp(position.x, 0, 200)

func _physics_process(_delta):
	if hp == 3:
		$hp_circle.modulate = Color(0.22,1,0.44,1)
	elif hp == 2:
		$hp_circle.modulate = Color(0.87,0.82,0.36,1)
	elif hp == 1:
		$hp_circle.modulate = Color(0.89,0.34,0.31,1)
	elif hp <= 0:
		queue_free()
	get_input()
	get_tree().call_group("attached", "move", velocity)
	velocity = move_and_slide(velocity)
