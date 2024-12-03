@tool

class_name ResizableLabel extends Label

@export var max_size = 36
@export var min_size = 12

@export_tool_button("Adjust Size!", "ColorRect") var adj_action = adjust

func adjust():
	set_resizeable_text(text)
	
func set_resizeable_text(_text) -> void:
	
	# Adjust name's font size to fit within the allowed width.
	#var width = size.x
	#var height = size.y
	label_settings.font_size = max_size
	#while label_settings.font.get_multiline_string_size(text, horizontal_alignment, width, label_settings.font_size).y > height:
	set_text(_text)
	await draw
	while (get_visible_line_count() < get_line_count()) and (label_settings.font_size > min_size):
		label_settings.font_size -= 1
		await draw
	print(get_line_count())
	print(get_visible_line_count())
	print("🍌",label_settings.font_size)
