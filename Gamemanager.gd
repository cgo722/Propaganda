extends Node

@export var poster_events: Array[Resource] = []
@export var council_events: Array[Resource] = []


var preloaded_poster_events: Array[Resource] = []
var preloaded_council_events: Array[Resource] = []

func _ready():
	preload_random_events()

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


# Advances to the next event, automatically choosing from poster or council pools.
func advance_to_next_event() -> Resource:
	if preloaded_poster_events.is_empty() and preloaded_council_events.is_empty():
		preload_random_events()

	if randi() % 2 == 0 and not preloaded_poster_events.is_empty():
		return preloaded_poster_events.pop_front()
	elif not preloaded_council_events.is_empty():
		return preloaded_council_events.pop_front()
	elif not preloaded_poster_events.is_empty():
		return preloaded_poster_events.pop_front()
	else:
		return null
