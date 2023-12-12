@tool

static func get_closest_color(target_color : Color, pal : PackedColorArray):
	var closestColor : Color = pal[0]
	var smallest_distance : float = INF  # Start with infinity as the smallest distance

	for c in pal:
		var distance = calculate_color_distance(target_color, c)
		if distance < smallest_distance:
			smallest_distance = distance
			closestColor = c

	return closestColor

static func get_closest_color_line(target_color : Color, pal : PackedColorArray, minFactor : float = 0.0, maxFactor : float = 1.0):
	var closestColor1 : Color = pal[0]
	var closestColor2 : Color = pal[0]
	var factor : float = 0
	var smallest_distance : float = INF  # Start with infinity as the smallest distance

	for i1 in range(0, pal.size()):
		for i2 in range(i1 + 1, pal.size()):
			var c1 = pal[i1]
			var c2 = pal[i2]
			var ret = calculate_color_distance_to_line(target_color, c1, c2, minFactor, maxFactor)
			var distance = ret[0]
			var f = ret[1]

			if distance < smallest_distance:
				smallest_distance = distance
				closestColor1 = c1
				closestColor2 = c2
				factor = f

	return [ closestColor1, closestColor2, factor ]

static func calculate_color_distance(color1 : Color, color2 : Color):
	var v1 = Vector3(color1.r, color1.g, color1.b)
	var v2 = Vector3(color2.r, color2.g, color2.b)

	return (v2 - v1).length()

static func calculate_color_distance_hsv(h : float, s : float, v : float, color2 : Color):
	var v1 = Vector3(h, s, v)
	var v2 = Vector3(color2.h, color2.s, color2.v)

	return (v2 - v1).length()

static func calculate_color_distance_to_line(matchColor : Color, color1 : Color, color2 : Color, minFactor : float = 0.0, maxFactor : float = 1.0):
	
	var v = Vector3(matchColor.r, matchColor.g, matchColor.b)
	var v1 = Vector3(color1.r, color1.g, color1.b)
	var v2 = Vector3(color2.r, color2.g, color2.b)	
	var d = v2 - v1
	var l = d.length_squared()
	
	var w = d.dot(v - v1) / l
	if w <= minFactor:
		return [ v.distance_to(v1), 0.0 ]
	elif w >= maxFactor:
		return [ v.distance_to(v2), 1.0 ]
	
	return [ v.distance_to(v1 + d * w), (w - minFactor) / (maxFactor - minFactor) ]

static func get_closest_color_by_hue(target_color : Color, pal : PackedColorArray):
	if target_color.s < 0.25:
		# This is a gray color, match by lightness
		return get_closest_color_by_value(target_color, pal)
	
	var closestColor : Color = pal[0]
	var smallest_distance : float = INF  # Start with infinity as the smallest distance
	var matchH = target_color.h
	
	for c in pal:
		# Wrap around distance in hue
		var distance = min(abs(matchH - c.h), abs((matchH + 1) - c.h))
		if distance < smallest_distance:
			smallest_distance = distance
			closestColor = c

	return closestColor

static func get_closest_color_by_value(target_color : Color, pal : PackedColorArray):
	var closestColor : Color = pal[0]
	var smallest_distance : float = INF  # Start with infinity as the smallest distance
	var matchV = target_color.v
	
	for c in pal:
		# Skip non-greys
		if c.s < 0.25:
			var distance = abs(matchV - c.v)
			if distance < smallest_distance:
				smallest_distance = distance
				closestColor = c

	return closestColor
