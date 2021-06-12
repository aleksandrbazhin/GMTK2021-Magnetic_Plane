extends KinematicBody2D


var mass = 5
var hp = 4
var time = 0



var velocity = Vector2.ZERO

var attack_now = false

var magnet = null
func _ready():
	add_to_group("enemies")

func destroy():
	get_tree().call_group("attached", "queue_free")
	queue_free()

func _on_Area2D_body_entered(body): 
	if body.get_name() == "player" and not is_in_group("attached"):
		magnet = body.get_node("magnet")
		if body.mass > mass:
			$Timer.start()
			magnet.visible = true
			magnet.play()
var target = null

func _on_Timer_timeout():
	var player = false
	for i in $Area2D.get_overlapping_bodies():
		if i.get_name() == "player":
			player = true
			time += 0.05
			if time < 3:
				$Timer.start()
			else:
				if is_in_group("attached") == false:
					magnet.visible = false
					add_to_group("attached")
					remove_from_group("enemies")
					add_to_group("friends")
					i.mass += mass
					mass = 0

	if player == false:
		magnet.visible = false
		magnet.stop()

func _physics_process(_delta):
	#print(get_name(), ": ", is_in_group("attached"))
	if hp <= 0:
		queue_free()
	for i in $Area2D.get_overlapping_bodies():
		if not is_in_group("friends"):
			if i.get_name() == "player":
				if attack_now == true:
					break
				var attack_timer = Timer.new()
				add_child(attack_timer)
				attack_timer.start(1)
				attack_timer.connect("timeout", self, "_on_attack_timer_timeout")
				attack_timer.one_shot = true
				target = i
				attack_now = true
		else:
			if i.is_in_group("enemies"):
				look_at(i.position)
				if attack_now == true:
					break
				target = i
				var attack_timer = Timer.new()
				add_child(attack_timer)
				attack_timer.connect("timeout", self, "_on_attack_timer_timeout")
				attack_timer.start(1)
				attack_timer.one_shot = true
				attack_now = true
	velocity = move_and_slide(velocity)

func move(velocity_arg):
	velocity = velocity_arg
	position.x = clamp(position.x, 0, 400)


func _on_attack_timer_timeout():
	attack_now = false
	if weakref(target).get_ref():
		if not is_in_group("friends"):
			var shot = preload("res://scenes/enemy_shot.tscn").instance()
			shot.damage = 0.5
			shot.direction = target.position - position
			shot.position = position
			get_parent().add_child(shot)
		else:
			var shot = preload("res://scenes/shot.tscn").instance()
			shot.damage = 0.5
			shot.direction = target.position - position
			shot.position = position
			get_parent().add_child(shot)
