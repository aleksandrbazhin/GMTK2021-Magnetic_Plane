extends Node2D


onready var player: Player = $units/player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if is_instance_valid(player):
		GameState.player_position = player.position
	else:
		get_tree().change_scene("res://UI/menu.tscn")


func get_units():
	return $units.get_children()
	

func spawn_enemy():
	var enemy: BaseEnemy = preload("res://game/units/enemies/enemy.tscn").instance()
	$units.add_child(enemy)
	pass
	# player attc
