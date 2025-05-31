extends Resource
class_name ScenarioResource

@export var title: String
@export_multiline var body_text: String
@export var is_poster: bool = true
@export var tags: Array[String] = []
@export var requirements: Array[String] = []
@export var effects: Dictionary = {}
@export var image: Texture2D