extends CanvasLayer




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$stam.text = str($"../player".stamcounter)
