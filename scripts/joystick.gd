extends Control

var drag = false
var base_pos = Vector2()
var knob = null
var output = Vector2.ZERO

func _ready():
    knob = $JoystickBase/JoystickKnob
    base_pos = $JoystickBase.position

func _input(event):
    if event is InputEventScreenTouch or event is InputEventScreenDrag:
        if event.position.distance_to(base_pos + Vector2(128, 128)) < 160:
            drag = event.pressed
            if drag:
                var dir = (event.position - (base_pos + Vector2(128, 128)))
                dir = dir.clamped(80)   # radius
                knob.position = dir + Vector2(128, 128)
                output = dir / 80.0
            else:
                knob.position = Vector2(128, 128)
                output = Vector2.ZERO