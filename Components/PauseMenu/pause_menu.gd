extends Control

onready var tree = get_tree()

onready var crosshair = $Crosshair
onready var pause = $Pause
onready var voxel_world = $"../World"


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause.visible = crosshair.visible
		crosshair.visible = !crosshair.visible
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if crosshair.visible else Input.MOUSE_MODE_VISIBLE)


func _on_Resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crosshair.visible = true
	pause.visible = false


func _on_Exit_pressed():
	voxel_world.clean_up()
	tree.quit()
