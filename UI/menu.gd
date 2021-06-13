extends Control




func _on_TextureButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://game/main.tscn")
	

func _on_TextureButton2_pressed():
	get_tree().quit()
