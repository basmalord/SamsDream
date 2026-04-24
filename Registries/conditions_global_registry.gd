extends Node

class_name ConditionsRegistry

signal condition_value_changed(condition_id: String, new_value: bool)


const condition_id_prefix: String = "CXX"

var global_condition_registry_instance_resource: ConditionRegistryInstance = preload("res://CustomResources/GlobalResources/ConditionRegistry/global_condition_registry_instance.tres") #should find a better way of doing this, so that I can easily change the path if required
var conditions_dict: Dictionary
var read_name_dict: Dictionary

func _ready():
	pass


func _add_new_condition_registry_entry(condition_name: String = "no_name_given", catalyst_node: Node = null, description = ""):
	var duplicate_incremental_value: int = 1
	var original_name = condition_name
	while read_name_dict.keys().find(condition_name) != -1:
		duplicate_incremental_value += 1
		condition_name = original_name + str(duplicate_incremental_value)
	var new_condition_id = generate_condition_id()
	var associated_nodes_array: Array[Node] = [catalyst_node]
	var new_condition_value_dict = generate_condition_registry_entry(condition_name, associated_nodes_array, description)
	conditions_dict[new_condition_id] = new_condition_value_dict
	_add_read_name_entry(new_condition_id, condition_name)



func _add_read_name_entry(condition_id: String, read_name: String):
	if read_name_dict.keys().find(read_name) != -1:
		push_error("ERROR WHEN ADDING READNAME TO READNAME DICT: READ NAME ALREADY EXISTS")
		return
	read_name_dict[read_name] = condition_id

func generate_condition_id() -> String:
	var condition_amount: int = read_name_dict.size()
	var new_condition_id: String = condition_id_prefix + str(condition_amount)
	return new_condition_id

func generate_condition_registry_entry(read_name: String = "no_name_given", associated_nodes: Array[Node] = [], description: String = "") -> Dictionary:
	var new_condition_registry_entry: Dictionary = {"read_name": "template_read_name",
"associated_nodes": [],
"description": "template_description"}
	new_condition_registry_entry["read_name"] = read_name
	new_condition_registry_entry["associated_nodes"] = associated_nodes
	new_condition_registry_entry["description"] = description
	return new_condition_registry_entry


func _save_new_registry_instance():
	global_condition_registry_instance_resource.conditions_dict = conditions_dict
	global_condition_registry_instance_resource.read_name_dict = read_name_dict
	ResourceSaver.save(global_condition_registry_instance_resource, "res://CustomResources/GlobalResources/ConditionRegistry/global_condition_registry_instance.tres")
