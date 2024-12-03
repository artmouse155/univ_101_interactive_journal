class_name JournalCard extends Control

@export var CardContent: MarginContainer
@export var TitleLabel: RichTextLabel
@export var SpeakerAndDateLabel: RichTextLabel
@export var SpeakerImage: TextureRect
@export var QuoteLabel: Label
@export var ThoughtsLabel: RichTextLabel
@export var QuestionsLabel: RichTextLabel
@export var ReadTalkButton: Button

@export var TileContent: MarginContainer
@export var TileSpeakerImage: TextureRect
@export var TileTitleLabel: RichTextLabel
@export var TileSpeakerAndDateLabel: RichTextLabel
@export var TileButton: Button

@export var MainPanel: Control
#@export var AnimPlayer: AnimationPlayer

var mode = "tile"

const TILE_SIZE = Vector2(400, 100)
const CARD_SIZE = Vector2(500, 600)
const ANIM_TIME = .4
const ANIM_TRANS = Tween.TRANS_ELASTIC

var original_position = Vector2i.ZERO
@onready var destination_position = (get_viewport_rect().size / 2) - (CARD_SIZE / 2)

var anim_tween

var page_number = 0

signal to_card(obj)
signal to_tile

func setup(entry: Entry, _original_position: Vector2, _page_number):
	original_position = _original_position
	position = original_position
	page_number = _page_number
	TitleLabel.text = "[font_size=24][b]" + entry.talk_name + "[/b][/font_size]"
	TitleLabel.owner = owner
	SpeakerAndDateLabel.text = entry.speaker_name + " | " + entry.get_date_as_string()
	SpeakerImage.texture = entry.img
	QuoteLabel.set_text_with_size("\"" + entry.quote + "\"", entry.quote_font_size)
	ThoughtsLabel.text = entry.thoughts
	QuestionsLabel.text = entry.questions
	ReadTalkButton.hyperlink = entry.hyperlink
	
	TileSpeakerImage.texture = entry.img
	TileTitleLabel.text = "[font_size=24][b]" + entry.talk_name + "[/b][/font_size]"
	TileSpeakerAndDateLabel.text = entry.speaker_name + " | " + entry.get_date_as_string()

func page_changed(num):
	visible = (num == page_number)
	#print("Visible: ", visible, " because ", num, " and ", page_number)

func tile_to_card():
	to_card.emit(self)
	z_index = 1
	mode = "card"
	TileContent.hide()
	CardContent.hide()
	#AnimPlayer.play("grow")
	
	if anim_tween:
		anim_tween.kill()
	anim_tween = create_tween()
	anim_tween.tween_property(MainPanel, "custom_minimum_size", CARD_SIZE, ANIM_TIME).set_trans(ANIM_TRANS)
	anim_tween.set_parallel(true)
	anim_tween.tween_property(MainPanel, "size", CARD_SIZE, ANIM_TIME).set_trans(ANIM_TRANS)
	anim_tween.tween_property(self, "global_position", destination_position, ANIM_TIME).set_trans(ANIM_TRANS)
	await anim_tween.finished
	
	#await AnimPlayer.animation_finished
	MainPanel.custom_minimum_size = CARD_SIZE
	MainPanel.size = CARD_SIZE
	TileContent.hide()
	CardContent.show()
	

func card_to_tile():
	to_tile.emit()
	TileContent.hide()
	CardContent.hide()
	
	if anim_tween:
		anim_tween.kill()
	anim_tween = create_tween()
	anim_tween.tween_property(MainPanel, "custom_minimum_size", TILE_SIZE, ANIM_TIME).set_trans(ANIM_TRANS)
	anim_tween.set_parallel(true)
	anim_tween.tween_property(MainPanel, "size", TILE_SIZE, ANIM_TIME).set_trans(ANIM_TRANS)
	anim_tween.tween_property(self, "position", original_position, ANIM_TIME).set_trans(ANIM_TRANS)
	await anim_tween.finished
	#AnimPlayer.play_backwards("grow")
	#await AnimPlayer.animation_finished
	MainPanel.custom_minimum_size = TILE_SIZE
	MainPanel.size = TILE_SIZE
	TileContent.show()
	CardContent.hide()
	
	
	z_index = 0
	mode = "tile"
	

func disable_tile(do_disable: bool):
	TileButton.disabled = do_disable
