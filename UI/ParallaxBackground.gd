extends ParallaxBackground


func _process(_delta):
	$ParallaxLayer.motion_offset = Vector2($ParallaxLayer.motion_offset.x+5, $ParallaxLayer.motion_offset.y)
	$ParallaxLayer2.motion_offset = Vector2($ParallaxLayer.motion_offset.x+5, $ParallaxLayer.motion_offset.y)
	
	if $ParallaxLayer2.position.x > get_parent().get_viewport_rect().size.x:
		$ParallaxLayer2.position.x = $ParallaxLayer2.position.x - $ParallaxLayer.position.x
	if $ParallaxLayer.position.x > get_parent().get_viewport_rect().size.x:
		$ParallaxLayer.position.x = $ParallaxLayer.position.x - $ParallaxLayer2.position.x
