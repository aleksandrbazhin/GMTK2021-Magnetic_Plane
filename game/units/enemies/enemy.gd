extends KinematicBody2D

class_name BaseEnemy


signal destoyed()

var mass := 10.0
var hp := 4.0
var time = 0

var is_pullable := true
var is_pulled := false
var velocity := Vector2(0, Const.SCROLL_SPEED)
var attach_position := Vector2.ZERO
var damage := 0.5

var bullet_emitter_position := Vector2(0, -25)

var attach_line_ref: WeakRef = null

func _ready():
	add_to_group("enemies")

func setup(new_hp: float, new_mass: float, collision_size: Vector2, collision_offset: Vector2, new_damage: float):
	mass = new_mass
	hp = new_hp
	damage = new_damage
	$CollisionShape2D.shape.extents = collision_size
	$CollisionShape2D.position = collision_offset
	
func destroy():
	emit_signal("destoyed", self)
	if attach_line_ref != null and attach_line_ref.get_ref() != null:
		attach_line_ref.get_ref().queue_free()
	queue_free()
	
func start_pull():
	is_pulled = true
	
func stop_pull():
	is_pulled = false

func _physics_process(_delta):
	if hp <= 0:
		destroy()
	if is_pulled:
		var player_gained_mass = GameState.player_mass - Const.INITIAL_PLAYER_MASS
		var pull_speed: float = Const.BASE_PULL_SPEED * Const.INITIAL_PLAYER_MASS \
				/ (Const.INITIAL_PLAYER_MASS + player_gained_mass * Const.PULL_PENALTY)
		var to_player := GameState.player_position - position
		velocity = move_and_slide(velocity + to_player * pull_speed)
		check_destroy_plane()		
	else:
		if not is_in_group("attached"):
			velocity = move_and_slide(velocity)
			check_destroy_plane()

			
	position.x = clamp(position.x, Const.MIN_X, Const.MAX_X)

func check_destroy_plane():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is StaticBody2D:
			destroy()


func move_attached(new_player_position: Vector2, player_rotation: float):
	var move_to := new_player_position - attach_position.rotated(player_rotation)
	position = move_to
	rotation = player_rotation


func attach(new_attach_position: Vector2):
	attach_position = new_attach_position
	is_pulled = false
	add_to_group("attached")
	if is_in_group("enemies"):
		remove_from_group("enemies")
	add_to_group("friends")

	
func update_behavior():
	pass

func player_entered_vision():
	update_behavior()
	
func player_exited_vision():
	pass

func _on_Area2D_body_entered(body): 
	if body.get_name() == "player" and not is_in_group("attached"):
		player_entered_vision()

func _on_Area2D_body_exited(body):
	if body.get_name() == "player" and not is_in_group("attached"):
		player_exited_vision()
		
func emit_bullet(target: Vector2, is_friendly: bool = false):
	var shot: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
	shot.is_friendly = is_friendly
	shot.damage = damage
	shot.direction = target - position
	shot.position = position + bullet_emitter_position.rotated(rotation)
	shot.rotation = position.angle_to_point(target) - PI/2.0
	get_parent().add_child(shot)

func shoot_with_player(_target_position: Vector2):
	pass
	
