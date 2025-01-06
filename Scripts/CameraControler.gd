extends Camera2D

var margin = Vector2(200, 100)

var speed = 200

var min_zoom = Vector2(0.5, 0.5)
var max_zoom = Vector2(2, 2)
var zoom_speed = 0.1

func _process(delta):
	var viewport = get_viewport_rect()
	var scaled_mouse_pos = get_local_mouse_position() * self.zoom
	var camera_move = Vector2()

	if scaled_mouse_pos.x < -viewport.size.x/2 + margin.x && self.position.x > -1000:
		camera_move.x -= speed
	elif scaled_mouse_pos.x > viewport.size.x/2 - margin.x && self.position.x < 1000:
		camera_move.x += speed

	if scaled_mouse_pos.y < -viewport.size.y/2 + margin.y && self.position.y > -1000:
		camera_move.y -= speed
	elif scaled_mouse_pos.y > viewport.size.y/2 - margin.y  && self.position.y < 1000:
		camera_move.y += speed

	position += camera_move * delta

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if zoom.x < 2:
				zoom = zoom + Vector2(zoom_speed, zoom_speed)
				zoom.x = max(min_zoom.x, zoom.x)
				zoom.y = max(min_zoom.y, zoom.y)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = zoom - Vector2(zoom_speed, zoom_speed)
			zoom.x = min(max_zoom.x, zoom.x)
			zoom.y = min(max_zoom.y, zoom.y)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos = get_global_mouse_position()
			var parameters = PhysicsPointQueryParameters2D.new()
			parameters.position = mouse_pos
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_point(parameters)
			if result:
				var target = result[0]['collider']
				if target:
					if target.has_method("on_click"):
						target.call("on_click")
			else:
				var panel = get_node("/root/Scene/CanvasLayer/StatsPanel")
				panel.set_agent(null)
				panel.hide()
