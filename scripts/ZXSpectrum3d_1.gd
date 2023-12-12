@tool

extends MeshInstance3D

@export var useClosest : bool = false
@export var lookupSize : int = 64
@export var palette : PackedColorArray
@export var buildNoise : bool = false
@export var noiseResolution : int = 512
@export var noiseLevels : int = 8

var minFactor : float = 0.25
var maxFactor : float = 0.75

var primaryTexture : Texture3D
var secondaryTexture : Texture3D
var noiseTexture : Texture2D 
const ZX = preload("ZX.gd")

func _ready():
	_on_visibility_changed()
		
func build_lookup():
	var data1 = []
	var data2 = []
	
	for z in range(lookupSize):
		var img1 = Image.create(lookupSize, lookupSize, false, Image.FORMAT_RGB8)
		var img2 = Image.create(lookupSize, lookupSize, false, Image.FORMAT_RGBA8)
		for x in range(lookupSize):
			for y in range(lookupSize):
				# For the color x,y,z, find closest
				var sourceColor = Color(float(x) / lookupSize, float(y) / lookupSize, float(z) / lookupSize)
				if useClosest:
					var closestColor = ZX.get_closest_color(sourceColor, palette)
					closestColor.a = 1;
					img1.set_pixel(x, y, closestColor)
					img2.set_pixel(x, y, closestColor)
				else:
					var line = ZX.get_closest_color_line(sourceColor, palette)
					var destColor0 = line[0]
					var destColor1 = line[1]
					destColor1.a = line[2]
					
					img1.set_pixel(x, y, destColor0)
					img2.set_pixel(x, y, destColor1)					
				
		data1.append(img1)
		data2.append(img2)		
		
	primaryTexture = ImageTexture3D.new()
	primaryTexture.create(Image.FORMAT_RGB8, lookupSize, lookupSize, lookupSize, false, data1)

	secondaryTexture = ImageTexture3D.new()
	secondaryTexture.create(Image.FORMAT_RGBA8, lookupSize, lookupSize, lookupSize, false, data2)
	
	if buildNoise:
		var img = Image.create(noiseResolution, noiseResolution, false, Image.FORMAT_R8)
		for y in range(noiseResolution):
			for x in range(noiseResolution):
				var n = floor(randf() * noiseLevels) / noiseLevels;				
				img.set_pixel(x, y, Color(n, n, n))

		noiseTexture = ImageTexture.create_from_image(img)		

func _on_visibility_changed():
	if visible:
		build_lookup()
		
		var material = get_mesh().get_material()
		material.set("shader_parameter/master_lookup", primaryTexture)
		material.set("shader_parameter/secondary_lookup", secondaryTexture)
		if buildNoise:
			material.set("shader_parameter/noiseTexture", noiseTexture)
