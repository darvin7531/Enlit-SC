extends Node

var network
var port = 3333
var players_max = 50
#Default setup Don't touch!

var connected_players = []

func _ready():
	# Off for error retrieval
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
	network = NetworkedMultiplayerENet.new()
	network.create_server(port, players_max)
	get_tree().set_network_peer(network)
	print("Enlit server core started")
	
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_OnPlayerConnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_OnPlayerDisconnected")
	
	#Old, soon to be deleted
	#network.connect("peer_connected", self, "_Peer_Connected")
	#network.connect("peer_disconnected", self, "_Peer_Disconnected")

func _OnPlayerConnected(id):
	print("Player UUID: " + str(id) + " Came into the server")
	var client = load("res://main/submain/client.tscn").instance()
	client.set_name(str(id))
	client._set_client_id(id)
	get_tree().get_root().add_child(client)
	connected_players.append({"id": id, "client": client})

func _OnPlayerDisconnected(id):
	print("Player UUID: " + str(id) + " Gone from the server")
	var remove = null
	for i in connected_players.size():
		if connected_players[i].id == id:
			remove = i
			break
	if remove != null:
		connected_players.remove(remove)
	var node = get_tree().get_root().get_node(str(id))
	node.queue_free()
