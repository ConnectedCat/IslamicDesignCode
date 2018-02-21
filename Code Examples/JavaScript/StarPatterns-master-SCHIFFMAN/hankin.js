function Hankin(a, v) {
  this.a = a;
  this.v = v;
  this.finished = false;
  this.b = createVector(a.x + v.x * 25, a.y + v.y * 25);
  this.end = undefined;
  this.prevD = undefined;

  this.show = function() {
    stroke(255);
    strokeWeight(4);
    //point(this.a.x, this.a.y);
    // stroke(255, 0, 0);
    // if (this.end) {
    //   point(this.end.x, this.end.y);
    // }
    stroke(255);
    strokeWeight(1);
    //line(this.a.x, this.a.y, this.a.x + this.v.x*20, this.a.y + this.v.y*20);
    if (this.end) {
      line(this.a.x, this.a.y, this.end.x, this.end.y);
    }
  }


  this.findEnd = function(other) {
    
    // from: http://paulbourke.net/geometry/pointlineplane/
    var x1 = this.a.x;
    var y1 = this.a.y;
    var x2 = this.b.x;
    var y2 = this.b.y;
    var x3 = other.a.x;
    var y3 = other.a.y;
    var x4 = other.b.x;
    var y4 = other.b.y;

    var den = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
    var ua = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
    var ub = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);
    ua = ua / den;
    ub = ub / den;

    if (ua > 0 && ub > 0) {
      // there's a chance
      var candidate = createVector(x1 + ua * (x2 - x1), y1 + ua * (y2 - y1));
      var d = p5.Vector.dist(candidate, this.a);
      if (this.prevD == undefined) {
        this.end = candidate;
        this.prevD = d;
      } else if (d < this.prevD) {
        this.end = candidate;
      }
    }
    //this.end = createVector(x1 + ua * (x2 - x1), y1 + ua * (y2 - y1));
  }
}
