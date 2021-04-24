
var capture = true;
var capturer = new CCapture({ format: 'png', framerate: 60 })
var NUM_FRAMES = 60 * 60;

var circles = [];
var colorList = [];

function setup() {
    var s = min(windowWidth, windowHeight);
    createCanvas(s, s);

    colorList = [color('#95ECD7F0'),
                 color('#6BB8FaF0'),
                 color('#EC889aF0'),
                 color('#FBC52aF0')]

    for (var k = 0; k < 128; k++) {
        circles.push(new Circle());
    }
}

function draw() {
    if (capture && frameCount == 1) {
        capturer.start()
    }

    background(0);

    translate(width / 2.0, height / 2.0);

    for (var k = 0; k < circles.length; k++) {
        if (circles[k].alive) {
            circles[k].draw();
        } else {
            var rw = 50;
            var ri = (int(frameCount) % int(width * 0.6)) / rw;
            var r = random(ri * rw, (ri + 1) * rw);
            var a = random(TWO_PI);
            var x = r * cos(a);
            var y = r * sin(a);
            var p = createVector(x, y);
            circles[k].init(p);
        }
    }

    if (capture){
        capturer.capture( canvas ); // if capture is 'true', save the frame
        if (frameCount-1 == NUM_FRAMES){ //stop and save after NUM_FRAMES
            capturer.stop();
            capturer.save();
            noLoop();
        }
    }
}

function radius(t, r) {
    var f = r * (exp(-t) - exp(-3*t)) / (pow(3, -1.0/2.0) - pow(3, -3.0/2.0));
    return max(f, 0);

}

function drawShape(n, r) {
    beginShape();
    for (var k = 0; k < n; k++) {
        var t = k * TWO_PI / n;
        var x = r * cos(t);
        var y = r * sin(t);
        vertex(x, y);
    }
    endShape(CLOSE);
}

function windowResized() {
    resizeCanvas(windowWidth, windowHeight);
}

class Circle {
    constructor() {
        this.alive = false;
    }

    init(position) {
        this.position = position;
        this.lifetime = 0.0;
        this.timestep = random(0.025, 0.075);
        this.r = random(80, 100);
        this.alive = true;
        this.n = int(random(3, 8));
        this.rot = random(TWO_PI);
        this.pen = colorList[int(random(colorList.length))];
    }

    draw() {
        var s = radius(this.lifetime, this.r);

        noFill();
        stroke(this.pen);
        strokeWeight(4.0);

        push();
        translate(this.position.x, this.position.y);
        rotate(this.rot);
        if (this.n == 7) {
            ellipse(this.position.x, this.position.y, s, s);
        } else {
            drawShape(this.n, s);
        }
        pop();

        this.lifetime += this.timestep;

        if (this.lifetime >= 9.0) {
            this.alive = false;
        }
    }
}
