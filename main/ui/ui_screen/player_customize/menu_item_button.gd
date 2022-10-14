extends Button
class_name ItemButton

export var item_name: String
export var item_description: String
export var price: int

export var item_max := 0

var purchased := false

func _ready() -> void:
	connect("button_down", self, "_on_button_down")

func _on_button_down() -> void:
	purchase()

func initialize() -> void:
	if purchased:
		$Label.text = "BOUGHT"
	else:
		$Label.text = str(price)

func purchase() -> void:
	purchased = true
	$Label.text = "BOUGHT"
	
	GlobalData.items[item_name] = true

func save_file(dict: Dictionary) -> void:
	pass # This button doesn't actually save data, only loads it

func load_file(dict: Dictionary) -> void:
	if item_name in dict.items:
		purchase()
