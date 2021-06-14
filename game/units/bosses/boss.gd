extends KinematicBody2D

#types of attacks
var attacks = ["attack_three_bullets", "attack_turrets", "attack_bullet_hell"]
var attack_index = 0

# turrets vars
var target = null
var destroyed = 0 # how many destroyed


# hp of boss
var hp = 40


func attack_bullets():
	if target != null:
		var shot: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
		shot.damage = 1
		shot.direction = target.position - position
		shot.position = Vector2(position.x, position.y) + Vector2(0, -25).rotated(rotation)
		shot.rotation = position.angle_to_point(target.position) - PI/2.0
		shot.scale = Vector2(3,3)
		get_parent().add_child(shot)
	
		var shot2: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
		shot2.damage = 1
		shot2.direction = target.position - position
		shot2.position = Vector2(position.x+100, position.y) + Vector2(0, -25).rotated(rotation) 
		shot2.rotation = position.angle_to_point(target.position) - PI/2.0
		shot2.scale = Vector2(3,3)
		add_child(shot2)
	
		var shot3: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
		shot3.damage = 1
		shot3.direction = target.position - position
		shot3.position = Vector2(position.x-100, position.y) + Vector2(0, -25).rotated(rotation) 
		shot3.rotation = position.angle_to_point(target.position) - PI/2.0
		shot3.scale = Vector2(3,3)
		add_child(shot3)
		
		
		if destroyed == 4:
			var shot4: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
			shot4.damage = 1
			shot4.direction = target.position - position
			shot4.position = Vector2(position.x-200, position.y) + Vector2(0, -25).rotated(rotation) 
			shot4.rotation = position.angle_to_point(target.position) - PI/2.0
			shot4.scale = Vector2(3,3)
			add_child(shot4)
			
			var shot5: EnemyShot = preload("res://game/shots/enemy_shot.tscn").instance()
			shot5.damage = 1
			shot5.direction = target.position - position
			shot5.position = Vector2(position.x+200, position.y) + Vector2(0, -25).rotated(rotation) 
			shot5.rotation = position.angle_to_point(target.position) - PI/2.0
			shot5.scale = Vector2(3,3)
			add_child(shot5)

func attack_turrets():
	if destroyed == 4:
		return
	var all = 0
	if get_node_or_null("../turret") != null:
		get_node("../turret").emit_bullet(GameState.player_position, false)
	else:
		all += 1
	if get_node_or_null("../turret2") != null:
		get_node("../turret2").emit_bullet(GameState.player_position, false)
	else:
		all += 1
	if get_node_or_null("../turret3") != null:
		get_node("../turret3").emit_bullet(GameState.player_position, false)
	else:
		all += 1
	if get_node_or_null("../turret4") != null:
		get_node("../turret4").emit_bullet(GameState.player_position, false)
	else:
		all += 1
	
	destroyed = all
	if destroyed == 4:
		add_to_group("enemies")

func attack_bullet_hell():
	# just attack together(turrets and boss)
	attack_bullets()
	attack_turrets()


func _ready():
	$AttackTimer.start(3)

func _physics_process(delta):
	if hp <= 0:
		queue_free()
		get_tree().change_scene("res://UI/menu.tscn")

func _on_AttackTimer_timeout():
	for i in $Area2D.get_overlapping_bodies():
		print(i)
		if i.get_name() == "player":
			target = i
	
	if destroyed == 4 and attacks[attack_index] == "attack_three_bullets":
		attack_index += 1
	if attacks[attack_index] == "attack_three_bullets":
		attack_turrets()
	elif attacks[attack_index] == "attack_turrets":
		attack_bullets()
	else:
		attack_bullet_hell()
	
	if attack_index >= attacks.size()-1:
		attack_index = 0
	else:
		attack_index += 1
	
	if destroyed != 4:
		$AttackTimer.start(3)
	else:
		$AttackTimer.start(1)
