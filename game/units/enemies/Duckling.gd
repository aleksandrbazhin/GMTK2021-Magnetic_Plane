extends BaseEnemy

class_name Duckling

const COLLIZION_SIZE := Vector2(20, 20)
const COLLIZION_OFFSET := Vector2(0, 5)
const MASS := 5
const HP := 5
const DAMAGE = 1.0

const VISION_RADUIS = 800
const TURN_RADUIS := 200.0
const SPEED := 60
var is_moving := false
var move_start_time := 0

func _ready():
	.setup(HP, MASS, COLLIZION_SIZE, COLLIZION_OFFSET, DAMAGE)
	$VisionArea2D/CollisionShape2D.shape.radius = VISION_RADUIS
	
func _physics_process(delta):
	if is_moving:
		var time_from_move_start := move_start_time - OS.get_ticks_msec()
		velocity = move_and_slide(Vector2(sin(time_from_move_start/TURN_RADUIS) * SPEED, SPEED + Const.SCROLL_SPEED))
	._physics_process(delta)

func start_moving():
	is_moving = true
	move_start_time = OS.get_ticks_msec()

func update_behavior():
	if not is_pulled:
		is_moving = true
		move_start_time = OS.get_ticks_msec()
	else:
		is_moving = false
		


func player_entered_vision():
	
	.player_entered_vision()
