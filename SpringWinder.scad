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

// 3/16"
steel_mandrel_diameter = 4.7625; 
wire_diameter = 1;
printer_fudge_factor = 0.21;

translate([-20, 55, base_height])
  rotate([180,0,0])
    winder_base();
winder();

base_height=17.5;
base_length = 40;
base_width=25;
base_width_narrow = base_width-10;
winder_radius = 30;
winder_height = 8;

module winder_base() {
  stepDelta = wire_diameter/20;
  difference() {
  	union() {
      cube(size=[base_length, base_width_narrow, base_height-5], center=false);
      translate([0,-(base_width-base_width_narrow)/2,base_height-5])
    	cube(size=[base_length, base_width, 5], center=false);
    }
    translate([base_length/2,base_width_narrow/2,1.5]) mandrel_hole();
    // split the base to clamp the mandrel
    translate([0,base_width_narrow/2-0.5,0]) cube(size=[base_length, 1, base_height-5], center=false);
    for (offset = [5 : 1 : base_width/2  ]) 
      translate([
        base_length/2 + offset * cos(-150+120*(offset-5)),
        base_width_narrow/2 + offset * sin(-150+120*(offset-5)),
        0]) tailHole();
    translate([0,base_width_narrow/2,base_height-4.8]) rotate([0,71,9]) tailHole(false, 20, wire_diameter);
    translate([base_length,base_width_narrow/2,base_height-4.8]) rotate([0,71,171]) tailHole(false, 20, wire_diameter);
  }
}

module tailHole(fan = true, base_length = 10, r = wire_diameter/2+printer_fudge_factor) {
  fanr = 1.5;
  translate([0,0,base_height-base_length])
    cylinder(r=r, h=base_length, center=false, $fn=12);
  if (fan)
    translate([0,0,base_height - (fanr - wire_diameter/2)])
      cylinder(r2=fanr, r1=wire_diameter/2, h=fanr - wire_diameter/2, center=false, $fn=12);
}

module winder() {
  intersection() {
  difference() {
    union() {
      cylinder(r=winder_radius, h=winder_height, center=false);
      translate([0,0,winder_height])
      difference() {
        cylinder(r=base_width/2, h=steel_mandrel_diameter+wire_diameter, center=false);

        translate([0,0,steel_mandrel_diameter - wire_diameter*2])
          cylinder(r=steel_mandrel_diameter+wire_diameter*1, h=steel_mandrel_diameter, center=false);

        translate([0,base_width/4,steel_mandrel_diameter])
          rotate([90,0,0])
            cylinder(r1=wire_diameter*2, r2 = steel_mandrel_diameter/2 + wire_diameter, h=base_width/2, center=true, $fn=4);
          rotate([0,0,-90])
        translate([0,-base_width/4,steel_mandrel_diameter])
          rotate([-90,0,0])
            cylinder(r1=wire_diameter*2, r2 = steel_mandrel_diameter/2 + wire_diameter, h=base_width/2, center=true, $fn=4);

        translate([0,0,steel_mandrel_diameter - wire_diameter])
          union() {
              translate([0,0,0]) cube([base_width/2, base_width/2, wire_diameter*2]);
              translate([base_width/2,0.1,0]) rotate([0,0,-180]) cube([base_width, base_width/2+0.1, wire_diameter*2]);
            }
      }
      //translate([0,0,winder_height])
        //cylinder(r=steel_mandrel_diameter, h=steel_mandrel_diameter/2, center=false);
      translate([0,0,winder_height+steel_mandrel_diameter/2+0.001])
        cylinder(r1=steel_mandrel_diameter+wire_diameter*1, r2=steel_mandrel_diameter/2+1.26, h=steel_mandrel_diameter/2, center=false);
    }
    mandrel_hole();
    // easy edges finger grips
    for (a = [360 : 45 : 45]) {
      translate([
        (winder_radius+3) * cos(a),
        (winder_radius+3) * sin(a),
        0
        ]) scallop(winder_height);
    }
  }
  translate([0,0,-winder_radius+2])
    cylinder(r1=0, r2=winder_radius*2, h=winder_radius*2, center=false);
  translate([0,0,winder_radius+winder_height-2])
    rotate([180,0,0])
      cylinder(r1=0, r2=winder_radius*2, h=winder_radius*2, center=false);
  }
}

module scallop(winder_height) {
  translate([0,0,10-2]) rotate([180,0,0])
    cylinder(r1=10+5, r2=10-2, h=7, center=true);
  cylinder(r1=10+5, r2=10-2, h=7, center=true);
  cylinder(r=10, h=winder_height, center=false);
}

module mandrel_hole() {
  cylinder(r=steel_mandrel_diameter/2+printer_fudge_factor, h=base_height, center=false, $fn=60);
}