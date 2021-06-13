extends Area2D

var bodies_in_the_field: int = 0

onready var magnet := $MagnetSprite

func start_magnet():
	magnet.visible = true
	magnet.play()

func stop_magnet():
	magnet.visible = false
	play_attached_sound()
	magnet.stop()

func update_magnet():
	if bodies_in_the_field > 0:
		start_magnet()
	else:
		stop_magnet()

func add_pulled(pullable):
	if pullable.has_signal("destroyed"):
		pullable.connect("destroyed", self, "remove_pulled")
	bodies_in_the_field += 1
	update_magnet()

func remove_pulled(pullable):
	
	if pullable.has_signal("destroyed") and pullable.is_connected("destroyed", self, "remove_pulled"):
		pullable.disconnect("destroyed", self, "remove_pulled")
	bodies_in_the_field -= 1
	update_magnet()

func _on_MagnetArea2D_body_entered(body):
	if body.get("is_pullable") != null and body.is_pullable == true and \
			body.get("mass") != null and body.get("is_pulled") != null:
		if GameState.player_mass > body.mass:
			body.start_pull()
			play_attaching_sound()
			add_pulled(body)
			
			
func _on_MagnetArea2D_body_exited(body):
	if body.get("is_pullable") != null and body.is_pullable == true and \
			body.get("mass") != null and body.get("is_pulled") != null:
		if body.is_pulled == true:
			body.stop_pull()
			remove_pulled(body)

func play_attaching_sound():
	if !$AttachingSound.is_playing():
		$AttachingSound.play()

func play_attached_sound():
	if !$AttachedSound.is_playing():
		$AttachedSound.play()
