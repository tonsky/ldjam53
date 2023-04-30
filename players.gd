extends Node2D

@onready var first = $first
@onready var second = $second
@onready var cargo = $cargo
@export var speed = 200.0
@export var half_dist = 32.0

func _ready():
    pass

func _process(delta):
    var dir_first = Input.get_vector("first_left", "first_right", "first_up", "first_down")
    var dir_second = Input.get_vector("second_left", "second_right", "second_up", "second_down")
        
    first.velocity = dir_first * speed
    first.move_and_slide()
    
    second.velocity = dir_second * speed
    second.move_and_slide()
    
    var dir = (second.position - first.position).normalized()
    
    if first.get_position_delta().length() < second.get_position_delta().length():
        second.position = first.position + dir * half_dist * 2.0
    else:
        first.position = second.position - dir * half_dist * 2.0
    
    var new_center = (second.position + first.position) / 2.0
    cargo.velocity = (new_center - cargo.position) / delta
    cargo.rotation = dir.angle()
    
    cargo.move_and_slide()
    
    first.position = cargo.position - dir * half_dist
    second.position = cargo.position + dir * half_dist
