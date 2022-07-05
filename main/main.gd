extends Node

var network = NetworkedMultiplayerENet.new()
var port = 3333
var pm = 50

func _ready():
#	var file = File.new()
#	var file2 = file.file_exists("user://server.cfg") 
#	if file2 == true:
#		print('Файл существует')
#		_load_core()
#	else:
#		var config = ConfigFile.new()
#		config.set_value("settings", "players", "50")
#		config.set_value("settings", "port", "20555")
#		config.set_value("settings", "ip", "127.0.0.1")
#		config.save("user://server.cfg")
	_load_core()

func _load_core():
	network.create_server(port, pm)
	get_tree().set_network_peer(network)
	print("Enlit server core started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(p_uid):
	print("Player UUID: " + str(p_uid) + " Came into the gym")

func _Peer_Disconnected(p_uid):
	print("Player UUID: " + str(p_uid) + " Gone from the gym")
