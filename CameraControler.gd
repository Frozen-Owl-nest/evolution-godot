extends Camera2D

var margin = Vector2(200, 100)

var speed = 200

var min_zoom = Vector2(0.5, 0.5)
var max_zoom = Vector2(2, 2)
var zoom_speed = 0.1

func _process(delta):
	var viewport = get_viewport_rect()
	var mouse_pos = get_local_mouse_position()
	var camera_move = Vector2()
	
	if mouse_pos.x < viewport.position.x + margin.x:
		camera_move.x -= speed
	elif mouse_pos.x > viewport.position.x + viewport.size.x - margin.x:
		camera_move.x += speed

	if mouse_pos.y < viewport.position.y + margin.y:
		camera_move.y -= speed
	elif mouse_pos.y > viewport.position.y + viewport.size.y - margin.y:
		camera_move.y += speed

	position += camera_move * delta

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = zoom + Vector2(zoom_speed, zoom_speed)
			zoom.x = max(min_zoom.x, zoom.x)
			zoom.y = max(min_zoom.y, zoom.y)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = zoom - Vector2(zoom_speed, zoom_speed)
			zoom.x = min(max_zoom.x, zoom.x)
			zoom.y = min(max_zoom.y, zoom.y)
