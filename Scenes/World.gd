extends Spatial

const SERVER_PORT = 7070
const SERVER_IP   = "127.0.0.1"
const MAX_PLAYERS = 20

var peer
var players = {}
var self_id = 0
var paused = true
var nick= ""

var RemotePlayer = load("res://Components/RemotePlayer/RemotePlayer.tscn")

func _ready():
	peer = NetworkedMultiplayerENet.new()
	# CLIENT & SERVER ######################
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	# CLIENT ONLY ###########################
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func clean_up():
	pass


func add_log(text):
	$UI/Label.text = $UI/Label.text + text + "\n"


func start_client(nickname, ip):
	nick = nickname
	add_log("---- CLIENT ----");
	peer.create_client(ip, SERVER_PORT)
	get_tree().set_network_peer(peer)

func start_server(nickname):	
	nick = nickname
	add_log("---- SERVER ----");
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	
func _player_connected(id):
	var player: Spatial = RemotePlayer.instance()
	player.name = "pl_" + str(id)
	player.translate(Vector3(randi() % 5 - 2.5, 2, randi() % 5 - 2.5))
	$Players.add_child(player)
	distribute_position(player.translation)
	add_log("=> Connected and drawed player: " + str(id) + " rendered at: " + str(player.translation));
	
remote func update_remote_player_position(id, pos: Vector3):
	print("ipdating pos of: " + str(id))
	if id != self_id:
		var player = $Players.get_node("pl_" + str(id))
		if player:
			print("UPDATING PLAYER's " + str(id) + " POSITION TO " + str(pos))
			player.translate(pos - player.translation)	
			#player.target_position = pos
	
func distribute_position(new_pos):
	print("distributing my pos: " + str(new_pos));
	rpc("update_remote_player_position", get_tree().get_network_unique_id(), new_pos)
	
remote func register_player(id, info):
	players[id] = info
	if get_tree().is_network_server():
		add_log("[+] new client, registering server to the new client");
		rpc_id(id, "register_player", 1, { "nick": "Server" })
		for peer_id in players:
			add_log("[+] registering new client to player: " + str(peer_id));
			rpc_id(id, "register_player", peer_id, players[peer_id])
	
	
## CLIENT PART ##########################
func _connected_ok():
	add_log("=> I'am connected to the game");
	print("CLIENT connected...")
	self_id = get_tree().get_network_unique_id()

	if nick == "":
		nick = "player_" + str(self_id)
		
	rpc("register_player", get_tree().get_network_unique_id(), { "nick":  nick } )
	
