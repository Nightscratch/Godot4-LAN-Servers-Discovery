@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton('ServiceDiscovery', "res://addons/lan_service_discovery/service_discovery.gd")
