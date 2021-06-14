extends KinematicBody2D

class_name Player

signal mass_changed

const MAX_SPEED := 400

var mass := Const.INITIAL_PLAYER_MASS
var speed := MAX_SPEED + Const.SCROLL_SPEED
var velocity = Vector2()
var pullable_count_in_the_field := 0

export var red_channel_hp_modulate: Curve
export var green_channel_hp_modulate: Curve
export var blue_channel_hp_modulate: Curve

onready var magnetic_field = $MagnetArea2D
onready var camera: Camera2D = $Camera2D


func _ready():
	add_to_group("friends")

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		shoot_to(get_global_mouse_position())
	if event is InputEventMouseMotion:
		rotation = position.angle_to_point(get_global_mouse_position()) - PI/2.0
		
		

func _process(_delta):
	display_info()

func display_info():
	$Label.text = "HP: %s\nMass: %d" % [str(GameState.player_hp), mass]


func shoot_to(target_position: Vector2):
	var shot = preload("res://game/shots/shot.tscn").instance()
	shot.direction = target_position - position
	shot.position = position
	get_parent().add_child(shot)
	shot.rotation = position.angle_to_point(target_position) - PI/2.0
	$AudioStreamPlayer.play()
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
	


func _physics_process(delta):
	if GameState.player_hp <= 0:
		queue_free()
		return
	var hp_level := float(GameState.player_hp) / float(Const.MAX_HP)
	$hp_circle.modulate = Color(red_channel_hp_modulate.interpolate(hp_level), 
			green_channel_hp_modulate.interpolate(hp_level), 
			blue_channel_hp_modulate.interpolate(hp_level), 1)
	get_input()
	var new_velocity := move_and_slide(velocity)
	get_tree().call_group("attached", "move_attached", position + new_velocity * delta, rotation)
	velocity = new_velocity

func destroy():
	get_tree().call_group("attached", "queue_free")
	queue_free()

func update_speed():
	var player_gained_mass = mass - Const.INITIAL_PLAYER_MASS
	speed = MAX_SPEED * Const.INITIAL_PLAYER_MASS \
		/ (Const.INITIAL_PLAYER_MASS + player_gained_mass * Const.PULL_PENALTY) + Const.SCROLL_SPEED
	

func attach_enemy(enemy: KinematicBody2D):
	add_collision_exception_with(enemy)
	for attached_enemy in get_tree().get_nodes_in_group("attached"):
		attached_enemy.add_collision_exception_with(enemy)
	
	var attach_point: Vector2 = (position - enemy.position).rotated(-rotation)
#	var attach_point: Vector2 = position - enemy.position
	mass += enemy.mass
	update_speed()
	enemy.is_pulled = false
	magnetic_field.remove_pulled(enemy)
	enemy.attach(attach_point)
	if not enemy.is_connected("destoyed", self, "on_attached_destroyed"):
# warning-ignore:return_value_discarded
		enemy.connect("destoyed", self, "on_attached_destroyed")
	emit_signal("mass_changed")
	var attach_line: Line2D = Line2D.new()
	attach_line.z_index = 0
	attach_line.points = [Vector2.ZERO, -attach_point]
	add_child(attach_line)
	enemy.attach_line_ref = weakref(attach_line)

func _on_Area2D_body_entered(body):
	if body.get("is_pulled") != null and body.is_pulled == true:
		body.z_index = 1
		attach_enemy(body)

func on_attached_destroyed(body):
	if is_instance_valid(body):
		mass -= body.mass
		update_speed()
	emit_signal("mass_changed")	
