extends Button

var hyperlink: String = "about:blank"

func _on_pressed():
	OS.shell_open(hyperlink)# Replace with function body.
