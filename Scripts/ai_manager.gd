extends Node2D

@onready var http_request = $HTTPRequest
@export var prompt = "Let's play a roleplay game. You are now Dieter, a guy who is in prison because he stole pans from an old grandmother. You'll now have a conversation with another inmate."
@export var history = []


func _ready():
	var message = load("res://Scripts/history_part.gd").new("Hi i'm Sajeg!")
	history.append(message)
	continue_chat()

func continue_chat():
	var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + load_api_key()
	var header = ["Content-Type: application/json"]
	var data = { 
		"contents": [], 
		"systemInstruction": { "role": "user", "parts": [{ "text": prompt }]},
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
	print(body.get_string_from_utf8())
	
	
