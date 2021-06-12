extends KinematicBody2D

class_name BaseEnemy

const SHOT_DAMAGE = 0.5

signal destoyed()

export var mass := 10
export var hp := 4.0
var time = 0

var velocity = Vector2.ZERO
var is_pulled := false
#var is_attached := false
var attach_position := Vector2.ZERO

func _ready():
	add_to_group("enemies")

func destroy():
	emit_signal("destoyed", self)
	queue_free()
	
func _process(_delta):
	display_info()
	
func display_info():
	$Label.text = "HP: %s\nMass: %d" % [str(hp), mass]
	

func _physics_process(_delta):
	if hp <= 0:
		destroy()
	if is_pulled:
		var player_gained_mass = GameState.player_mass - Const.INITIAL_PLAYER_MASS
		var pull_speed: float = Const.BASE_PULL_SPEED * Const.INITIAL_PLAYER_MASS \
		/ (Const.INITIAL_PLAYER_MASS + player_gained_mass * Const.PULL_PENALTY)
		
		var to_player := GameState.player_position - position
		velocity += to_player * pull_speed
	velocity = move_and_slide(velocity)


func move_attached(player_velocity: Vector2):
	velocity = player_velocity
	position.x = clamp(position.x, Const.MIN_X, Const.MAX_X)


func attach(new_attach_position: Vector2):
	attach_position = new_attach_position
	is_pulled = false
	add_to_group("attached")
	remove_from_group("enemies")
	add_to_group("friends")
	

func update_magnet_pull(player: Player):
	if player.mass > mass:
		is_pulled = true
		$AttackTimer.stop()
		player.start_magnet()
	else:
		is_pulled = false
		$AttackTimer.start()


func _on_Area2D_body_entered(body): 
	if body.get_name() == "player" and not is_in_group("attached"):
		update_magnet_pull(body)


func _on_Area2D_body_exited(body):
	if body.get_name() == "player" and not is_in_group("attached"):
		body.stop_magnet()
		is_pulled = false
		$AttackTimer.stop()


func _on_AttackTimer_timeout():
	var shot: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
	shot.damage = SHOT_DAMAGE
	shot.direction = GameState.player_position - position
	shot.position = position
	get_parent().add_child(shot)


func shoot_with_player(target_position: Vector2):
	var shot: Shot = preload("res://game/shots/shot.tscn").instance()
	shot.damage = SHOT_DAMAGE
	shot.direction = target_position - position
	shot.position = position
	get_parent().add_child(shot)
