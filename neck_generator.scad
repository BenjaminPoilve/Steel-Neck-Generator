$fn = 400;


//====================================================================
// MECHANICAL SIZES,dim in mm:
//====================================================================

//FRET CARACTERISTICS
//scale length from neck to bridge
virtual_scale_length=620;
//num of frets to draw
num_fret=23;
//Optional: to add padding
padding = 0;
//Size of the drawn line
line_width=2;


//NECK CARACTERISTICS
//Neck Max width
neck_max_width = 35;
//Neck taper value (from max width)
taper_value=0.85;
//Neck corner rounded value (0 throws an error)
corner_size=2;

//MARKER CARACTERISTICS
//Marker Pattern (suports 1, 2 or 3)
marker_pattern=[0,0,1,0,1,0,1,0,2,0,0,3,0,0,1,0,1,0,1,0,1,0,0,2];
//Star number of points
star_points=9;
//Star inner to outer ratio
inner_ratio=0.3;
//Size relative to fret width
rel_size=0.5;
//Spacing for two side by side stars (multiple of star width)
two_spacing=1;
//Spacing for three side by side stars(multiple of star width)
three_spacing=1;

//====================================================================
// CALCULATIONS FOR FRETS:
//====================================================================

//FOR MAIN SLIDER
function scale_calc(x) = virtual_scale_length-(virtual_scale_length / (2 ^ (x / 12)));
fret_positions = [ for (i=[0:num_fret+1]) scale_calc(i)];
slider_length = padding+fret_positions[len(fret_positions)-1];


//====================================================================
// MODULES:
//====================================================================


//===========================================================
// TRAPEZE AND ROUNDED TRAPEZE MODULE TO BUILD A OUTLINE
module trapeze(length,start_height,end_height){
    hull() {
        translate([length,0,0]) square(size=[0.01, end_height],center = true);
        square(size=[0.01, start_height],center = true);
    }

}//end module

module rounded_trapeze(length,start_height,end_height,corner_radius){
    translate( [ corner_radius, 0, 0 ] )
            minkowski() {
                trapeze(length- 2 * corner_radius,start_height- 2 * corner_radius,end_height- 2 * corner_radius);
                circle( corner_radius );
            }

}//end module

//===========================================================
// STAR TO MAKE MARKERS
module star(points, outer, inner) {

	// polar to cartesian: radius/angle to x/y
	function x(r, a) = r * cos(a);
	function y(r, a) = r * sin(a);

	// angular width of each pie slice of the star
	increment = 360/points;

	union() {
		for (p = [0 : points-1]) {
            {x_outer = x(outer, increment * p);
            y_outer = y(outer, increment * p);
            x_inner = x(inner, (increment * p) + (increment/2));
            y_inner = y(inner, (increment * p) + (increment/2));
            x_next  = x(outer, increment * (p+1));
            y_next  = y(outer, increment * (p+1));
            polygon(points = [[x_outer, y_outer], [x_inner, y_inner], [x_next, y_next], [0, 0]], paths  = [[0, 1, 2, 3]]);
            }
		}
	}
}

//====================================================================
// MAIN CODE:
//====================================================================


//OUTLINE AND FRETS SILK

union(){
    difference(){
        offset(r = line_width) {
            rounded_trapeze(slider_length,neck_max_width*taper_value,neck_max_width,corner_size);
        }
        rounded_trapeze(slider_length,neck_max_width*taper_value,neck_max_width,corner_size);
    }
    intersection(){
        offset(r = line_width) {
            rounded_trapeze(slider_length,neck_max_width*taper_value,neck_max_width,corner_size);
        }
       for(i=[1:num_fret]) translate([padding+fret_positions[i]-line_width/2.0,-neck_max_width/2.0,0]){
           square(size=[line_width , neck_max_width], center=false);
       }
   }

}
for(i=[1:num_fret+1]) translate([padding+fret_positions[(i-1)]+(fret_positions[i]-fret_positions[(i-1)])/2.0,0,0]){
            star_width=rel_size*(fret_positions[i]-fret_positions[(i-1)])/2.0;
            if(marker_pattern[i-1]==1){
                star(star_points, star_width, star_width*inner_ratio);
            }else if (marker_pattern[i-1]==2){
                translate([0,two_spacing*star_width])star(star_points, star_width, star_width*inner_ratio);
                translate([0,-two_spacing*star_width])star(star_points, star_width, star_width*inner_ratio);

            }else if (marker_pattern[i-1]==3){
                translate([0,three_spacing*2*star_width])star(star_points, star_width, star_width*inner_ratio);
                 translate([0,0])star(star_points, star_width, star_width*inner_ratio);
                translate([0,-three_spacing*2*star_width])star(star_points, star_width, star_width*inner_ratio);

            }

}


echo("Done");
