extends KinematicBody2D



signal destoyed()

var mass := 10.0
var hp := 10.0
var time = 0



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
	


func _physics_process(_delta):
	if hp <= 0:
		destroy()




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
