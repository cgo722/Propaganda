extends Control

@export var title_label: Label
@export var body_label: Label
@export var image_texture: TextureRect

@onready var game_manager = get_tree().get_root().get_node("Gamemanager") # Adjust path if needed

func get_available_scenarios() -> Array:
    if game_manager and game_manager.has_method("get_scenarios"):
        return game_manager.get_scenarios()
    return []

func display_scenario(scenario: Resource) -> void:
    if scenario:
        if title_label and body_label:
            title_label.text = scenario.title
            body_label.text = scenario.body_text
        else:
            push_error("TitleLabel or BodyLabel not properly assigned.")

        if image_texture and scenario.has_property("image"):
            image_texture.texture = scenario.image
        elif image_texture:
            image_texture.texture = null  # Clear image if none provided