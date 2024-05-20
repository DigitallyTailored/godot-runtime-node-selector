@tool
extends EditorPlugin

class ExampleEditorDebugger extends EditorDebuggerPlugin:

	var found = false
	var node_path = ""

	func _has_capture(prefix):
		return prefix == "clicked_node"

	func _capture(message, data, session_id):
		if message == "clicked_node:node":
			found = false
			node_path = str(data[0])
			
			var root_node = EditorInterface.get_edited_scene_root().get_node('/root').find_child("*EditorDebuggerTree*", true, false)
			
			check_editor_trees(root_node)
			
			if !found:
				print("Node not found. Please check the remote tab is open")
			

	func check_editor_trees(node : Node, indent_level=0):
		if node == null:
			return
		if node.is_class("Tree"):
			var root = node.get_root()
			recurse_tree_items(root,  "")
		for child in node.get_children():
			check_editor_trees(child, indent_level + 1)

	func recurse_tree_items(item: TreeItem, prefix):
		if item == null:
			return
		if "/" + prefix + item.get_text(0) == node_path: #we found the clicked node!
			item.select(0)
			found = true
		if item.get_children():
			for treeItem in item.get_children():
				recurse_tree_items(treeItem, prefix + item.get_text(0) + "/")
		item = item.get_next()

var debugger = (ExampleEditorDebugger as Variant).new()

func _enter_tree():
	add_debugger_plugin(debugger)

func _exit_tree():
	remove_debugger_plugin(debugger)
