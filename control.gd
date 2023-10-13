extends Control

@onready var label = %Label
@onready var server_list = %ServerList
@onready var scan_button = %Scan

var server_list_item := preload("res://server_button.tscn")

func add_server_button(data):
	var item = server_list_item.instantiate()
	item.get_node("NameLabel").text = str(data.server_data.Name)
	item.get_node("IPLabel").text = str(data.server_ip)
	
	server_list.add_child(item)

func _ready():
	ServiceDiscovery.port = 4040
	ServiceDiscovery.scanned_server.connect(_on_scan_server)
	ServiceDiscovery.scanned.connect(_on_scan_scanned)
	
func _on_host_pressed():
	scan_button.disabled = true
	ServiceDiscovery.server_data = {'Name':'Your Server Name'}
	label.text = 'You are server'	
	ServiceDiscovery.set_server()

func _on_scan_pressed():
	scan_button.disabled = true
	ServiceDiscovery.scan_lan_servers()
	label.text = 'scanning'
	for child in server_list.get_children():
		server_list.remove_child(child)
	
func _on_scan_server(data):
	label.text = 'scanning (Found %s Server)'%len(ServiceDiscovery.scanned_servers)
	add_server_button(data)

func _on_scan_scanned():
	scan_button.disabled = false
	label.text += '扫描完毕'	
	label.text = ''
