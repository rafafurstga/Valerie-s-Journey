extends CanvasLayer

func _ready():
	if OS.get_name() in ["Android", "iOS"]:
		visible = true
	else:
		visible = false
