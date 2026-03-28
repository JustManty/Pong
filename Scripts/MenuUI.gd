class_name MenuUI
extends CanvasLayer

@onready var resume: PanelContainer = $MenuContainer/MenuOptions/Resume
@onready var new_game: PanelContainer = $"MenuContainer/MenuOptions/New Game"
@onready var quit_game: PanelContainer = $"MenuContainer/MenuOptions/Quit Game"
@onready var blip_sound: AudioStreamPlayer = $BlipSound

enum MenuOption {RESUME, NEW_GAME, QUIT_GAME}

var selected : MenuOption = MenuOption.NEW_GAME
var _game_started = false

signal game_resumed()
signal game_reset()

func set_state(game_started: bool) -> void:
	_game_started = game_started

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if _game_started:
		resume.visible = true
		selected = MenuOption.RESUME	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		_select_next()
	elif Input.is_action_just_pressed("ui_up"):
		_select_previous()
	elif Input.is_action_just_pressed("ui_select"):
		_select_current()
	
	_update_ui()

func _select_next() -> void:
	if selected == MenuOption.RESUME:
		selected = MenuOption.NEW_GAME
	elif selected == MenuOption.NEW_GAME:
		selected = MenuOption.QUIT_GAME
	else:
		if _game_started:
			selected = MenuOption.RESUME
		else:
			selected = MenuOption.NEW_GAME
	blip_sound.play()

func _select_previous() -> void:
	if selected == MenuOption.RESUME:
		selected = MenuOption.QUIT_GAME
	elif selected == MenuOption.NEW_GAME:
		if _game_started:
			selected = MenuOption.RESUME
		else:
			selected = MenuOption.QUIT_GAME
	else:
		selected = MenuOption.NEW_GAME
	blip_sound.play()

func _select_current() -> void:
	if selected == MenuOption.RESUME:
		blip_sound.play()
		_resume()
	elif selected == MenuOption.NEW_GAME:
		blip_sound.play()
		_new_game()
	else:
		_quit_game()

func _resume() -> void:
	game_resumed.emit()

func _new_game() -> void:
	game_reset.emit()

func _quit_game() -> void:
	get_tree().quit()

func _update_ui() -> void:
	if selected == MenuOption.RESUME:
		(resume.get_node("ColorRect") as ColorRect).color = Color.WHITE
		(resume.get_node("Label") as Label).label_settings.font_color = Color.BLACK
	else:
		(resume.get_node("ColorRect") as ColorRect).color = Color.BLACK
		(resume.get_node("Label") as Label).label_settings.font_color = Color.WHITE
	if selected == MenuOption.NEW_GAME:
		(new_game.get_node("ColorRect") as ColorRect).color = Color.WHITE
		(new_game.get_node("Label") as Label).label_settings.font_color = Color.BLACK
	else:
		(new_game.get_node("ColorRect") as ColorRect).color = Color.BLACK
		(new_game.get_node("Label") as Label).label_settings.font_color = Color.WHITE
	if selected == MenuOption.QUIT_GAME:
		(quit_game.get_node("ColorRect") as ColorRect).color = Color.WHITE
		(quit_game.get_node("Label") as Label).label_settings.font_color = Color.BLACK
	else:
		(quit_game.get_node("ColorRect") as ColorRect).color = Color.BLACK
		(quit_game.get_node("Label") as Label).label_settings.font_color = Color.WHITE
