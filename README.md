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

## Remarks

While the effect might be cool, it probably requires assets done to exploit this, the tendency is to go to black a lot.
I've also added in the package some noise textures (blue noise and bayer) that provide a more ordered result.
I also added a "Use closest" flag that will just use the closest color in the given palette.

In the following images, we have the original image (with and without light boosting), the image with closest color (which has the more speccy-feel), with random noise and with a bayer noise texture.
In all of these, I had to boost the intensity of the light to get decent results with the dithering.

![No filter](screenshots/screen07.png)

![No filter (boosted light)](screenshots/screen08.png)

![Closest distance](screenshots/screen09.png)

![Generated White-noise](screenshots/screen10.png)

![Bayer noise](screenshots/screen11.png)

For fun, I also tried the effect with a Gameboy color palette, with the closest mode and no dithering.

![Gameboy](screenshots/screen12.png)

Dithering in noisy images just adds to the confusion:

![Gameboy w/ dithering](screenshots/screen13.png)

## Licenses

* All source code by Diogo de Andrade is licensed under the [MIT] license.
* Sponza model from the [glTF-Sample-Assest repo].
* Some models in scene main3d_2 are not made available in the repo, since they are from [Sinty Studios] and can't be distributed.
* All remaining art by Diogo de Andrade, available throught the [CC0] license.

## Metadata

* Autor: [Diogo Andrade]

[Diogo Andrade]:https://github.com/DiogoDeAndrade
[glTF-Sample-Assest repo]:https://github.com/KhronosGroup/glTF-Sample-Assets
[Sinty Studios]:https://www.syntystudios.com/
[SciFi City]:https://syntystore.com/products/polygon-sci-fi-city
[Midjourney]:https://www.midjourney.com/home/
[CC0]:https://creativecommons.org/publicdomain/zero/1.0/
[CC-BY 3.0]:https://creativecommons.org/licenses/by/3.0/
[GB Studio]:https://www.gbstudio.dev/
[GB Pixel Art Jam 2023]:https://itch.io/jam/gbpixelartjam23  
[MIT]:LICENSE
[chasersgaming]:https://itch.io/profile/chasersgaming
[Secret Service Building GB]:https://chasersgaming.itch.io/rpg-asset-tile-set-secret-service-building-gb
[Military Base GB]:https://chasersgaming.itch.io/rpg-assets-tile-set-military-base-gameboy
[Soldier GB]:https://chasersgaming.itch.io/rpg-assets-character-soldier-gameboy
[Gameboy Platformer Tile]:https://opengameart.org/content/gameboy-platformer-art
[LittleSadNerd]:https://opengameart.org/users/littlesadnerd
[GB Studio Plugins]:https://github.com/pau-tomas/gb-studio-plugins
[Pau]:https://github.com/pau-tomas/
