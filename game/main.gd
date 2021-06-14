extends Node2D


onready var player: Player = $units/player

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	player.connect("mass_changed", self, "on_player_mass_changed")
	$units/player/Camera2D.limit_left = -680
	$units/player/Camera2D.limit_right = 680
	$units/player/Camera2D.limit_bottom = 540

func on_player_mass_changed():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.update_behavior()
		

func leave_game():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/menu.tscn")

func _physics_process(_delta):
	if is_instance_valid(player):
		update_game_state()
	else:
		leave_game()

func update_game_state():
	GameState.player_position = player.position
	GameState.player_mass = player.mass

func _unhandled_input(_event):
	if Input.is_action_pressed("ui_cancel"):
		leave_game()


func get_units():
	return $units.get_children()
	

func spawn_enemy():
	var enemy: BaseEnemy = preload("res://game/units/enemies/enemy.tscn").instance()
	$units.add_child(enemy)

	# player attc


func _on_Area2D_body_entered(body):
	if body.get_name() == "player":
		print("yes")
		get_tree().change_scene("res://game/units/bosses/boss.tscn")

