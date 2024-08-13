extends Object

var role: String
var content: String

func _init(content: String, role: String = "user"):
	self.role = role
	self.content = content

func is_model() -> bool:
	return role == "model"

func get_formated():
	return {"role": role, "parts": [{"text": content}]}
