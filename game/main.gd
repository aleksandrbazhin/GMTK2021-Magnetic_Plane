extends Node2D


onready var player: Player = $units/player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("mass_changed", self, "on_player_mass_changed")

func on_player_mass_changed():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.update_magnet_pull(player)

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
