@icon("res://Interactive Touchscreen Button.svg")
class_name InteractiveTouchscreenButton
extends Button

const DefaultValues := {
	"expand_icon" : true,
	"action_mode" : Button.ACTION_MODE_BUTTON_PRESS,
	"focus_mode" : TextureButton.FOCUS_NONE,
}

@export_custom(PROPERTY_HINT_INPUT_NAME, "") var input_action:StringName 
@export var use_default_values := true
@export var touchscreen_only := false

var touch_index := 0
var released := true
var button_toggled := false
var is_pressed:= false

func _ready() -> void:
	if use_default_values :
		for k in DefaultValues.keys() :
			self.set(k, DefaultValues.get(k))
			
	
	#hide  and disable the button if there's no touchscreen
	if touchscreen_only and not DisplayServer.is_touchscreen_available():
		hide()
		set_disabled(true)

func press():
	var event = InputEventAction.new()
	event.action = input_action
	event.pressed = true
	Input.parse_input_event(event)
	released = false


func release():
	var event = InputEventAction.new()
	event.action = input_action
	event.pressed = false
	Input.parse_input_event(event)
	released = true


func is_in(pos:Vector2) -> bool:
	if int(pos.x) in range(global_position.x, global_position.x+size.x) :
		if int(pos.y) in range(global_position.y, global_position.y+size.y) :
			return true 
	return false

func _process(delta: float) -> void:
	if toggle_mode:
		if button_toggled: press()
		elif not button_toggled and is_pressed: release()
	

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and is_in(event.position) :
			is_pressed = true
			
			if toggle_mode:
				if not button_toggled: button_toggled = true
				else: button_toggled = false

			if released :
				touch_index = event.index
			if touch_index == event.index :
				press()
				
				
			else:
				if not toggle_mode:
					release()
				
	
		if touch_index == event.index and not event.pressed :
			if not toggle_mode:
				release()
			
			
