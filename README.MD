# Steel Neck Generator

Most steel guitars (that include pedal steel, lap steel, console steel..) do not have fret, but do have a silk-screen printed metal or plastic plate to show the position of the notes across the neck.
While it is possible to play without it (especially with a good ear), those markers are really helpful, especially when making wide moves.
The position of the fret can be calculated quite easily once you know the scale length of the instrument, but digital drawing tools usually do not provide interfaces to use such formulas, which make the design of the neck template for silk-screen printing quite cumbersome.

For a personal project, I had to make a tool to create such templates easily, so here it is !

## User guide

![](/media/scad_interface.png)

* Download and install [OpenSCAD](https://openscad.org/)
* Download and open the file `neck_generator.scad`
* Adjust the parameters in the `MECHANICAL SIZES` section to fit the caracteristics of your project
* Render the drawing using the `Render` button in the `Design` menu
* Export the drawing using the `Export` menu in the `File` menu (SVG and DXF might be supported by most vendors, see the media folder for examples)

## Supported parameters

Please note that all dimensions are in metric.

* FRET CARACTERISTICS
  * Scale lenght from neck to bridge
  * Number of frets to draw
  * Width of the line
  * Optionnal: padding distance at the beginning of the neck
* NECK CARACTERISTICS
  * Neck Max width
  * Neck taper value (from max width)
  * Neck corner rounded value (0 throws an error)
* MARKER CARACTERISTICS
  * Marker Pattern (suports 1, 2 or 3)
  * Star number of points (three at least)
  * Star inner to outer ratio
  * Size relative to fret width
  * Spacing for two side by side stars (multiple of star width)
  * Spacing for three side by side stars(multiple of star width)


## License and usage

This project is under the MIT license, so do whatever you want with it ! Attribution is always nice though, let me know if you find it usefull.

Feel free to ask for features in the issue panel of github, but know that I have limited time to dedicate to this.

## Why I did this

I am trying to make a [digital pedal steel](https://www.benjaminpoilve.com/projects/steel-neck.html). If you are interested, feel free to reach out !
