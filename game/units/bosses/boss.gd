extends KinematicBody2D


var attacks := ["boss_attack_bullets", "turrets_attack", "attack_bullet_hell"]
var attack_index_pointer := 0

# turrets vars
var turrets_target = null
var destroyed := 0



var hp := 40

# bullets from boss
func boss_attack_bullets() -> void:
	
	if turrets_target != null and is_instance_valid(turrets_target):
		for position_offset in range(-1, 2): 
			var shot: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
			shot.damage = 1
			shot.direction = turrets_target.position - position
			shot.position = Vector2(position.x + 100*position_offset, position.y) + Vector2(0, -25).rotated(rotation)
			shot.rotation = position.angle_to_point(turrets_target.position) - PI/2.0
			shot.scale = Vector2(3,3)
			get_parent().add_child(shot)
		
		if destroyed == 4:
			var shot: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
			shot.damage = 1
			shot.direction = turrets_target.position - position
			shot.position = Vector2(position.x-300, position.y) + Vector2(0, -25).rotated(rotation) 
			shot.rotation = position.angle_to_point(turrets_target.position) - PI/2.0
			shot.scale = Vector2(3,3)
			add_child(shot)
			
			var shot1: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
			shot1.damage = 1
			shot1.direction = turrets_target.position - position
			shot1.position = Vector2(position.x+300, position.y) + Vector2(0, -25).rotated(rotation) 
			shot1.rotation = position.angle_to_point(turrets_target.position) - PI/2.0
			shot1.scale = Vector2(3,3)
			add_child(shot1)

func turrets_attack() -> void:
	if destroyed == 4:
		return
	var turrets_destoryed = 0
	if get_node_or_null("../units/turret") != null:
		get_node("../units/boss_turrets/turret").emit_bullet(GameState.player_position, false)
	else:
		turrets_destoryed += 1
	if get_node_or_null("../units/turret2") != null:
		get_node("../units/boss_turrets/turret2").emit_bullet(GameState.player_position, false)
	else:
		turrets_destoryed += 1
	if get_node_or_null("../units/turret3") != null:
		get_node("../units/boss_turets/turret3").emit_bullet(GameState.player_position, false)
	else:
		turrets_destoryed += 1
	if get_node_or_null("../units/turret4") != null:
		get_node("../units/boss_turrets/turret4").emit_bullet(GameState.player_position, false)
	else:
		turrets_destoryed += 1
	
	destroyed = turrets_destoryed
	print(destroyed)
	if destroyed == 4:
		add_to_group("enemies")


func attack_bullet_hell() -> void:
	# just attack together(turrets and boss)
	boss_attack_bullets()
	turrets_attack()


func _ready():
	$AttackTimer.start(3)


func _physics_process(delta):
	if hp <= 0:
		queue_free()
		get_tree().change_scene("res://UI/menu.tscn")


func _on_AttackTimer_timeout():
	for body in $area2d_for_shoot_attack.get_overlapping_bodies():
		if body.get_name() == "player":
			turrets_target = body
	
	if destroyed == 4 and attacks[attack_index_pointer] == "turrets_attack": 
		# skip `attack_turrets` if all turrets destroyed
		attack_index_pointer += 1
	if attacks[attack_index_pointer] == "boss_attack_bullets":
		turrets_attack()
	elif attacks[attack_index_pointer] == "turrets_attack":
		boss_attack_bullets()
	elif attacks[attack_index_pointer] == "attack_bullet_hell":
		attack_bullet_hell()
	
	if attack_index_pointer >= attacks.size()-1:
		attack_index_pointer = 0
	else:
		attack_index_pointer += 1
	
	if destroyed != 4:
		$AttackTimer.start(2)
	else:
		$AttackTimer.start(1)
