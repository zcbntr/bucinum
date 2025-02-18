class_name Component extends Node

func _ready() -> void:
	if owner:
		owner.set_meta(get_component_name(), self)

func get_component_name() -> StringName:
	assert(false, '%s should implement get_component_name' % get_script().resource_path)
	return ''

func register_component(owning_node: Node, component_node: Component) -> void:
	owning_node.add_child(component_node)
	component_node.owner = owning_node
	owning_node.set_meta(component_node.get_component_name(), component_node)

static func find_component(owning_node: Node, component_name: StringName) -> Component:
	if owning_node.has_meta(component_name):
		return owning_node.get_meta(component_name)
	return null

static func has_component(owning_node: Node, component_name: StringName) -> bool:
	return Component.find_component(owning_node, component_name) != null
