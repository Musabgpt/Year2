extends Node2D

const WORLD_WIDTH := 1900.0
const FLOOR_Y := 425.0
const GRAVITY := 1450.0
const MOVE_SPEED := 300.0
const JUMP_SPEED := -590.0

var player_pos := Vector2(150, FLOOR_Y)
var player_velocity := Vector2.ZERO
var facing := 1.0
var on_floor := true
var camera_x := 0.0
var score := 0
var question_index := 0
var quiz_open := false
var feedback := ""
var feedback_timer := 0.0
var sound_enabled := true
var move_left := false
var move_right := false
var jump_requested := false
var questions := [
	{"subject":"MATHS", "question":"What is 24 + 13?", "answers":["27", "37", "47"], "correct":1, "hint":"Add 20 + 10, then 4 + 3."},
	{"subject":"ENGLISH", "question":"Which word is an adjective?", "answers":["quickly", "bright", "jump"], "correct":1, "hint":"An adjective describes a person, place or thing."},
	{"subject":"SCIENCE", "question":"Which material is magnetic?", "answers":["wood", "plastic", "iron"], "correct":2, "hint":"Magnets attract some metals."},
	{"subject":"MATHS", "question":"What is half of 18?", "answers":["8", "9", "10"], "correct":1, "hint":"Split 18 into two equal groups."}
]
var ui_layer: CanvasLayer
var score_label: Label
var status_label: Label
var question_panel: PanelContainer
var question_label: Label
var hint_label: Label
var answer_buttons: Array[Button] = []
var sound_button: Button

func _ready() -> void:
	_build_ui()
	queue_redraw()

func _process(delta: float) -> void:
	if feedback_timer > 0.0:
		feedback_timer -= delta
		if feedback_timer <= 0.0:
			feedback = ""
	if not quiz_open:
		var direction := 0.0
		if move_left or Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
			direction -= 1.0
		if move_right or Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
			direction += 1.0
		if direction != 0.0:
			facing = sign(direction)
			player_velocity.x = direction * MOVE_SPEED
		else:
			player_velocity.x = move_toward(player_velocity.x, 0.0, MOVE_SPEED * 5.0 * delta)
		if jump_requested or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_UP):
			if on_floor:
				player_velocity.y = JUMP_SPEED
				on_floor = false
				_play_tone(660.0, 0.09)
			jump_requested = false
		if not on_floor:
			player_velocity.y += GRAVITY * delta
		player_pos += player_velocity * delta
		player_pos.x = clampf(player_pos.x, 55.0, WORLD_WIDTH - 55.0)
		if player_pos.y >= FLOOR_Y:
			player_pos.y = FLOOR_Y
			player_velocity.y = 0.0
			on_floor = true
		camera_x = clampf(player_pos.x - get_viewport_rect().size.x * 0.38, 0.0, WORLD_WIDTH - get_viewport_rect().size.x)
		if player_pos.x > 720.0 and not quiz_open:
			_open_quiz()
	score_label.text = "⭐ %03d" % score
	status_label.text = "Explore the academy  •  Find the glowing learning gate" if not quiz_open else "Learning challenge"
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE and quiz_open:
			_close_quiz()

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color("#101b36"))
	# Soft sky and distant hills.
	draw_rect(Rect2(Vector2(0, 0), Vector2(view.x, 310)), Color("#172c50"))
	for i in range(8):
		var x := fposmod(float(i * 260) - camera_x * 0.28, view.x + 260.0) - 130.0
		draw_circle(Vector2(x, 115 + (i % 3) * 24), 44 + (i % 2) * 15, Color("#24456b"))
	# Floating stars.
	for i in range(24):
		var sx := fposmod(float(i * 173 + 40) - camera_x * 0.08, view.x)
		var sy := 25.0 + float((i * 37) % 170)
		draw_circle(Vector2(sx, sy), 2.2, Color("#f7d98a"))
	# Academy buildings.
	for bx in [100.0, 500.0, 1020.0, 1510.0]:
		var x := bx - camera_x
		if x > -240 and x < view.x + 240:
			draw_rect(Rect2(x, 210, 230, 220), Color("#304d70"))
			draw_rect(Rect2(x - 12, 195, 254, 25), Color("#f1bd66"))
			draw_colored_polygon(PackedVector2Array([Vector2(x - 15, 210), Vector2(x + 115, 135), Vector2(x + 245, 210)]), Color("#b85f64"))
			for wx in range(3):
				draw_rect(Rect2(x + 22 + wx * 68, 250, 35, 48), Color("#8fe0ed"))
				draw_rect(Rect2(x + 22 + wx * 68, 250, 35, 5), Color("#d6fbff"))
			draw_rect(Rect2(x + 90, 340, 48, 90), Color("#f0c27a"))
	# Ground, path and stepping stones.
	draw_rect(Rect2(0, FLOOR_Y + 3, view.x, view.y - FLOOR_Y), Color("#214c4c"))
	draw_rect(Rect2(0, FLOOR_Y + 3, view.x, 18), Color("#65c68a"))
	for i in range(13):
		var px := fposmod(float(i * 170) - camera_x, view.x + 170.0) - 80.0
		draw_round_rect(Rect2(px, FLOOR_Y + 28, 92, 18), 8, Color("#38716b"))
	# Learning gate.
	var gate_x := 790.0 - camera_x
	if gate_x > -100 and gate_x < view.x + 100:
		draw_rect(Rect2(gate_x - 8, 290, 112, 142), Color("#f6c85f"), false, 7)
		draw_rect(Rect2(gate_x + 10, 308, 76, 124), Color("#6e4b91"))
		draw_circle(Vector2(gate_x + 48, 330), 12, Color("#f8e6a3"))
		draw_string(ThemeDB.fallback_font, Vector2(gate_x - 14, 276), "LEARN", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("#ffe6a1"))
	# Player character with animated bob.
	var p := Vector2(player_pos.x - camera_x, player_pos.y)
	var bob := 0.0 if on_floor else sin(Time.get_ticks_msec() * 0.012) * 3.0
	draw_circle(p + Vector2(0, -44 + bob), 18, Color("#f5c9a4"))
	draw_arc(p + Vector2(0, -44 + bob), 18, PI, TAU, 16, Color("#392d45"), 5)
	draw_rect(Rect2(p.x - 15, p.y - 27 + bob, 30, 32), Color("#f6a64b"))
	draw_rect(Rect2(p.x - 15, p.y - 6 + bob, 30, 11), Color("#f4d36c"))
	draw_circle(p + Vector2(6 * facing, -46 + bob), 2.8, Color("#202a44"))
	draw_line(p + Vector2(-8, 3), p + Vector2(-11, 13), Color("#e5e9f5"), 6)
	draw_line(p + Vector2(8, 3), p + Vector2(11, 13), Color("#e5e9f5"), 6)
	# Prompt and transient feedback.
	if not quiz_open and player_pos.x < 720:
		draw_string(ThemeDB.fallback_font, Vector2(24, 130), "WELCOME, EXPLORER!", HORIZONTAL_ALIGNMENT_LEFT, -1, 23, Color("#ffe7a2"))
		draw_string(ThemeDB.fallback_font, Vector2(24, 160), "Move right to discover your first learning gate.", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("#d6e7ff"))
	if feedback != "":
		draw_string(ThemeDB.fallback_font, Vector2(view.x * 0.5 - 90, 205), feedback, HORIZONTAL_ALIGNMENT_CENTER, 260, 24, Color("#ffe7a2"))

func _build_ui() -> void:
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_layer.add_child(root)
	score_label = Label.new()
	score_label.position = Vector2(20, 16)
	score_label.add_theme_font_size_override("font_size", 23)
	score_label.add_theme_color_override("font_color", Color("#ffe6a1"))
	root.add_child(score_label)
	status_label = Label.new()
	status_label.position = Vector2(20, 52)
	status_label.add_theme_font_size_override("font_size", 15)
	status_label.add_theme_color_override("font_color", Color("#d7e8ff"))
	root.add_child(status_label)
	sound_button = Button.new()
	sound_button.text = "♪ SOUND ON"
	sound_button.position = Vector2(790, 16)
	sound_button.size = Vector2(150, 42)
	sound_button.pressed.connect(_toggle_sound)
	root.add_child(sound_button)
	# Large touch controls, also usable with a mouse in desktop testing.
	var left := _make_button(root, "◀", Vector2(22, 438), Vector2(78, 78))
	left.button_down.connect(func(): move_left = true)
	left.button_up.connect(func(): move_left = false)
	var right := _make_button(root, "▶", Vector2(108, 438), Vector2(78, 78))
	right.button_down.connect(func(): move_right = true)
	right.button_up.connect(func(): move_right = false)
	var jump := _make_button(root, "JUMP", Vector2(790, 426), Vector2(150, 90))
	jump.button_down.connect(func(): jump_requested = true)
	question_panel = PanelContainer.new()
	question_panel.set_anchors_preset(Control.PRESET_CENTER)
	question_panel.position = Vector2(-245, -165)
	question_panel.size = Vector2(490, 330)
	question_panel.visible = false
	root.add_child(question_panel)
	var panel_box := VBoxContainer.new()
	panel_box.add_theme_constant_override("separation", 12)
	question_panel.add_child(panel_box)
	var title := Label.new()
	title.text = "ACADEMY CHALLENGE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color("#5e3f90"))
	panel_box.add_child(title)
	question_label = Label.new()
	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	question_label.add_theme_font_size_override("font_size", 21)
	panel_box.add_child(question_label)
	hint_label = Label.new()
	hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.add_theme_color_override("font_color", Color("#536b83"))
	panel_box.add_child(hint_label)
	answer_buttons.clear()
	for i in range(3):
		var answer_button := Button.new()
		answer_button.custom_minimum_size = Vector2(0, 43)
		answer_button.add_theme_font_size_override("font_size", 18)
		answer_button.pressed.connect(_answer.bind(i))
		panel_box.add_child(answer_button)
		answer_buttons.append(answer_button)
	var close_button := Button.new()
	close_button.text = "Back to exploring"
	close_button.pressed.connect(_close_quiz)
	panel_box.add_child(close_button)

func _make_button(parent: Control, text_value: String, at: Vector2, dimensions: Vector2) -> Button:
	var button := Button.new()
	button.text = text_value
	button.position = at
	button.size = dimensions
	button.add_theme_font_size_override("font_size", 25)
	parent.add_child(button)
	return button

func _open_quiz() -> void:
	if quiz_open:
		return
	quiz_open = true
	player_velocity = Vector2.ZERO
	question_panel.visible = true
	_show_question()
	_play_tone(520.0, 0.12)

func _show_question() -> void:
	var q: Dictionary = questions[question_index % questions.size()]
	question_label.text = str(q["question"])
	hint_label.text = "Hint: " + str(q["hint"])
	for i in range(answer_buttons.size()):
		answer_buttons[i].text = str(q["answers"][i])
		answer_buttons[i].disabled = false

func _answer(index: int) -> void:
	var q: Dictionary = questions[question_index % questions.size()]
	if index == int(q["correct"]):
		score += 10
		feedback = "Brilliant! +10 stars"
		_play_tone(880.0, 0.18)
	else:
		feedback = "Not yet! Try another answer."
		_play_tone(190.0, 0.18)
	feedback_timer = 1.6
	question_index += 1
	_show_question()

func _close_quiz() -> void:
	quiz_open = false
	question_panel.visible = false
	player_pos.x = maxf(player_pos.x, 730.0)

func _toggle_sound() -> void:
	sound_enabled = not sound_enabled
	sound_button.text = "♪ SOUND ON" if sound_enabled else "♪ SOUND OFF"

func _play_tone(frequency: float, duration: float) -> void:
	if not sound_enabled:
		return
	# Placeholder until platform TTS/audio assets are integrated; keep gameplay independent.
	# This deliberately avoids claiming spoken questions are implemented.
	pass
