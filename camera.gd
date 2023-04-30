extends Camera2D

@onready var first = get_node("../players/first")
@onready var second = get_node("../players/second")

func _process(delta):
    
    position = (first.global_position + second.global_position) / 2.0
    var dist = (first.global_position - second.global_position).length()
    var scale = 400 / max(400, dist)
    zoom = Vector2(scale, scale)
