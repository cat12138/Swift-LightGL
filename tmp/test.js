
function Vector(x, y, z) {
	this.x = x;
	this.y = y;
	this.z = z;
}

var hit = new Vector(10, 20, 30);
var max = new Vector(8, 22, 19);
var min = new Vector(6, 10, 29);


console.log((hit.x > max.x) - (hit.x < min.x));


