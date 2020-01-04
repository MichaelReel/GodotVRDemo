extends Spatial

const freq = 0.2
const button_limit = 17

export (bool) var enabled = false

var controller : ARVRController
var acc : float
var action : bool
var buttons : int
var joystick : String
var prefix : String

func _ready():
	controller = get_parent()
	acc = 0.0
	buttons = 0
	prefix = " " + str(controller.controller_id) + ", " + str(controller.get_is_active())

func _process(delta):
	if not enabled:
		return
	acc += delta
	
	for i in range(button_limit):
		if controller.is_button_pressed(i):
			buttons |= 1 << i
			action = true
			
	if controller.get_joystick_axis(0) or controller.get_joystick_axis(1):
		joystick = "(" + str(controller.get_joystick_axis(0)) + "," + str(controller.get_joystick_axis(1)) + ")"
		action = true
			
	if acc > freq:
		acc -= freq
		
		if not action:
			return
		
		var out = prefix + ": "
		for i in range(button_limit):
			out = ("1" if buttons & (1 << i) > 0 else "0") + out
		out += joystick
		
		# How to get hand position info? - Parent transform?
		out += " " + str(controller.translation)
		
		print (out)
		buttons = 0
		action = false
		joystick = "(0,0)"
