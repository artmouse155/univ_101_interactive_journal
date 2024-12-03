extends Label

const MIN_LABEL_SIZE = 16

func set_text_with_size(quote, f_size):
	label_settings.font_size = int(f_size)
	text = quote
	

func set_resizeable_text(_text) -> void:
	
	# Adjust name's font size to fit within the allowed width.
	#var width = size.x
	#var height = size.y
	label_settings.font_size = 24
	#while label_settings.font.get_multiline_string_size(text, horizontal_alignment, width, label_settings.font_size).y > height:
	set_text(_text)
	await draw
	while (get_visible_line_count() < get_line_count()) and (label_settings.font_size > MIN_LABEL_SIZE):
		label_settings.font_size -= 1
		await draw
	print(get_line_count())
	print(get_visible_line_count())
	print("🍌",label_settings.font_size)
	#await get_tree().create_timer(1).timeout
	#print(get_line_count())
	#print(get_visible_line_count())
