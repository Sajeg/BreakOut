extends Node2D

signal new_response(text: String)

@onready var http_request = $HTTPRequest
@export_multiline var character: String = ""
@export var friendship = 50
@export var inventory = ["cans"]
@export var has_friendship = true
@export var has_inventory = true
var history = []


func add_message(text: String):
	var obj = load("res://Scripts/history_part.gd").new(text)
	history.append(obj)
	continue_chat()

func continue_chat():
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + load_api_key()
	var header = ["Content-Type: application/json"]
	var data = { 
		"contents": [], 
		"systemInstruction": { "role": "user", "parts": [{ "text": character }]},
		"safety_settings": [
			{"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
			{"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
			{"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"},
			{"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
		],
		"generationConfig": {
			"temperature": 1,
			"topK": 64,
			"topP": 0.95,
			"maxOutputTokens": 8192,
			"responseMimeType": "application/json"}
	}
	
	for part in history:
		data["contents"].append(part.get_formated())
	
	var json = JSON.stringify(data)
	print(json)
	
	var error = http_request.request(url, header, HTTPClient.METHOD_POST, json)
	if error != OK:
		print("Error occured: " + error)
	
func get_models():
	http_request.request("https://generativelanguage.googleapis.com/v1beta/models?key=" + load_api_key())

func load_api_key():
	var config = ConfigFile.new()
	var err = config.load("res://config.cfg")
	if err != OK:
		print("Failed to load config file")
		return ""
	return config.get_value("API", "api_key", "")

func _on_http_request_request_completed(result, response_code, headers, body):
		#if response_code == 200:
		print(body.get_string_from_utf8())
		var model_response = JSON.parse_string(body.get_string_from_utf8())
		var model_text = JSON.stringify(model_response["candidates"][0]["content"]["parts"][0]["text"])
		var model_message = load("res://Scripts/history_part.gd").new(model_text, "model")
		history.append(model_message)
		emit_signal("new_response", model_text)
	
