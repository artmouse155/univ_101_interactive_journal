extends TextureRect

var shader_material

func _ready():
	# Check if the sprite has a shader material
	if self.material is ShaderMaterial:
		# Cast the material to ShaderMaterial
		shader_material = self.material as ShaderMaterial		
	else:
		print("Sprite does not have a shader material applied.")

func set_blur(amt: float):
	if shader_material:
		#print("Blur is ", amt)
		shader_material.set_shader_parameter("lod", amt)
