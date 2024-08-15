extends Control

signal new_response(text: String, friendship: int, inventory: Array)

@onready var http_request = $HTTPRequest
@export_multiline var character: String = ""
@export var friendship = 50
@export var inventory = ["cans"]
@export var has_friendship = true
@export var has_inventory = true
var history = []


func add_message(text: String, give = []):
	var obj = load("res://Scripts/history_part.gd").new(text)
	history.append(obj)
	continue_chat(give)

func continue_chat(give):
	print("Sending request")
	var prompt = "Let's play a prison role playing game where we both are imates."
	prompt += character
	if has_friendship:
		prompt += "Together with the text from me you'll receive a friendship score on a scale of 0-100 where 100 is love and 0 is enemie you can change the score based on our conversation, but always return the score. And the longer the conversation is the less the score changes."
	if has_inventory:
		prompt += "You will also receive a set of items that you own. If you want to give me a item you own you can simply don't return it. But please return the rest. You can also receive items from the Player for trading."
	
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + load_api_key()
	var header = ["Content-Type: application/json"]
	var data = { 
		"contents": [], 
		"systemInstruction": { "role": "user", "parts": [{ "text": prompt }]},
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
		data["contents"].append(part.get_formated(inventory, friendship, give))
	
	var json = JSON.stringify(data)
	
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
	print("Got response")
	if response_code == 200:
		var model_response = JSON.parse_string(body.get_string_from_utf8())
		var model_text = JSON.stringify(model_response["candidates"][0]["content"]["parts"][0]["text"])
		var model_string = JSON.parse_string(JSON.parse_string(model_text))
		var model_message = model_string["message"]
		friendship = model_string["friendship"]
		inventory = model_string["inventory"]
		var model_message_object = load("res://Scripts/history_part.gd").new(model_message, "model")
		history.append(model_message_object)
		emit_signal("new_response", model_message, friendship, inventory)
	else:
		print("EROR: " + body.get_string_from_utf8())
