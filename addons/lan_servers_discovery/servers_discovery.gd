extends Node

signal scanned_server(data:JSON)
signal scanned

var client :PacketPeerUDP
var server :UDPServer

var server_data := {'Name':''}
var scanned_servers := []

var is_scanning := false
var is_servering := false

var port = 4040
var scan_time = 1

func scan_lan_servers():
	# 启动客户端
	client = PacketPeerUDP.new()
	client.set_broadcast_enabled(true)
	client.set_dest_address("255.255.255.255", port)
	client.put_var({'type':'get_server'})
	# 设置Timer等待2秒后完成扫描
	get_tree().create_timer(scan_time).timeout.connect(_on_timer_timeout)

	scanned_servers = []
	is_scanning = true

func set_server():
	server = UDPServer.new()
	server.listen(port,'0.0.0.0')
	is_servering = true
	
func close_server():
	server.stop()
	is_servering = false

func _process(delta):
	if is_scanning:
		if client.get_available_packet_count() > 0:
			var data= client.get_packet().decode_var(0)
			var server_ip = client.get_packet_ip()
			data['server_ip'] = server_ip
			data.erase('type')
			scanned_servers.append(data)
			scanned_server.emit(data)
			
	if is_servering:
		server.poll()
		if server.is_connection_available():
			var peer: PacketPeerUDP = server.take_connection()
			if peer.get_packet().decode_var(0)['type'] == 'get_server':
				peer.put_var({'type':'server_data','server_data':server_data})

func _on_timer_timeout():
	is_scanning = false
	client.close()
	scanned.emit()
