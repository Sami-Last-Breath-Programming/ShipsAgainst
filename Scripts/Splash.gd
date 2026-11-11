extends CanvasLayer

# Lazy Load
@onready var company := $Company;

func _ready() -> void:
	# Set start alpha 0
	company.modulate.a = 0.0;
	
	# Animation
	var anim := create_tween()
	
	# Delay
	anim.tween_interval(0.4)
	
	# Increase alpha to 1
	anim.tween_property(company, "modulate:a", 1.0, 4.0)
