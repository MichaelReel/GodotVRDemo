extends Spatial

const freq = 0.2
const button_limit = 16

export (bool) var enabled = false

var controller : ARVRController
var acc : float
var buttons : int

func _ready():
	controller = get_parent()
	acc = 0.0
	buttons = 0

func _process(delta):
	if not enabled:
		return
	acc += delta
	for i in range(button_limit):
		if controller.is_button_pressed(i):
			buttons |= 1 << i
	if acc > freq:
		acc -= freq
		var out = ""
		for i in range(button_limit):
			out = ("1" if buttons & (1 << i) > 0 else "0") + out
		print (out)
		buttons = 0
