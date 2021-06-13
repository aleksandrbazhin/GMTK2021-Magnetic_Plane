extends BaseEnemy

class_name Turret

const COLLIZION_SIZE := Vector2(20, 20)
const COLLIZION_OFFSET := Vector2(0, 5)
const MASS := 8
const HP := 10
const SHOT_DAMAGE = 0.5

const ROTATION_SPEED = 5.0
var is_shooting_player := false

func _ready():
	.setup(HP, MASS, COLLIZION_SIZE, COLLIZION_OFFSET, SHOT_DAMAGE)
	

func _physics_process(delta):
	._physics_process(delta)
	if is_shooting_player:
		var target_rotation := position.angle_to_point(GameState.player_position) - PI/2
		rotation = lerp_angle(rotation, target_rotation, delta * ROTATION_SPEED)
	
func start_pull():
	is_shooting_player = false
	.start_pull()

func shoot_with_player(target_position: Vector2):
	$AudioStreamPlayer2D.play()
	emit_bullet(target_position - attach_position.rotated(rotation), true)

func update_behavior():
	if not is_pulled:
		is_shooting_player = true
		$AttackTimer.start()
	else:
		is_shooting_player = false
		$AttackTimer.stop()

func player_exited_vision():
	$AttackTimer.stop()

func attach(new_attach_position: Vector2):
	$AttackTimer.stop()
	.attach(new_attach_position)

func _on_AttackTimer_timeout():
	$AudioStreamPlayer2D.play()
	emit_bullet(GameState.player_position, false)
	
