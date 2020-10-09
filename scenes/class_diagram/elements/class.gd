extends PanelContainer
class_name Class

onready var name_lbl : Label = $Data/Name
onready var attributes_list : VBoxContainer = $Data/Attributes
onready var methods_list : VBoxContainer = $Data/Methods

var attributes : Array = []
var methods : Array = []

var custom_label : PackedScene = preload("res://scenes/utils/custom_label.tscn")

var dragging : bool = false

signal double_clicked(this_class)
signal clicked(this_class)

func _ready():
	pass # Replace with function body.

func build_class(c_name : String = "Class", c_description : String = "", c_attributes : Array = [], c_methods : Array = []) -> void:
	set_name(c_name)
	set_description(c_description)
	set_attributes(c_attributes)
	set_methods(c_methods)

func update_class(c_name : String = "Class", c_description : String = "", c_attributes : Array = [], c_methods : Array = []) -> void:
	set_name(c_name)
	set_description(c_description)
	add_attributes(c_attributes)
	add_methods(c_methods)



var pos : Vector2

func _gui_input(event):
	if event is InputEventMouseButton and event.doubleclick:
		emit_signal("double_clicked", self)
	if event is InputEventMouseButton and event.is_pressed() and not dragging:
		dragging = true
		pos = get_global_mouse_position() - rect_global_position
		emit_signal("clicked", self)
		set_process(dragging)
	elif event is InputEventMouseButton and not event.is_pressed():
		dragging = false
		set_process(dragging)

func _process(delta):
	if dragging:
		rect_global_position = get_global_mouse_position() - pos

# ------------- Getters and Setters --------------- #
func set_name(c_name : String) -> void:
	name = c_name
	name_lbl.set_text(name)

func get_name() -> String:
	return name

func set_description(description : String) -> void:
	set_tooltip(description)

func get_description() -> String:
	return get_tooltip()

func set_attributes(c_attributes : Array) -> void:
	attributes = c_attributes
	for attribute in attributes:
		attributes_list.add_child(add_element("+ %s"%attribute))

func add_attribute(c_attribute : String) -> void:
	attributes.append(c_attribute)
	attributes_list.add_child(add_element("+ %s"%c_attribute))

func add_attributes(attributes_i : Array) -> void:
	for attribute_i in attributes_i:
		add_attribute(attribute_i)

func get_attributes() -> Array:
	return attributes

func set_methods(c_methods : Array) -> void:
	methods = c_methods
	for method in methods:
		methods_list.add_child(add_element("+ %s"%method))

func add_method(c_method : String) -> void:
	methods.append(c_method)
	methods_list.add_child(add_element("+ %s"%c_method))

func add_methods(methods_i : Array) -> void:
	for method_i in methods_i:
		add_method(method_i)

func get_methods() -> Array:
	return methods

func add_element(content : String) -> CustomLabel:
	var lbl : CustomLabel = custom_label.instance()
	lbl.set_text(content)
	return lbl
