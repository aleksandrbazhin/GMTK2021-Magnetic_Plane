extends KinematicBody2D

class_name BaseEnemy

const SHOT_DAMAGE = 0.5
const ROTATION_SPEED = 5.0

signal destoyed()

export var mass := 10
export var hp := 4.0
var time = 0

var is_pullable := true
var is_pulled := false
var velocity := Vector2(0, Const.SCROLL_SPEED)
var attach_position := Vector2.ZERO
var is_shooting_player := false

var bullet_emitter_position := Vector2(0, -25)

func _ready():
	add_to_group("enemies")

func destroy():
	emit_signal("destoyed", self)
	queue_free()
	
func _process(_delta):
	display_info()
	
func display_info():
	$Label.text = "HP: %s\nMass: %d" % [str(hp), mass]
	
func start_pull():
	is_shooting_player = false
	is_pulled = true
	
func stop_pull():
#	is_shooting_player = false
	is_pulled = false

func _physics_process(delta):
	if hp <= 0:
		destroy()
	if is_pulled:
		var player_gained_mass = GameState.player_mass - Const.INITIAL_PLAYER_MASS
		var pull_speed: float = Const.BASE_PULL_SPEED * Const.INITIAL_PLAYER_MASS \
				/ (Const.INITIAL_PLAYER_MASS + player_gained_mass * Const.PULL_PENALTY)
		var to_player := GameState.player_position - position
		velocity = move_and_slide(velocity + to_player * pull_speed)
	else:
		if not is_in_group("attached"):
			velocity = move_and_slide(velocity)
	position.x = clamp(position.x, Const.MIN_X, Const.MAX_X)
	if is_shooting_player:
		var target_rotation := position.angle_to_point(GameState.player_position) - PI/2
		rotation = lerp_angle(rotation, target_rotation, delta * ROTATION_SPEED)



func move_attached(new_player_position: Vector2, player_rotation: float):
	var move_to := new_player_position - attach_position.rotated(player_rotation)
	position = move_to
	rotation = player_rotation


func attach(new_attach_position: Vector2):
	$AttackTimer.stop()
	attach_position = new_attach_position
	is_pulled = false
	add_to_group("attached")
	if is_in_group("enemies"):
		remove_from_group("enemies")
	add_to_group("friends")

	
func update_behavior():
	if not is_pulled:
		is_shooting_player = true
		$AttackTimer.start()
	else:
		is_shooting_player = false
		$AttackTimer.stop()


func _on_Area2D_body_entered(body): 
	if body.get_name() == "player" and not is_in_group("attached"):
		update_behavior()


func _on_Area2D_body_exited(body):
	if body.get_name() == "player" and not is_in_group("attached"):
		$AttackTimer.stop()

func emit_bullet(target: Vector2, is_friendly: bool = false):
	var shot: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
	shot.is_friendly = is_friendly
	shot.damage = SHOT_DAMAGE
	shot.direction = target - position
	shot.position = position + bullet_emitter_position.rotated(rotation)
	shot.rotation = position.angle_to_point(target) - PI/2.0
	get_parent().add_child(shot)


func _on_AttackTimer_timeout():
	emit_bullet(GameState.player_position, false)

func shoot_with_player(target_position: Vector2):
	emit_bullet(target_position, true)
