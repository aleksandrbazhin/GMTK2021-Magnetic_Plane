extends AnimatedSprite


onready var tween_values = [0, 10]

func _enter_tree():
	var tween = Tween.new()
	add_child(tween)

func _ready():
	tween_values[0] = self.get_position().y - 5
	tween_values[1] = tween_values[0] + 5
	_start_tween()

func _start_tween():
	$Tween.interpolate_property(self, "position:y", tween_values[0], tween_values[1], 1)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	printt(object, key)
	tween_values.invert()
	_start_tween()
