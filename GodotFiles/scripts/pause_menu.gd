extends Control

onready var _menu_options = get_node("MenuOptions") as VBoxContainer
export(String, FILE, "*.tscn") var _main_menu_path

var _selector : int = 0
var _MAX_MENU : int = 1
var _MIN_MENU : int = 0
var _current_label : Label

func _ready():
	self._current_label = self._menu_options.get_child(self._selector) as Label
	self._current_label.add_color_override("font_color", Color(0,0,0))

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		self._current_label.add_color_override("font_color", Color(1,1,1))
		if self._MIN_MENU != _selector:
			self._selector -= 1
	elif Input.is_action_just_pressed("ui_down"):
		self._current_label.add_color_override("font_color", Color(1,1,1))
		if self._MAX_MENU != _selector:
			self._selector += 1
	elif Input.is_action_just_pressed("ui_accept"):
		ui_accept()
	self._current_label = self._menu_options.get_child(self._selector) as Label
	self._current_label.add_color_override("font_color", Color(0,0,0))

# This function completes and action depending on where the current _selector
# variables is pointing to. In this case it resumes the game or goes to the main menu.
func ui_accept() -> void:
	if self._selector == 0:
		get_tree().paused = false
		self.visible = false
	elif self._selector == 1:
		get_tree().paused = false
		get_tree().change_scene(self._main_menu_path)

