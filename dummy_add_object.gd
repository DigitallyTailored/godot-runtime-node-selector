extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var meshInstance = MeshInstance3D.new()
	meshInstance.name = "dummy"
	meshInstance.mesh = PrismMesh.new()
	add_child(meshInstance)
