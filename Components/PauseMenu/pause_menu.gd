extends Control

onready var tree = get_tree()

onready var crosshair = $Crosshair
onready var pause = $Network
onready var world = get_node("/root/World")

func _ready():
	show_menu()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		show_menu()
		
func show_menu():
	world.paused = true
	pause.visible = true
	crosshair.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if crosshair.visible else Input.MOUSE_MODE_VISIBLE)


func hide_menu():
	world.paused = false
	pause.visible = false
	crosshair.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_Resume_pressed():
	hide_menu()

func _on_Exit_pressed():
	world.clean_up()
	tree.quit()

func _on_Quit_pressed():
	_on_Exit_pressed()

func _on_ServerBtn_pressed():
	world.start_server($Network/Nickname)
	$Label.text = "SERVER"
	hide_menu()

func _on_ClientBtn_pressed():
	world.start_client($Network/Nickname, $Network/IP)
	$Label.text = "CLIENT"
	hide_menu()
