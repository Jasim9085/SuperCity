extends CharacterBody3D

@export var speed = 5.0
@export var jump_force = 6.0
@export var gravity = 12.0

var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var move_input = Vector2.ZERO

func _ready():
    # Connect signals from HUD
    var hud = get_tree().root.get_node("Main/HUD")
    hud.connect("move_input", Callable(self, "_on_move_input"))
    hud.connect("jump_pressed", Callable(self, "_on_jump_pressed"))

func _physics_process(delta):
    # Apply joystick movement (move_input)
    if move_input.length() > 0.1:
        direction = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed

        # Rotate character smoothly in movement direction
        var target = global_transform.origin - direction
        look_at(target, Vector3.UP)
    else:
        # Gradually stop when no input
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    # Jump + gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    move_and_slide()

func _on_move_input(dir):
    move_input = dir

func _on_jump_pressed():
    if is_on_floor():
        velocity.y = jump_force