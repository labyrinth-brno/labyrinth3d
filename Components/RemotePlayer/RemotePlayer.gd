extends Spatial

var target_position: Vector3 = Vector3()

func _ready():
	set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	if target_position != Vector3():
#		translate(target_position - translation)	
#		target_position = Vector3()
