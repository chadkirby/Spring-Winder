/*
Copyright (c) 2013 Chad Kirby

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
function inch(in) = 25.4*in;

steel_mandrel_diameter = inch(3/16);
wire_diameter = 1;
tang_offset = 6; // from center of mandrel
printer_fudge_factor = 0.21;

mandrel_setscrew_tap = 3.26; // 8-32

translate([-20, 50, height])
rotate([180,0,0])
winder_base();
winder();

  height=20;
  len = 40;
  widtop=25;
  widbase = 15;
module winder_base() {
  stepDelta = wire_diameter/20;
  difference() {
  	union() {
      cube(size=[len, widbase, height-5], center=false);
      translate([0,-(widtop-widbase)/2,height-5])
    	cube(size=[len, widtop, 5], center=false);
    }
    translate([len/2,widbase/2,0])
      mandrel_hole();
    // set screw
    translate([len/2,0,widbase/1.5])
    rotate([-90,0,0])
      #cylinder(r=mandrel_setscrew_tap/2+printer_fudge_factor, h=widbase, center=false, $fn=60);
    // tang
    translate([len/2 + tang_offset,widbase/2,height-10])
      #cylinder(r=wire_diameter/2+printer_fudge_factor, h=10, center=false, $fn=12);
    // for (i = [1 : stepDelta : stepDelta]) {
    //   assign(
    //     p1 = [
    //       len/2 + widtop/2 * cos(30 + i * 360),
    //       widbase/2 + widtop/2 * sin(30 + i * 360)          
    //     ],
    //     p0 = [
    //       len/2 + widtop/2 * cos(30 + (i-stepDelta) * 360),
    //       widbase/2 + widtop/2 * sin(30 + (i-stepDelta) * 360)
    //     ]
    //   ) {
    //     translate([0, 0, height - (i-stepDelta) * wire_diameter])
    //     #linear_extrude(height = wire_diameter)
    //     polygon([
    //       [len/2, widbase/2],
    //       p0, p1
    //     ]);
    //   }      
    // }

  }
}

module winder() {
  r = 25;
  h=7;
  intersection() {
  difference() {
    union() {
      cylinder(r=r, h=h, center=false);
      translate([0,0,h])
      difference() {
        cylinder(r=widtop/2, h=steel_mandrel_diameter+wire_diameter, center=false);
        cylinder(r=steel_mandrel_diameter + wire_diameter*2, h=steel_mandrel_diameter*2, center=false);
        translate([0,0,steel_mandrel_diameter])
        rotate([90,0,0])
        #cylinder(r=wire_diameter*2, h=widtop, center=true, $fn=4);
      }
      translate([0,0,h])
      cylinder(r=steel_mandrel_diameter, h=steel_mandrel_diameter/2, center=false);
      translate([0,0,h+steel_mandrel_diameter/2])
      cylinder(r1=steel_mandrel_diameter, r2=steel_mandrel_diameter/2+1.26, h=steel_mandrel_diameter/2, center=false);
    }
    mandrel_hole();
    for (a = [360 : 30 : 30]) {
      translate([
        (r+2.5) * cos(a),
        (r+2.5) * sin(a),
        0
        ])
      cylinder(r=5, h=h, center=false);
    }
  }
  translate([0,0,-r+1.5])
    cylinder(r1=0, r2=r*2, h=r*2, center=false);
  translate([0,0,r+h-1.5])
    rotate([180,0,0])
      cylinder(r1=0, r2=r*2, h=r*2, center=false);
  }
}

module mandrel_hole() {
  cylinder(r=steel_mandrel_diameter/2+printer_fudge_factor, h=height, center=false, $fn=60);
}