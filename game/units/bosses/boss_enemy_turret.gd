extends KinematicBody2D

class_name boss_turret

signal destoyed()

var mass := 10.0
var hp := 10.0
var time = 0



var damage := 0.5
var bullet_emitter_position := Vector2(0, -25)



func _ready():
	add_to_group("enemies")

func setup(new_hp: float, new_mass: float, collision_size: Vector2, collision_offset: Vector2, new_damage: float) -> void:
	mass = new_mass
	hp = new_hp
	damage = new_damage
	$CollisionShape2D.shape.extents = collision_size
	$CollisionShape2D.position = collision_offset
	
func destroy():
	emit_signal("destoyed", self)
	queue_free()
	


func _physics_process(_delta):
	if hp <= 0:
		destroy()


func emit_bullet():
	var shot: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
	shot.damage = damage
	shot.direction = GameState.player_position - position
	shot.position = position + bullet_emitter_position.rotated(rotation)
	shot.rotation = position.angle_to_point(GameState.player_position) - PI/2.0
	get_parent().add_child(shot)

