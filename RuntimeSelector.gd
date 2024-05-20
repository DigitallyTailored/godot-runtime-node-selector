extends Node3D

var collision_added = []
var collision_nodes = [] # List to keep track of the generated collision nodes

func _ready():
	# Make sure to enable input processing
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		# Detect click
		iterative_add_collision()
		var camera = get_viewport().get_camera_3d()
		var space_state = get_world_3d().direct_space_state
		var mouse_vector2 = get_viewport().get_mouse_position()
		var raycast_origin_vector3 = camera.project_ray_origin(mouse_vector2)
		var raycast_end = camera.project_position(mouse_vector2, 1000)
		var query = PhysicsRayQueryParameters3D.create(raycast_origin_vector3, raycast_end)
		var intersect = space_state.intersect_ray(query) 
		
		remove_added_collision()
		
		if intersect and intersect.collider:
			var clicked_path = intersect.collider.get_parent().get_path()
			EngineDebugger.send_message("clicked_node:node", [clicked_path])

func iterative_add_collision(node: Node = get_tree().root):
	if node.is_class("MeshInstance3D"):
		if not node.is_class("CollisionShape3D") and not node.is_class("StaticBody3D"):
			collision_added.append(node)
	else:
		pass
	for childNode in node.get_children():
		iterative_add_collision(childNode)
		
	# Temporarily add collision to these nodes
	for collision_node in collision_added:
		add_collision_to_node(collision_node)

func add_collision_to_node(node: MeshInstance3D):
	# Create a StaticBody for collisions
	var collision_body = StaticBody3D.new()
	collision_body.name = "GeneratedCollisionBody"
	collision_body.input_ray_pickable = true
	
	# Create a CollisionShape for the StaticBody
	var collision_shape = CollisionShape3D.new()
	var shape = BoxShape3D.new()

	var mesh = node.mesh
	if mesh:
		# Calculate the extents based on the AABB (Axis-Aligned Bounding Box) of the mesh
		var aabb = mesh.get_aabb()
		shape.extents = aabb.size * 0.5 # Extents is half the size of the AABB
	
	collision_shape.shape = shape
	collision_body.add_child(collision_shape)
	collision_shape.owner = collision_body
	node.add_child(collision_body)
	collision_body.owner = node
	
	collision_nodes.append(collision_body) # Add the collision body to the list of collision nodes


func remove_added_collision():
	for collision_node in collision_nodes:
		collision_node.queue_free()  # Queue the generated collision body for deletion
	collision_added.clear()  # Clear the list of nodes that had collision added
	collision_nodes.clear()  # Clear the list of generated collision nodes
