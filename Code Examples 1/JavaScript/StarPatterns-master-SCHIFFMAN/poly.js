function Polygon() {
  this.verts = [];
  this.edges = [];
  // this.hankins = [];

  this.addVertex = function(v) {
    this.verts.push(v);
  }

  this.createEdges = function() {
    var len = this.verts.length;
    for (var i = 0; i < len; i++) {
      var a = this.verts[i];
      var b = this.verts[(i + 1) % len];
      var edge = new Edge(a,b);
      this.edges.push(edge);
      edge.hankin();
      // this.hankins.push(edge.ha);
      // this.hankins.push(edge.hb);
    }

    for (var i = 0; i < this.edges.length; i++) {
      var edge = this.edges[i];
      for (var j = 0; j < this.edges.length; j++) {
        if (edge !== this.edges[j]) {
          edge.findEnd(this.edges[j]);
        }
      }
    }


    // for (var i = 0; i < this.hankins.length; i+=2) {
    //   var ha = this.hankins[i];
    //   var hb = this.hankins[(i+3)%this.hankins.length];
    //   ha.findEnd(hb);
    //   hb.findEnd(ha);
    // }

  }

  this.show = function() {
    for (var i = 0; i < this.edges.length; i++) {
      this.edges[i].show();
    }
    // for (var i = 0; i < this.hankins.length; i++) {
    //   this.hankins[i].show();
    // }
  }
}
