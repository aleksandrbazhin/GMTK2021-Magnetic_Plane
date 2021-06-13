extends ParallaxBackground


func _process(_delta):
	$ParallaxLayer.motion_offset = Vector2($ParallaxLayer.motion_offset.x-5, $ParallaxLayer.motion_offset.y)
