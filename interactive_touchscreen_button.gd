class_name InteractiveTouchscreenButton,"res://Interactive Touchscreen Button.svg"
extends TextureButton

const default_values := {
	"expand" : true,
	"stretch_mode" : TextureButton.STRETCH_KEEP_ASPECT_CENTERED,
	"action_mode" : TextureButton.ACTION_MODE_BUTTON_PRESS,
	"focus_mode" : TextureButton.FOCUS_NONE,
}

export var input_action:String
export var use_default_values := true
export var touchscreen_only := false

var touch_index := 0
var released := true

func _init() -> void :
	if use_default_values :
		for p in default_values.keys() :
			set(p, default_values.get(p))
	if touchscreen_only and not OS.has_touchscreen_ui_hint() :
		hide()


func press() -> void :
	var action = InputEventAction.new()
	action.action = input_action
	action.pressed = true
	Input.parse_input_event(action)
	released = false


func release() -> void :
	var action = InputEventAction.new()
	action.action = input_action
	action.pressed = false
	Input.parse_input_event(action)
	released = true


func is_inside(pos:Vector2) -> bool :
	if int(pos.x) in range(rect_global_position.x, rect_global_position.x+(rect_global_size.x*rect_scale.x)) :
		if int(pos.y) in range(rect_global_position.y, rect_global_position.y+(rect_size.y*rect_scale.y)) :
			return true
	return false


func _input(event) :
	if event is InputEventScreenTouch :
		if is_visible_in_tree() and is_in(event.position) :
			if event.pressed :
				if released :
					touch_index = event.index
				if touch_index == event.index :
					press()
				else :
					release()
			else :
				release()
		if event.index == touch_index and not event.pressed :
			release()