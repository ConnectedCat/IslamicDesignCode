var delta = 10;
var angle = 60;//3437.7467707849396;

var slider1;
var slider2;

function setup() {
  createCanvas(400, 400);
  //angleMode(DEGREES);
  slider1 = createSlider(0, 40, 5);
  slider2 = createSlider(0, 45, 25);
}

function draw() {
  background(0);
  delta = slider1.value();
  angle = slider2.value();
  console.log(delta, angle);

  var polys = [];
  for (var x = 0; x < width; x += 50) {
    for (var y = 0; y < width; y += 50) {
      poly = new Polygon();
      poly.addVertex(createVector(x, y));
      poly.addVertex(createVector(x + 50, y));
      poly.addVertex(createVector(x + 50, y + 50));
      poly.addVertex(createVector(x, y + 50));
      poly.createEdges();
      polys.push(poly);
    }
  }

  for (var i = 0; i < polys.length; i++) {
    polys[i].show();
  }
}
