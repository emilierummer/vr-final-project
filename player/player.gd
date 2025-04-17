extends XROrigin3D

## The parent node that all geometry should be created as children of
@export var geometry_parent: Node

## Adds a geometry object as a child of the geometry parent node
func add_geometry_child(geometry: Geometry) -> void:
	geometry_parent.add_child(geometry)
