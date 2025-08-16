extends CanvasLayer

@onready var tooltips: Dictionary[String, Label] = {
	"interact_tooltip": %InteractLabel,
	"piss_tooltip": %PissLabel
}

func _ready() -> void:
	get_tree().current_scene.get_node("Level").get_node("Player").change_tooltip.connect(_on_change_tooltip)

func _on_change_tooltip(tooltip: String, state: bool) -> void:
	tooltips.get(tooltip).visible = state
