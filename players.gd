extends Node2D

@onready var first = $first
@onready var second = $second
@onready var cargo = $cargo
@export var speed = 200.0
@export var half_dist = 32.0
var epsilon = 10.0

var first_holding = false
var second_holding = false

func _ready():
    pass

func _process(delta):
    if Input.is_action_just_pressed("first_action"):
        if first_holding:
            first_holding = false
            first.collision_layer = 1 # Players
            first.collision_mask = 15 # Players, walls, water, sofa
        elif (first.position - cargo.position).length() < half_dist + epsilon:
            first_holding = true
            first.collision_layer = 8 # Sofa
            first.collision_mask = 7  # Players, walls, water
    
    if Input.is_action_just_pressed("second_action"):
        if second_holding:
            second_holding = false
            second.collision_layer = 1 # Players
            second.collision_mask = 15 # Players, walls, water, sofa
        elif (second.position - cargo.position).length() < half_dist + epsilon:
            second_holding = true
            second.collision_layer = 8 # Sofa
            second.collision_mask = 7  # Players, walls, water
    
    var dir_first = Input.get_vector("first_left", "first_right", "first_up", "first_down")
    var dir_second = Input.get_vector("second_left", "second_right", "second_up", "second_down")
    
    if first_holding and second_holding:
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
    else:
        if not first_holding:
            first.velocity = dir_first * speed
            first.move_and_slide()
        if not second_holding:
            second.velocity = dir_second * speed
            second.move_and_slide()
            
