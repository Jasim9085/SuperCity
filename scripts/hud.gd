extends CanvasLayer

@onready var base = $Control/JoystickBase
@onready var knob = $Control/JoystickKnob
@onready var jump_button = $Control/JumpButton

var radius = 100.0
var knob_center = Vector2()
var touch_id = -1
var direction = Vector2.ZERO

signal move_input(dir)
signal jump_pressed()

func _ready():
    knob_center = base.position + base.custom_minimum_size / 2.0
    knob.position = knob_center - knob.custom_minimum_size / 2.0

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed and base.get_rect().has_point(event.position):
            touch_id = event.index
            _update_knob(event.position)
        elif not event.pressed and event.index == touch_id:
            _reset_knob()
            touch_id = -1

    elif event is InputEventScreenDrag and event.index == touch_id:
        _update_knob(event.position)

func _update_knob(pos: Vector2):
    var dir = pos - knob_center
    if dir.length() > radius:
        dir = dir.normalized() * radius
    knob.position = knob_center + dir - knob.custom_minimum_size / 2.0
    direction = dir / radius
    emit_signal("move_input", direction)

func _reset_knob():
    knob.position = knob_center - knob.custom_minimum_size / 2.0
    direction = Vector2.ZERO
    emit_signal("move_input", direction)

func _on_jump_pressed():
    emit_signal("jump_pressed")