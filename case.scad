$fn = 50;

module tiny2040() {
  union() {
    // pcb
    color("darkgreen") difference() {
      cube([ 20.4, 18, 1 ], center = true);
      for (x = [-10.2:2.5:9])
        union() {
          for (y = [ 9, -9, 7.5, -7.5 ])
            translate([ x + 1.5, y, 0 ])
                cylinder(r = 0.5, 50, center = true, $fn = 20);
        }
    }
    // usb-c connector
    color("silver") translate([ -9, 0, 2 ]) rotate([ 90, 0, 90 ]) hull() {
      for (x = [ -3, 3 ])
        translate([ x, 0, 0 ]) cylinder(r = 1.5, 7.5, center = true, $fn = 30);
    }
    // buttons
    color("white") for (y = [ 3.5, -3.5 ]) translate([ 0, y, 1.5 ])
        cube([ 4, 3.5, 2.5 ], center = true);
    // chip
    color("black") translate([ 0, -0.5, -1 ]) cube([ 7, 7, 1 ], center = true);
  }
}

module adlx345() {
  union() {
    // pcb
    color("darkblue") difference() {
      cube([ 20.5, 16, 1 ], center = true);
      for (x = [-10.2:2.5:9])
        union() {
          translate([ x + 1.5, 6.5, 0 ])
              cylinder(r = 0.5, 50, center = true, $fn = 20);
        }
      for (x = [ -7.5, 7.5 ])
        union() {
          translate([ x, -5.5, 0 ])
              cylinder(r = 1.5, 50, center = true, $fn = 20);
        }
    }
    // chip
    color("black") translate([ 0, -0.5, 1 ]) cube([ 5, 3, 1 ], center = true);

    // capacitor
    color("orange") translate([ 0, -4.5, 1.2 ])
        cube([ 3, 2, 1.5 ], center = true);
  }
}

module circuit() {
  translate([ -9, 0, -1 ]) union() {
    tiny2040();
    translate([ 20, 0, 0 ]) rotate([ 0, 0, 90 ]) adlx345();
  }
}

module circuit_indent() {
  union() {
    // shallower indent for sliding in PCB
    translate([ 2, 0, 0 ]) cube([ 22.4, 18, 1 ], center = true);
    // deeper indent to leave room for solder and components
    cube([ 20.4, 16, 3 ], center = true);
    // bulge
    translate([ 0, 0, 0 ]) cube([ 22, 12, 1 ], center = true);
    // connection for cables
    translate([ 2, 0, 0 ]) cube([ 22, 16, 3 ], center = true);
    translate([ 20, 0, 0 ]) rotate([ 0, 0, 90 ]) {
      cube([ 20.5, 16, 1.5 ], center = true);
      cube([ 18.5, 16, 3 ], center = true);
    }
  }
}

module case_bottom() {
  difference() {
    // case
    color("yellow", 0.8) cube([ 41, 22, 7 ], center = true);
    union() {
      // rp2040
      translate([ -8, 0, 1 ]) union() {
        cube([ 23.4, 18, 5 ], center = true);
        cube([ 23.4, 16, 8 ], center = true);
        *cylinder(r = 8, 10, center = true);
        color("silver") translate([ -10, 0, 0 ]) rotate([ 90, 0, 90 ]) hull() {
          for (x = [ -3, 3 ])
            translate([ x, 0, 0 ]) {
              cylinder(r = 1.5, 7.5, center = true, $fn = 30);
              translate([ -1.5, 0, -3.5 ]) cube([ 3, 3.5, 3 ]);
            }
        }
      }
      translate([ 11, 0, 1 ]) union() {
        cube([ 17, 20.5, 5 ], center = true);
        cube([ 17, 18.5, 8 ], center = true);
        *cylinder(r = 8, 10, center = true);
      }
    }
  }
}

module case_top() {
  translate([ 0, 0, 6 ]) cube([ 41, 22, 1 ], center = true);
  color("red") {
    union() {
      translate([ -9, 0, 4 ]) difference() {
        cube([ 20, 18.2, 3 ], center = true);
        cube([ 20, 15, 3 ], center = true);
      }
      translate([ 11, 0, 4 ]) difference() {
        cube([ 16, 20.7, 3 ], center = true);
        cube([ 16, 17.5, 3 ], center = true);
        cube([ 4, 20.5, 3 ], center = true); // IC gap
      }
    }
  }
}


module eyelet() {
  difference() {
    hull() {
      translate([ -4, 2, 0 ]) cube([ 8, 2, 2 ]);
      cylinder(r = 4, 2);
    }
    cylinder(r = 2, 2);
  }
}

module eyelets() {
  for (x = [ -16.5, 0, 16.5 ]) {
    translate([ x, -14.5, -3.5 ]) eyelet();
    translate([ x, 14.5, -3.5 ]) rotate([ 0, 0, 180 ]) eyelet();
  }
}


*case_top();
eyelets();
case_bottom();
*translate([ 0, 0, 1 ]) circuit();