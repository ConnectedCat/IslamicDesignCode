function Edge(a, b) {
  this.a = a;
  this.b = b;

  this.hankin = function() {
    var a = this.a;
    var b = this.b;
    var mid = createVector(a.x + b.x, a.y + b.y);
    mid.mult(0.5);

    var v1 = p5.Vector.sub(a, mid);
    var v2 = p5.Vector.sub(b, mid);
    v1.normalize();
    v2.normalize();

    var mid1 = mid.copy();
    mid1.add(-v1.x * delta, -v1.y * delta);
    var mid2 = mid.copy();
    mid2.add(-v2.x * delta, -v2.y * delta);

    v1.rotate(-radians(angle));
    v2.rotate(radians(angle));
    stroke(255);

    this.ha = new Hankin(mid1, v1);
    this.hb = new Hankin(mid2, v2);
  }

  this.findEnd = function(other) {
    this.ha.findEnd(other.ha);
    this.ha.findEnd(other.hb);
    this.hb.findEnd(other.ha);
    this.hb.findEnd(other.hb);
  }


  this.show = function() {
    stroke(255, 50);
    strokeWeight(1);
    line(this.a.x, this.a.y, this.b.x, this.b.y);
    this.ha.show();
    this.hb.show();
  }
}
