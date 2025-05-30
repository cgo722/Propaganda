extends Control

@export var brush_color: Color = Color.BLACK
@export var brush_size: float = 8.0
@export var canvas_resolution: Vector2i = Vector2i(512, 512)

var drawing := false
var last_pos := Vector2.ZERO
var canvas_image: Image
var canvas_texture: ImageTexture
var canvas_sprite: Sprite2D

func _ready():
	# Create a blank transparent canvas image
	canvas_image = Image.create(canvas_resolution.x, canvas_resolution.y, false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color(1, 1, 1, 0))  # Transparent

	# Create and assign texture
	canvas_texture = ImageTexture.create_from_image(canvas_image)

	# Create and add a Sprite2D to display the canvas
	canvas_sprite = Sprite2D.new()
	canvas_sprite.texture = canvas_texture
	add_child(canvas_sprite)
	
	# Ensure the canvas_sprite fills the parent Control node
	canvas_sprite.position = Vector2.ZERO
	canvas_sprite.scale = get_viewport_rect().size / Vector2(canvas_resolution)

	size = get_viewport_rect().size

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		drawing = event.pressed
		last_pos = _to_canvas_space(event.position)

	elif event is InputEventMouseMotion and drawing:
		var current_pos = _to_canvas_space(event.position)
		_draw_line(last_pos, current_pos)
		last_pos = current_pos

func _draw_line(from_pos: Vector2, to_pos: Vector2):
	var distance = from_pos.distance_to(to_pos)
	var steps = int(distance)
	var step_vec = (to_pos - from_pos).normalized()
	
	for i in range(steps):
		var pos = from_pos + step_vec * i
		_draw_circle_at(pos)

	canvas_texture.update(canvas_image)

func _draw_circle_at(pos: Vector2):
	var radius = brush_size / 2.0
	var brush_img = Image.create(int(brush_size), int(brush_size), false, Image.FORMAT_RGBA8)
	brush_img.fill(brush_color)

	var brush_rect = Rect2i(Vector2i.ZERO, Vector2i(int(brush_size), int(brush_size)))
	var target_pos = Vector2i(pos.x - radius, pos.y - radius)
	canvas_image.blit_rect(brush_img, brush_rect, target_pos)

func clear_canvas():
	canvas_image.fill(Color(1, 1, 1, 0))
	canvas_texture.update(canvas_image)

func _to_canvas_space(screen_pos: Vector2) -> Vector2:
	var sprite_pos = canvas_sprite.position
	var sprite_scale = canvas_sprite.scale
	return (screen_pos - sprite_pos) / sprite_scale
