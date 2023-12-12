# Dithered pallete visual effect for Godot 4.2

Experimenting with a dithered pallete visual effect. My objective is to do a sort of ZX-Spectrum vibe visual effect.

The algorithm creates two volume textures, so for each point I have the endpoints of a line
in colorspace with valid ZX Spectrum colors, and a factor between them.

So, using the color on the color buffer I can figure out what two colors interpolation describe
best the color and how far along that interpolation I should go.

I then use a noise texture and a threshould factor to do some noise dithering.

This is also my first project in Godot, so I don't know how to do plenty of things.

## Version 1

![Screenshot Before](screenshots/screen01.png)

![Screenshot After](screenshots/screen02.png)

![Gradients](screenshots/screen03.png)

## Version 2

- Added shader for spatial post-process (3d scenes)
- Added functions to generate a white noise texture

![Screenshot Before](screenshots/screen04.png)

![Screenshot After](screenshots/screen05.png)

![Gradients](screenshots/screen06.png)