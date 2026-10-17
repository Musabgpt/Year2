extends SceneTree

func _initialize() -> void:
	var bank_script = load("res://scripts/curriculum_bank.gd")
	if bank_script == null:
		push_error("Curriculum bank could not be loaded.")
		quit(1)
		return
	var questions: Array = bank_script.all_questions()
	if questions.size() != 1000:
		push_error("Expected exactly 1000 questions, got %d." % questions.size())
		quit(1)
		return
	var ids := {}
	var texts := {}
	for i in range(questions.size()):
		var q: Dictionary = questions[i]
		var question_id := str(q.get("id", ""))
		var question_text := str(q.get("question", "")).strip_edges().to_lower()
		var answers = q.get("answers", [])
		var correct = q.get("correct", -1)
		if question_id.is_empty() or ids.has(question_id):
			push_error("Missing or duplicate question ID at index %d." % i)
			quit(1)
			return
		if question_text.is_empty() or texts.has(question_text):
			push_error("Missing or duplicate question text at index %d: %s" % [i, question_text])
			quit(1)
			return
		if not answers is Array or answers.size() != 3:
			push_error("Question %s must have exactly 3 answer choices." % question_id)
			quit(1)
			return
		if not correct is int or correct < 0 or correct > 2:
			push_error("Question %s has an invalid correct-answer index." % question_id)
			quit(1)
			return
		if str(answers[correct]).strip_edges().is_empty():
			push_error("Question %s has an empty correct answer." % question_id)
			quit(1)
			return
		ids[question_id] = true
		texts[question_text] = true
	print("CURRICULUM VALIDATION PASSED: %d unique questions, valid 3-choice answers, and correct-answer indexes." % questions.size())
	quit(0)
