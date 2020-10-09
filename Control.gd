extends Control

var class_container : PackedScene = preload("res://scenes/class_diagram/elements/class.tscn")
var custom_label : PackedScene = preload("res://scenes/utils/custom_label.tscn")

onready var attribute_name_line : LineEdit = $ClassEditor/ClassPanel/ClassContainer/Data/Attributes/AttributesContainer/AttributeField/AttributeName/AttributeNameLine
onready var attribute_type_line : LineEdit = $ClassEditor/ClassPanel/ClassContainer/Data/Attributes/AttributesContainer/AttributeField/AttributeType/AttributeTypeLine
onready var attributes_list : VBoxContainer = $ClassEditor/ClassPanel/ClassContainer/Data/Attributes/AttributesContainer/AttributesList/Attributes

onready var method_name_line : LineEdit = $ClassEditor/ClassPanel/ClassContainer/Data/Methods/MethodsContainer/MethodField/MethodName/MethodNameLine
onready var method_return_type_line : LineEdit = $ClassEditor/ClassPanel/ClassContainer/Data/Methods/MethodsContainer/MethodField/MethodReturnType/MethodReturnTypeLine
onready var methods_list : VBoxContainer = $ClassEditor/ClassPanel/ClassContainer/Data/Methods/MethodsContainer/MethodsList/Methods

onready var class_name_line : LineEdit = $ClassEditor/ClassPanel/ClassContainer/Data/Class/ClassField/ClassName/ClassNameLine
onready var class_description_text : TextEdit = $ClassEditor/ClassPanel/ClassContainer/Data/Class/ClassField/ClassDescription/ClassDescriptionText

onready var diagram : Control = $ClassDiagram/Diagram
onready var class_editor : Control = $ClassEditor

var editing_class : Class

var temp_attributes : Array = []
var temp_methods : Array = []

var last_class_position : Vector2

enum PORT_TYPES { NULL, INHERITANCE, DEPENDENCY }

func _ready():
	randomize()
	class_editor.hide()

# When the Class button is pressed, spawn a new class
func _on_ClassBtn_pressed():
	var new_class : Class = class_container.instance()
	new_class.connect("double_clicked", self, "class_double_clicked")
	new_class.connect("clicked",self,"class_clicked")
	diagram.get_node("Space").add_child(new_class)
	new_class.build_class()
	new_class.rect_position = ( diagram.get_rect().size + Vector2(diagram.scroll_horizontal, diagram.scroll_vertical) )/2 - new_class.rect_size/2 + Vector2(rand_range(-20,20), rand_range(-20,20))

# Clear the Class Editor and Class Panel
func clear_class_editor():
	temp_attributes.clear()
	temp_methods.clear()
	editing_class = null
	
	for attribute in attributes_list.get_children():
		attribute.queue_free()
	for method in methods_list.get_children():
		method.queue_free()
	
	
	clear_class_tab()
	clear_attributes_tab()
	clear_methods_tab()

# Only clear Class tab in Class Panel
func clear_class_tab():
	class_name_line.clear()
	class_description_text.set_text("")

# Only clear Attributes tab in Class Panel
func clear_attributes_tab():
	attribute_name_line.clear()
	attribute_type_line.clear()

# Only clear Methods tab in Class Panel
func clear_methods_tab():
	method_name_line.clear()
	method_return_type_line.clear()

# When a class is clicked, move it as the first child to bring it top level
func class_clicked(clicked_class : Class):
	diagram.get_node("Space").move_child(clicked_class, diagram.get_node("Space").get_child_count())

# When a class is double clicked, edit it filling all fields with its attributes
func class_double_clicked(selected_class : Class) :
	clear_class_editor()
	editing_class = selected_class
	class_name_line.set_text(editing_class.get_name())
	class_description_text.set_text(editing_class.get_description())
	var lbl : Label
	for attribute in editing_class.get_attributes():
		lbl = Label.new()
		lbl.set_text(attribute)
		attributes_list.add_child(lbl)
	for method in editing_class.get_methods():
		lbl = Label.new()
		lbl.set_text(method)
		methods_list.add_child(lbl)
	class_editor.show()

# If the Apply button in the Class Panel is pressed, confirm all changes
func _on_ApplyBtn_pressed():
	editing_class.update_class(class_name_line.get_text(), class_description_text.get_text(), temp_attributes, temp_methods)
	class_editor.hide()

# If Close Button is pressed, close the Class Panel and Editor
func _on_CloseBtn_pressed():
	class_editor.hide()

# If the Add Attribute button is pressed
func _on_AddAttributesBtn_pressed():
	var attribute_name : String = attribute_name_line.get_text()
	var attribute_type : String = attribute_type_line.get_text()
	var label : Label = Label.new()
	var attribute : String = "%s : %s" % [attribute_name, attribute_type]
	temp_attributes.append(attribute)
	label.set_text(attribute)
	attributes_list.add_child(label)
	clear_attributes_tab()

# If the Add Method button is pressed
func _on_AddMethodsBtn_pressed():
	var method_name : String = method_name_line.get_text()
	var method_return_type : String = method_return_type_line.get_text()
	var label : Label = Label.new()
	var method : String = "%s() : %s" % [method_name, method_return_type]
	temp_methods.append(method)
	label.set_text(method)
	methods_list.add_child(label)
	clear_methods_tab()

