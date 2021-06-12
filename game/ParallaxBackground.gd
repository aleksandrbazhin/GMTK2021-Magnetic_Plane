extends ParallaxBackground


func _process(delta):
	$ParallaxLayer.motion_offset = Vector2($ParallaxLayer.motion_offset.x, 
			$ParallaxLayer.motion_offset.y + Const.SCROLL_SPEED * delta)
