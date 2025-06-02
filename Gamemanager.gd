extends Node

enum GameState { MENU, PLAYING, EVENT, RESULT, GAME_OVER }

@export var player_resource: Resource
@export var event_ui_scene: PackedScene

@export var poster_events: Array[Resource] = []
@export var council_events: Array[Resource] = []

@export var main_menu_scene: PackedScene
@export var canvas_scene: PackedScene

var preloaded_poster_events: Array[Resource] = []
var preloaded_council_events: Array[Resource] = []

var current_state: GameState = GameState.MENU

func _ready():
	preload_random_events()
	_show_main_menu()

func preload_random_events():
	preloaded_poster_events.clear()
	preloaded_council_events.clear()

	var shuffled_posters = poster_events.duplicate()
	shuffled_posters.shuffle()
	preloaded_poster_events.append_array(shuffled_posters.slice(0, 10))

	var shuffled_councils = council_events.duplicate()
	shuffled_councils.shuffle()
	preloaded_council_events.append_array(shuffled_councils.slice(0, 10))

func _get_random_poster_event():
	if preloaded_poster_events.is_empty():
		preload_random_events()
	return preloaded_poster_events.pop_front()

func _get_random_council_event():
	if preloaded_council_events.is_empty():
		preload_random_events()
	return preloaded_council_events.pop_front()


func set_state(new_state: GameState):
	current_state = new_state
	match new_state:
		GameState.MENU:
			# Handle menu setup
			pass
		GameState.PLAYING:
			# Begin run or resume loop
			pass
		GameState.EVENT:
			_on_enter_event_state()
		GameState.RESULT:
			# Show evaluation or results
			pass
		GameState.GAME_OVER:
			# Handle game over logic
			pass

# Advances to the next event, automatically choosing from poster or council pools.
func advance_to_next_event() -> void:
	set_state(GameState.EVENT)

func _on_enter_event_state():
	if preloaded_poster_events.is_empty() and preloaded_council_events.is_empty():
		preload_random_events()

	var next_event: Resource = null

	if randi() % 2 == 0 and not preloaded_poster_events.is_empty():
		next_event = preloaded_poster_events.pop_front()
	elif not preloaded_council_events.is_empty():
		next_event = preloaded_council_events.pop_front()
	elif not preloaded_poster_events.is_empty():
		next_event = preloaded_poster_events.pop_front()

	if next_event != null:
		# Show or process the next event here
		print("Next event loaded:", next_event)
	else:
		set_state(GameState.GAME_OVER)


# Helper functions for scene management
func _show_main_menu():
	if not main_menu_scene:
		push_error("main_menu_scene is not assigned.")
		return
	var main_menu = main_menu_scene.instantiate()
	add_child(main_menu)
	main_menu.connect("start_game", Callable(self, "_on_start_game"))

func _on_start_game():
	var main_menu = get_node("MainMenu")
	if main_menu:
		main_menu.queue_free()

	if not event_ui_scene:
		push_error("event_ui_scene is not assigned.")
		return
	var event_ui = event_ui_scene.instantiate()
	event_ui.name = "EventUI"
	add_child(event_ui)
	if player_resource:
		print("Loaded player resource:", player_resource)
	else:
		push_error("player_resource is not assigned.")

	set_state(GameState.PLAYING)

func _on_screen_clicked():
	if preloaded_poster_events.is_empty() and preloaded_council_events.is_empty():
		preload_random_events()

	var next_event: Resource = null

	if randi() % 2 == 0 and not preloaded_poster_events.is_empty():
		next_event = preloaded_poster_events.pop_front()
	elif not preloaded_council_events.is_empty():
		next_event = preloaded_council_events.pop_front()
	elif not preloaded_poster_events.is_empty():
		next_event = preloaded_poster_events.pop_front()

	var event_ui = get_node("EventUI") # Assumes EventUI node name
	if next_event and event_ui and event_ui.has_method("display_scenario"):
		event_ui.display_scenario(next_event)

		if next_event.has_method("is_poster") and next_event.is_poster:
			event_ui.anchor_right = 1.0
			event_ui.anchor_bottom = 0.3
			event_ui.margin_left = 0
			event_ui.margin_top = 0
			event_ui.margin_right = 400
			event_ui.margin_bottom = 200

			if canvas_scene:
				var canvas = canvas_scene.instantiate()
				add_child(canvas)
			else:
				push_error("canvas_scene is not assigned.")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_screen_clicked()
