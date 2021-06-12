extends Area2D

var bodies_in_the_field: int = 0

onready var magnet := $MagnetSprite

func start_magnet():
	magnet.visible = true
	magnet.play()

func stop_magnet():
	magnet.visible = false
	magnet.stop()

func update_magnet():
	if bodies_in_the_field > 0:
		start_magnet()
	else:
		stop_magnet()

func add_pulled(pullable):
	pullable.connect("tree_exited", self, "remove_pulled")
	bodies_in_the_field += 1
	update_magnet()

func remove_pulled(pullable):
	if pullable.is_connected("tree_exited", self, "remove_pulled"):
		pullable.disconnect("tree_exited", self, "remove_pulled")
	bodies_in_the_field -= 1
	update_magnet()

func _on_MagnetArea2D_body_entered(body):
	if body.get("is_pullable") != null and body.is_pullable == true and \
			body.get("mass") != null and body.get("is_pulled") != null:
		if GameState.player_mass > body.mass:
			body.is_pulled = true
			add_pulled(body)
			
			
func _on_MagnetArea2D_body_exited(body):
	if body.get("is_pullable") != null and body.is_pullable == true and \
			body.get("mass") != null and body.get("is_pulled") != null:
		if body.is_pulled == true:
			body.is_pulled = false
			remove_pulled(body)
