@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton('ServiceDiscovery', "res://addons/lan_servers_discovery/servers_discovery.gd")
