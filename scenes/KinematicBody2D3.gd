extends KinematicBody2D




var mass = 5
var hp = 4
var time = 0



var velocity = Vector2.ZERO

func _ready():
	add_to_group("enemies")

func _on_Area2D_body_entered(body):
	if body.get_name() == "player" and not is_in_group("attached"):
		if body.mass > mass:
			$Timer.start()

var target = null

func _on_Timer_timeout():
	var player = false
	for i in $Area2D.get_overlapping_bodies():
		if i.get_name() == "player":
			player = true
			time += 0.05
			if time < 3:
				print(1.0/30.0)
				modulate = Color(modulate.r+1.0/29.0, modulate.g+1.0/29.0, modulate.b+1.0/29.0, 1)
				$Timer.start()
			else:
				if is_in_group("attached") == false:
					modulate = Color(1,1,1,1)
					add_to_group("attached")
					remove_from_group("enemies")
					add_to_group("friends")
					i.mass += mass
					mass = 0

	if player == false:
		modulate = Color(1,1,1,1)

func _physics_process(_delta):
	if hp <= 0:
		queue_free()
	for i in $Area2D.get_overlapping_bodies():
		if not is_in_group("attached"):
			if i.get_name() == "player":
				look_at(i.position)
				if $attack_timer.time_left == 0:
					$attack_timer.start()
				target = i
		else:
			if i.is_in_group("enemies"):
				target = i
				$attack_timer.start(0.1)



	velocity = move_and_slide(velocity)

func move(velocity_arg):
	velocity = velocity_arg


func _on_attack_timer_timeout():
	if not target.is_in_group("enemies"):
		var shot = preload("res://scenes/enemy_shot.tscn").instance()
		shot.look_at(target.position)
		shot.direction = target.position - position
		shot.position = position
		get_parent().add_child(shot)
	else:
		var shot = preload("res://scenes/shot.tscn").instance()
		shot.look_at(target.position)
		shot.direction = target.position - position
		shot.position = position
		get_parent().add_child(shot)
