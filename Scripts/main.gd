extends Control

@export var card_scene: PackedScene
@export var radio_button_scene: PackedScene
@export var ButtonContainer: Container
@export var BookContainer: Control

@export var Blur: Control

const BLUR_AMT = 3.0
const BLUR_ANIM_TIME = .4

const TILE_SPACING = 20
const PAGE_SIZE = 4
var STARTING_POINT = Vector2(20,20)

var current_page_number = 0
var max_page_number = 0

signal page_changed(page_number)
signal disable_tiles(do_disable)

var blur_tween

@export var setup_complete: bool

func parse_json(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	var json_string = file.get_as_text()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			#print(data_received) # Prints array
			return data_received
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	return null



func _ready():
	if not setup_complete:
		setup()
		
func setup():
	var entries_json_text = parse_json("res://Resources/interactive_journal.json")
	var journal_entries = Entry.parse_entries(entries_json_text)
	var page_number = 0
	for i in range(len(journal_entries)):
		var entry = journal_entries[i]
		page_number = floor(i / PAGE_SIZE)
		var entry_number_mod = i % PAGE_SIZE
		var card_pos = STARTING_POINT + (entry_number_mod * (JournalCard.TILE_SIZE.y + TILE_SPACING)) * Vector2.DOWN
		print(card_pos)
		var card = card_scene.instantiate()
		page_changed.connect(card.page_changed)
		disable_tiles.connect(card.disable_tile)
		card.to_card.connect(send_tile_signal.bind(true))
		card.to_card.connect(show_blur)
		card.to_tile.connect(send_tile_signal.bind(null, false))
		card.to_tile.connect(hide_blur)
		BookContainer.add_child(card)
		card.set_owner(self)
		card.setup(entry, card_pos, page_number)
		if page_number != current_page_number:
			card.hide()
	max_page_number = page_number
	#var button_group = ButtonGroup.new()
	for i in range(max_page_number + 1):
		var button = radio_button_scene.instantiate()
		button.button_pressed = (i == current_page_number)
		#button.button_group = button_group
		ButtonContainer.add_child(button)
		button.set_owner(self)
		button.pressed.connect(change_page.bind(i))
		
	page_changed.emit(0)
	setup_complete = true
	#var packed_scene = PackedScene.new()
	#packed_scene.pack(get_tree().get_current_scene())
	#ResourceSaver.save(packed_scene, "res://Scenes/main_prefab.tscn")

func change_page(page_num: int):
	current_page_number = page_num
	page_changed.emit(page_num)

func send_tile_signal(node: Node, do_disable: bool):
	if node:
		BookContainer.move_child(node, BookContainer.get_child_count() - 1)
	disable_tiles.emit(do_disable)

func show_blur(_card):
	if blur_tween:
		blur_tween.kill()
	blur_tween = create_tween()
	Blur.show()
	blur_tween.tween_method(Blur.set_blur, 0.0, BLUR_AMT, BLUR_ANIM_TIME).set_trans(Tween.TRANS_SINE)
	
	
func hide_blur():
	if blur_tween:
		blur_tween.kill()
	blur_tween = create_tween()
	blur_tween.tween_method(Blur.set_blur, BLUR_AMT, 0.0, BLUR_ANIM_TIME).set_trans(Tween.TRANS_SINE)	
	blur_tween.tween_callback(Blur.hide)

func quit_game():
	get_tree().quit()
