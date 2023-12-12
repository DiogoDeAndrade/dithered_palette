@tool

extends ColorRect

@export var lookupSize : int = 64
@export var palette : PackedColorArray
@export var buildNoise : bool = false
@export var noiseResolution : int = 512
@export var noiseLevels : int = 8

var primaryTexture : Texture3D
var secondaryTexture : Texture3D
var noiseTexture : Texture2D

func _ready():
	build_lookup()

	material.set("shader_parameter/master_lookup", primaryTexture)
	material.set("shader_parameter/secondary_lookup", secondaryTexture)
	if buildNoise:
		material.set("shader_parameter/noiseTexture", noiseTexture)
		
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
				var line = get_closest_color_line(sourceColor, palette)
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

func get_closest_color_line(target_color : Color, pal : PackedColorArray):
	var closestColor1 : Color = pal[0]
	var closestColor2 : Color = pal[0]
	var factor : float = 0
	var smallest_distance : float = INF  # Start with infinity as the smallest distance

	for i1 in range(0, pal.size()):
		for i2 in range(i1 + 1, pal.size()):
			var c1 = pal[i1]
			var c2 = pal[i2]
			var ret = calculate_color_distance(target_color, c1, c2)
			var distance = ret[0]
			var f = ret[1]

			if distance < smallest_distance:
				smallest_distance = distance
				closestColor1 = c1
				closestColor2 = c2
				factor = f

	return [ closestColor1, closestColor2, factor ]

func calculate_color_distance(matchColor : Color, color1 : Color, color2 : Color):
	
	var v = Vector3(matchColor.r, matchColor.g, matchColor.b)
	var v1 = Vector3(color1.r, color1.g, color1.b)
	var v2 = Vector3(color2.r, color2.g, color2.b)	
	var d = v2 - v1
	var l = d.length_squared()
	
	var w = d.dot(v - v1) / l
	if w < 0:
		return [ v.distance_to(v1), 0 ]
	elif w > 1:
		return [ v.distance_to(v2), 1 ]
	
	return [ v.distance_to(v1 + d * w), w ]
	
