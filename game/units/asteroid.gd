extends Area2D

var hp = 1

var direction = Vector2()
var speed = 0
var directions = [Vector2(1,0), Vector2(1,1)]


func _ready():
	direction = directions[randi()%2]
	speed = randi()%100
	

func _process(_delta):
	if hp <= 0:
		queue_free()
	
