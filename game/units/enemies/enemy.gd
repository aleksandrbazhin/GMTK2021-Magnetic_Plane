extends KinematicBody2D

class_name BaseEnemy

const SHOT_DAMAGE = 0.5


export var mass = 50
export var hp = 4
var time = 0


var velocity = Vector2.ZERO
var attack_now = false

var is_pulled := false
var is_attached := false

func _ready():
	add_to_group("enemies")

func destroy():
	queue_free()

func _physics_process(_delta):
	if hp <= 0:
		destroy()
	if is_pulled:
		var pull_speed := 1.0
		var to_player := GameState.player_position - position
		velocity += to_player * pull_speed
	velocity = move_and_slide(velocity)


func move_attached(velocity_arg):
	velocity = velocity_arg
	position.x = clamp(position.x, Const.MIN_X, Const.MAX_X)


func _on_attack_timer_timeout():
	attack_now = false
	if not is_in_group("friends"):
		var shot: Shot = preload("res://game/units/shots/enemy_shot.tscn").instance()
		shot.damage = 0.5
		shot.direction = GameState.player_position - position
		shot.position = position
		get_parent().add_child(shot)
	else:
		var shot: EnemyShot = preload("res://game/units/shots/shot.tscn").instance()
		shot.damage = 0.5
		shot.direction = GameState.player_position - position
		shot.position = position
		get_parent().add_child(shot)


func attach():
	is_pulled = false
	add_to_group("attached")
	remove_from_group("enemies")
	add_to_group("friends")


func _on_Area2D_body_entered(body): 
	if body.get_name() == "player" and not is_in_group("attached"):
		body.start_magnet()
		if body.mass > mass:
			is_pulled = true
			$AttackTimer.stop()
		else:
			is_pulled = false
			$AttackTimer.start()


func _on_Area2D_body_exited(body):
	if body.get_name() == "player" and not is_in_group("attached"):
		body.stop_magnet()
		is_pulled = false
		$AttackTimer.stop()


func _on_AttackTimer_timeout():
	var shot: EnemyShot = preload("res://game/units/shots/enemy_shot.tscn").instance()
	shot.damage = SHOT_DAMAGE
	shot.direction = GameState.player_position - position
	shot.position = position
	get_parent().add_child(shot)
