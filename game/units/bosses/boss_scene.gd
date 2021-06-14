extends Node2D



onready var player: Player = get_node("units/player")
onready var player_camera: Camera2D = get_node("units/player/Camera2D")

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


func _ready():
	player_camera.limit_bottom = 1000
	player_camera.limit_left = 1000
	player_camera.limit_right = 1000
	player_camera.zoom = Vector2(1.5, 1.5)
	player_camera.current = true
