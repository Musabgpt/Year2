extends Node
signal question_ready(question: Dictionary)
signal status_changed(message: String)
const CONFIG_PATH := "user://musab_ai.cfg"
var http: HTTPRequest
var busy := false

func _ready() -> void:
	http = HTTPRequest.new()
	http.timeout = 18.0
	add_child(http)

func request_question(subject: String, age: int = 6) -> void:
	if busy:
		return
	busy = true
	var providers := _load_providers()
	if providers.is_empty():
		status_changed.emit("MusabAI is not configured; using offline questions.")
		busy = false
		return
	for provider in providers:
		status_changed.emit("Connecting to " + str(provider.get("name", "AI provider")) + "…")
		var result: Dictionary = await _ask_provider(provider, subject, age)
		if not result.is_empty():
			question_ready.emit(result)
			status_changed.emit("New question ready.")
			busy = false
			return
	status_changed.emit("AI providers unavailable; continue with offline questions.")
	busy = false

func _load_providers() -> Array[Dictionary]:
	var config := ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		return []
	var providers: Array[Dictionary] = []
	for section in config.get_sections():
		if not section.begins_with("provider_") or not bool(config.get_value(section, "enabled", true)):
			continue
		var endpoint := str(config.get_value(section, "endpoint", "")).strip_edges()
		var model := str(config.get_value(section, "model", "")).strip_edges()
		if endpoint.is_empty() or model.is_empty():
			continue
		providers.append({"name": str(config.get_value(section, "name", section)), "endpoint": endpoint, "model": model, "api_key": str(config.get_value(section, "api_key", "")).strip_edges()})
	return providers

func _ask_provider(provider: Dictionary, subject: String, age: int) -> Dictionary:
	var endpoint := str(provider["endpoint"])
	if not endpoint.begins_with("https://") and not endpoint.begins_with("http://127.0.0.1"):
		return {}
	var prompt := "Create one original age-appropriate England National Curriculum Key Stage 1 Year 2 question for a child aged %d. Subject: %s. Rotate across the full subject curriculum and cover a specific strand, not just arithmetic. Return JSON with keys subject, strand, question, answers, correct, hint, explanation, voice. answers must be exactly 3 short strings; correct is integer 0-2. explanation must teach WHY the answer is correct in child-friendly British English, in 1-3 short sentences. hint must help without giving the answer away. voice should be a natural spoken version of the question and all three answer options. Avoid repeated/common questions, ambiguous answers, unsafe content and trick questions." % [age, subject]
	var payload := {"model": provider["model"], "messages": [{"role": "system", "content": "You are MusabAI, a careful primary-school learning coach. Output valid JSON only."}, {"role": "user", "content": prompt}], "temperature": 0.7}
	var headers := PackedStringArray(["Content-Type: application/json"])
	var key := str(provider.get("api_key", ""))
	if not key.is_empty():
		headers.append("Authorization: Bearer " + key)
	if http.request(endpoint, headers, HTTPClient.METHOD_POST, JSON.stringify(payload)) != OK:
		return {}
	var response: Array = await http.request_completed
	if response.size() < 4 or int(response[1]) < 200 or int(response[1]) >= 300:
		return {}
	var body = JSON.parse_string(response[3].get_string_from_utf8())
	if not body is Dictionary:
		return {}
	var choices: Array = body.get("choices", [])
	if choices.is_empty() or not choices[0] is Dictionary:
		return {}
	var message: Dictionary = choices[0].get("message", {})
	var content := str(message.get("content", "")).strip_edges().replace("```", "").replace("json", "").strip_edges()
	var parsed = JSON.parse_string(content)
	if not parsed is Dictionary:
		return {}
	var answers = parsed.get("answers", [])
	var correct = parsed.get("correct", -1)
	if str(parsed.get("question", "")).strip_edges().is_empty() or not answers is Array or answers.size() != 3:
		return {}
	if not correct is int or correct < 0 or correct > 2:
		return {}
	for answer in answers:
		if str(answer).strip_edges().is_empty():
			return {}
	return {"subject": str(parsed.get("subject", subject)).to_upper(), "question": str(parsed["question"]), "answers": answers, "correct": correct, "hint": str(parsed.get("hint", "Take your time and think carefully.")), "explanation": str(parsed.get("explanation", "Well done for trying!")), "strand": str(parsed.get("strand", "Practice")), "voice": str(parsed.get("voice", parsed.get("question", "")))}
