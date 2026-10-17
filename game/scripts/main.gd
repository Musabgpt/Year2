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
var gate_triggered := false
var feedback := ""
var feedback_timer := 0.0
var correct_streak := 0
var last_voice_text := ""
var hint_revealed := false
var sound_enabled := true
var move_left := false
var move_right := false
var jump_requested := false
var questions: Array[Dictionary] = Year2CurriculumBank.all_questions()
var answered_current := false
var question_order: Array[int] = []

var ui_layer: CanvasLayer
var score_label: Label
var status_label: Label
var question_panel: PanelContainer
var question_label: Label
var hint_label: Label
var explanation_label: Label
var next_button: Button
var curriculum_label: Label
var progress_label: Label
var hint_button: Button
var read_button: Button
var practice_button: Button
var answer_buttons: Array[Button] = []
var sound_button: Button
var voice_button: Button
var speech_enabled := true
var audio_player: AudioStreamPlayer
var audio_playback: AudioStreamGeneratorPlayback
var ai_client: Node
var ai_status := ""
const AUDIO_SAMPLE_RATE := 22050

func _ready() -> void:
	ai_client = load("res://scripts/ai/musab_ai.gd").new()
	add_child(ai_client)
	ai_client.question_ready.connect(_on_ai_question_ready)
	ai_client.status_changed.connect(_on_ai_status_changed)
	_load_progress()
	_build_ui()
	_prepare_question_order()
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
		if player_pos.x > 720.0 and not quiz_open and not gate_triggered:
			gate_triggered = true
			_open_quiz()
	score_label.text = "⭐ %03d" % score
	status_label.text = ai_status if ai_status != "" else ("Explore the academy  •  Find the glowing learning gate" if not quiz_open else "Learning challenge")
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
		var x: float = float(bx) - camera_x
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
		draw_rect(Rect2(px, FLOOR_Y + 28, 92, 18), Color("#38716b"))
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
	audio_player = AudioStreamPlayer.new()
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = AUDIO_SAMPLE_RATE
	generator.buffer_length = 0.25
	audio_player.stream = generator
	add_child(audio_player)
	audio_player.play()
	audio_playback = audio_player.get_stream_playback() as AudioStreamGeneratorPlayback
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
	voice_button = Button.new()
	voice_button.text = "VOICE ON"
	voice_button.position = Vector2(620, 16)
	voice_button.size = Vector2(150, 42)
	voice_button.pressed.connect(_toggle_speech)
	root.add_child(voice_button)
	practice_button = Button.new()
	practice_button.text = "🎯 PRACTICE"
	practice_button.position = Vector2(450, 16)
	practice_button.size = Vector2(150, 42)
	practice_button.pressed.connect(_open_quiz)
	root.add_child(practice_button)
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
	question_panel.position = Vector2(-270, -250)
	question_panel.size = Vector2(540, 500)
	question_panel.custom_minimum_size = Vector2(540, 500)
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#fffaf0")
	panel_style.border_color = Color("#f5c76b")
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(24)
	panel_style.content_margin_left = 20
	panel_style.content_margin_right = 20
	panel_style.content_margin_top = 16
	panel_style.content_margin_bottom = 16
	question_panel.add_theme_stylebox_override("panel", panel_style)
	question_panel.visible = false
	root.add_child(question_panel)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	question_panel.add_child(scroll)
	var panel_box := VBoxContainer.new()
	panel_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_box.add_theme_constant_override("separation", 6)
	scroll.add_child(panel_box)
	var title := Label.new()
	title.text = "🌟 LEARNING QUEST"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 25)
	title.add_theme_color_override("font_color", Color("#51327c"))
	panel_box.add_child(title)
	curriculum_label = Label.new()
	curriculum_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	curriculum_label.add_theme_font_size_override("font_size", 13)
	curriculum_label.add_theme_color_override("font_color", Color("#536b83"))
	panel_box.add_child(curriculum_label)
	progress_label = Label.new()
	progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	progress_label.add_theme_font_size_override("font_size", 13)
	progress_label.add_theme_color_override("font_color", Color("#92612b"))
	panel_box.add_child(progress_label)
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
	var utility_row := HBoxContainer.new()
	utility_row.alignment = BoxContainer.ALIGNMENT_CENTER
	utility_row.add_theme_constant_override("separation", 10)
	panel_box.add_child(utility_row)
	hint_button = Button.new()
	hint_button.text = "💡 Show hint"
	hint_button.custom_minimum_size = Vector2(145, 38)
	hint_button.pressed.connect(_reveal_hint)
	utility_row.add_child(hint_button)
	read_button = Button.new()
	read_button.text = "🔊 Read aloud"
	read_button.custom_minimum_size = Vector2(145, 38)
	read_button.pressed.connect(_read_current_question)
	utility_row.add_child(read_button)
	explanation_label = Label.new()
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	explanation_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	explanation_label.add_theme_font_size_override("font_size", 16)
	explanation_label.add_theme_color_override("font_color", Color("#245b49"))
	explanation_label.visible = false
	panel_box.add_child(explanation_label)
	answer_buttons.clear()
	for i in range(3):
		var answer_button := Button.new()
		answer_button.custom_minimum_size = Vector2(0, 47)
		answer_button.add_theme_font_size_override("font_size", 18)
		var answer_style := StyleBoxFlat.new()
		answer_style.bg_color = Color("#e8f2ff")
		answer_style.border_color = Color("#a8c8ee")
		answer_style.set_border_width_all(2)
		answer_style.set_corner_radius_all(13)
		answer_button.add_theme_stylebox_override("normal", answer_style)
		var answer_hover := answer_style.duplicate() as StyleBoxFlat
		answer_hover.bg_color = Color("#d3e6ff")
		answer_button.add_theme_stylebox_override("hover", answer_hover)
		answer_button.pressed.connect(_answer.bind(i))
		panel_box.add_child(answer_button)
		answer_buttons.append(answer_button)
	next_button = Button.new()
	next_button.text = "Next question ➜"
	next_button.custom_minimum_size = Vector2(0, 43)
	next_button.visible = false
	next_button.pressed.connect(_next_question)
	panel_box.add_child(next_button)
	var close_button := Button.new()
	close_button.text = "Back to exploring"
	close_button.pressed.connect(_close_quiz)
	panel_box.add_child(close_button)
	var ai_button := Button.new()
	ai_button.text = "✨ Ask MusabAI for a new question"
	ai_button.custom_minimum_size = Vector2(0, 43)
	ai_button.pressed.connect(_request_ai_question)
	panel_box.add_child(ai_button)

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

func _prepare_question_order() -> void:
	question_order.clear()
	for i in range(questions.size()):
		question_order.append(i)
	question_order.shuffle()
	question_index = clampi(question_index, 0, maxi(0, question_order.size() - 1))

func _current_question() -> Dictionary:
	if questions.is_empty():
		return {}
	if question_order.is_empty():
		_prepare_question_order()
	return questions[question_order[question_index % question_order.size()]]

func _show_question() -> void:
	if questions.is_empty():
		question_label.text = "Let's create your first learning question!"
		hint_label.text = "Connect MusabAI or add questions to the curriculum bank."
		return
	var q := _current_question()
	answered_current = false
	hint_revealed = false
	next_button.visible = true
	next_button.text = "Skip / next ➜"
	explanation_label.visible = false
	hint_button.text = "💡 Show hint"
	curriculum_label.text = str(q.get("subject", "LEARNING")) + "  •  " + str(q.get("strand", "Practice"))
	progress_label.text = "Question %d of %d     ⭐ %d     🔥 %d in a row" % [question_index + 1, questions.size(), score, correct_streak]
	question_label.text = str(q["question"])
	hint_label.text = "Choose an answer, then learn why."
	for i in range(answer_buttons.size()):
		answer_buttons[i].text = str(q["answers"][i])
		answer_buttons[i].disabled = false
		answer_buttons[i].modulate = Color.WHITE
	_read_current_question()

func _answer(index: int) -> void:
	if answered_current:
		return
	var q := _current_question()
	if index == int(q["correct"]):
		answered_current = true
		correct_streak += 1
		score += 10
		feedback = "Brilliant! +10 stars"
		hint_label.text = "Correct! You got it!"
		explanation_label.text = "Why? " + str(q.get("explanation", q.get("hint", "Well done for thinking carefully.")))
		explanation_label.visible = true
		next_button.visible = true
		next_button.text = "Next question ➜"
		for i in range(answer_buttons.size()):
			answer_buttons[i].disabled = true
			if i == int(q["correct"]):
				answer_buttons[i].modulate = Color("#a8edc3")
		progress_label.text = "Correct! ⭐ %d points     🔥 %d in a row" % [score, correct_streak]
		_play_tone(880.0, 0.18)
		feedback_timer = 1.6
		_speak_text("Correct! " + str(q.get("explanation", "Well done!")))
		_save_progress()
	else:
		correct_streak = 0
		answer_buttons[index].modulate = Color("#ffd2ce")
		feedback = "Nearly! Have another go."
		hint_label.text = "Not quite yet. Tap Show hint, then try again."
		_play_tone(190.0, 0.18)
		feedback_timer = 1.6
		_speak_text("Not quite. " + str(q.get("hint", "Try another answer.")))

func _reveal_hint() -> void:
	var q := _current_question()
	hint_revealed = true
	hint_label.text = "💡 Hint: " + str(q.get("hint", "Take your time and look for a clue."))
	hint_button.text = "💡 Hint shown"
	_speak_text("Here is a hint. " + str(q.get("hint", "Think carefully.")))

func _read_current_question() -> void:
	if questions.is_empty():
		return
	var q := _current_question()
	last_voice_text = str(q.get("question", ""))
	last_voice_text += " The answer choices are: " + str(q["answers"][0]) + ", " + str(q["answers"][1]) + ", or " + str(q["answers"][2]) + "."
	_speak_text(last_voice_text)

func _next_question() -> void:
	# Children can move on after trying, without getting trapped on one question.
	question_index += 1
	if question_index >= question_order.size():
		question_index = 0
		question_order.shuffle()
	_save_progress()
	_show_question()

func _close_quiz() -> void:
	quiz_open = false
	question_panel.visible = false
	gate_triggered = true
	player_pos.x = maxf(player_pos.x, 850.0)

func _toggle_sound() -> void:
	sound_enabled = not sound_enabled
	sound_button.text = "♪ SOUND ON" if sound_enabled else "♪ SOUND OFF"

func _play_tone(frequency: float, duration: float) -> void:
	if not sound_enabled:
		return
	var frame_count := int(AUDIO_SAMPLE_RATE * duration)
	var pcm := PackedByteArray()
	pcm.resize(frame_count * 2)
	for i in range(frame_count):
		var progress := float(i) / maxf(1.0, float(frame_count))
		var envelope := minf(1.0, progress * 18.0) * (1.0 - progress) * 0.25
		var sample_value := int(clampf(sin(TAU * frequency * float(i) / float(AUDIO_SAMPLE_RATE)) * envelope, -1.0, 1.0) * 32767.0)
		pcm[i * 2] = sample_value & 0xff
		pcm[i * 2 + 1] = (sample_value >> 8) & 0xff
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = AUDIO_SAMPLE_RATE
	wav.stereo = false
	wav.data = pcm
	var player := AudioStreamPlayer.new()
	player.stream = wav
	player.volume_db = -4.0
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func _request_ai_question() -> void:
	var subjects := ["MATHS", "ENGLISH", "SCIENCE", "COMPUTING", "HISTORY", "GEOGRAPHY", "ART", "DESIGN TECHNOLOGY", "MUSIC", "PE & HEALTH", "WELLBEING"]
	var subject: String = str(subjects[randi() % subjects.size()])
	ai_client.request_question(subject, 6)

func _on_ai_question_ready(question: Dictionary) -> void:
	for existing in questions:
		if str(existing.get("question", "")).strip_edges().to_lower() == str(question.get("question", "")).strip_edges().to_lower():
			ai_status = "That question already exists. Ask MusabAI for another one."
			return
	question["id"] = str(question.get("id", "ai_" + str(Time.get_ticks_msec())))
	question["strand"] = str(question.get("strand", "MusabAI practice"))
	questions.append(question)
	question_order.append(questions.size() - 1)
	question_index = question_order.size() - 1
	_show_question()
	_play_tone(740.0, 0.12)

func _on_ai_status_changed(message: String) -> void:
	ai_status = message
	status_label.text = message

func _toggle_speech() -> void:
	speech_enabled = not speech_enabled
	voice_button.text = "🔊 VOICE ON" if speech_enabled else "🔇 VOICE OFF"
	if not speech_enabled:
		DisplayServer.tts_stop()
	else:
		_speak_text("Voice is on. I will read the question and answer choices aloud.")

func _speak_text(text_value: String) -> void:
	if not speech_enabled:
		return
	var voices: Array = DisplayServer.tts_get_voices()
	if voices.is_empty():
		ai_status = "Speech voice unavailable. Enable Android Text-to-speech / Speech Services by Google."
		if is_instance_valid(status_label):
			status_label.text = ai_status
		return
	var chosen_voice := str(voices[0].get("id", ""))
	for voice in voices:
		var language := str(voice.get("language", "")).to_lower()
		if language.begins_with("en_gb") or language.begins_with("en-gb") or language == "en":
			chosen_voice = str(voice.get("id", chosen_voice))
			break
	# Godot TTS volume is 0.0–1.0, not a percentage.
	DisplayServer.tts_speak(text_value, chosen_voice, 1.0, 1.0, 0.9, 1, true)

func _load_progress() -> void:
	var progress := ConfigFile.new()
	if progress.load("user://progress.cfg") == OK:
		score = int(progress.get_value("progress", "score", 0))
		question_index = maxi(0, int(progress.get_value("progress", "question_index", 0)))

func _save_progress() -> void:
	var progress := ConfigFile.new()
	progress.set_value("progress", "score", score)
	progress.set_value("progress", "question_index", question_index)
	progress.save("user://progress.cfg")

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		_save_progress()
