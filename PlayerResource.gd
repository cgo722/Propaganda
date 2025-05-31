extends Resource

class_name PlayerResource

@export var player_name: String = "The Royal Illustrator"
@export var age: int = 0
@export var favor: int = 5 # King’s opinion (0-10 scale)
@export var society: int = 5 # Public opinion (0-10 scale)
@export var chaos: int = 0 # Optional: for random events
@export var tools_unlocked: Array[String] = ["brush_basic", "black"] # Drawing tools/colors
@export var current_modifiers: Array[String] = [] # Active boss effects or chaos rules
@export var scenario_history: Array[Resource] = [] # Previously seen ScenarioResources
@export var turns_survived: int = 0
