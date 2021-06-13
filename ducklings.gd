extends Node

export var direction = Vector2()

export var speed = 400

var go = false

func _ready():
	for i in range(0,2):
		for j in range(0,4):
			var enemy = preload("res://game/units/asteroids/asteroid.tscn").instance()
			enemy.direction = direction
			enemy.speed = speed
			enemy.scale = Vector2(2, 2)
			enemy.position = Vector2(j*100, i*100)
			add_child(enemy)

func _process(delta):
	for i in get_children():
		if i.get_name() != "COLLISION":
			if go == true:
				i.go = true


func _on_Area2D_body_entered(body):
	go = true
