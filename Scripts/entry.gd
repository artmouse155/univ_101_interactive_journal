class_name Entry extends Resource

var id: String = ""
var talk_name: String = ""
var speaker_name: String = ""
var img: CompressedTexture2D
var hyperlink: String = ""
var quote: String = ""
var quote_font_size: String = ""
var day: String = ""
var month: String = ""
var year: String = ""
var questions: String = ""
var thoughts: String = ""

#static var img_path_base: String = "res://Assets/Textures/Speakers/"
static var img_backup: CompressedTexture2D = preload("res://Assets/Textures/Speakers/blank.png")

static var img_dict = {
	"kimball.png" : preload("res://Assets/Textures/Speakers/kimball.png"),
	"berman.jpg" : preload("res://Assets/Textures/Speakers/berman.jpg"),
	"nelson.png" : preload("res://Assets/Textures/Speakers/nelson.png"),
	"worthen.jpg" : preload("res://Assets/Textures/Speakers/worthen.jpg"),
	"patricia_holland.jpg" : preload("res://Assets/Textures/Speakers/patricia_holland.jpg"),
	"eyring.jpg" : preload("res://Assets/Textures/Speakers/eyring.jpg")
}

static func parse_entries(_entries_list):
	var _entries_obj_list = []
	for dict in _entries_list:
		_entries_obj_list.append(parse_entry(dict))
	return _entries_obj_list

static func parse_entry(dict):
	var some_entry = Entry.new()
	some_entry.id= dict["ID"]
	some_entry.talk_name= dict["TALK_NAME"]
	some_entry.speaker_name= dict["SPEAKER_NAME"]
	if dict["IMG_PATH"] in img_dict.keys():
		some_entry.img = img_dict[dict["IMG_PATH"]]
	else:
		some_entry.img = img_backup
	some_entry.hyperlink= dict["HYPERLINK"]
	some_entry.quote= dict["QUOTE"]
	some_entry.quote_font_size = str(dict["QUOTE_FONT_SIZE"])
	some_entry.day= str(dict["DAY"])
	some_entry.month= dict["MONTH"]
	some_entry.year= str(dict["YEAR"])
	some_entry.questions= dict["QUESTIONS"].replace("^", "\n")
	some_entry.thoughts= dict["THOUGHTS"]
	return some_entry

func get_date_as_string():
	return self.month + " " + self.day + ", " + self.year
