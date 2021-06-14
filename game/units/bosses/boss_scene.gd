extends Node2D

# extends from main scene

onready var player: Player = get_node("player")


func _unhandled_input(_event):
	if Input.is_action_pressed("ui_cancel"):
		leave_game()
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


# ==================>
