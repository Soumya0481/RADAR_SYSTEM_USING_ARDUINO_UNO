import processing.serial.*;
Serial myPort;

String data = "";
float angle = 0, dist = 0;

PGraphics greenTrail;
PGraphics redTrail;

// Small range for clean radar
int radarRange = 400;

void setup() {
  size(1900, 1080);
  smooth();

  greenTrail = createGraphics(width, height);
  redTrail   = createGraphics(width, height);

  myPort = new Serial(this, "COM7", 9600);
  myPort.bufferUntil('\n');
}

void serialEvent(Serial p) {
  data = p.readStringUntil('\n');
  if (data == null) return;

  data = trim(data);
  String[] v = split(data, ',');

  if (v.length == 2) {
    angle = float(v[0]);
    dist  = float(v[1]);
  }
}

void draw() {

  background(0);

  // Draw trails
  image(greenTrail, 0, 0);
  image(redTrail, 0, 0);

  // ----- WARNING TEXT TOP CENTER -----
  if (dist > 0 && dist <= 15) {
    fill(255,0,0);
    textAlign(CENTER);
    textSize(42);
    text("⚠ WARNING: OBJECT IS NEAR!", width/2, 80);
  }

  // Move radar center
  translate(width/2, height - 220);

  stroke(0,255,0);
  strokeWeight(2);
  noFill();

  // ----- RADAR GRID -----
  arc(0,0, radarRange*2.4, radarRange*2.4, PI, TWO_PI);
  arc(0,0, radarRange*1.8, radarRange*1.8, PI, TWO_PI);
  arc(0,0, radarRange*1.2, radarRange*1.2, PI, TWO_PI);
  arc(0,0, radarRange*0.6, radarRange*0.6, PI, TWO_PI);

  // Degree lines + labels
  for (int a = 0; a <= 180; a += 30) {
    float r = radians(a);
    line(0, 0, radarRange*cos(r), -radarRange*sin(r));

    fill(0,255,0);
    textSize(22);
    text(a + "°", (radarRange+50)*cos(r), -(radarRange+50)*sin(r));
  }

  // Distance labels
  fill(0,255,0);
  text("10cm", 0, -radarRange*0.25);
  text("20cm", 0, -radarRange*0.50);
  text("30cm", 0, -radarRange*0.75);
  text("40cm", 0, -radarRange*1.00);

  float rad = radians(angle);

  // ----- GREEN SWEEP LINE -----
  stroke(0,255,0);
  strokeWeight(3);
  line(0,0, radarRange*cos(rad), -radarRange*sin(rad));

  // ----- GREEN TRAIL (NOISE-FREE) -----
  greenTrail.beginDraw();
  greenTrail.noStroke();
  greenTrail.fill(0,255,0,18);
  greenTrail.triangle(width/2, height-220,
                      width/2 + radarRange*cos(rad),
                      height-220 - radarRange*sin(rad),
                      width/2 + radarRange*cos(rad+radians(1)),
                      height-220 - radarRange*sin(rad+radians(1)));
  greenTrail.endDraw();

  // ===== OBJECT DETECTION RED EFFECTS =====
  if (dist > 0 && dist <= 40) {

    float d = map(dist, 0, 40, 0, radarRange);

    // Red main detection line
    stroke(255,0,0,180);
    strokeWeight(6);
    line(0, 0, d*cos(rad), -d*sin(rad));

    // Red dot
    noStroke();
    fill(255,0,0);
    ellipse(d*cos(rad), -d*sin(rad), 22, 22);

    // ----- LONG RED TRAIL -----
    redTrail.beginDraw();
    redTrail.noStroke();
    redTrail.fill(255,0,0,25);
    redTrail.triangle(width/2, height-220,
                      width/2 + (d+120)*cos(rad),             // +120 = LONG TRAIL
                      height-220 - (d+120)*sin(rad),
                      width/2 + (d+120)*cos(rad + radians(2)),
                      height-220 - (d+120)*sin(rad + radians(2)));
    redTrail.endDraw();

  } else {

    // ----- CLEAR RED TRAIL WHEN NO OBJECT -----
    redTrail.beginDraw();
    redTrail.clear();
    redTrail.endDraw();
  }

  // ----- BOTTOM INFO BAR -----
  fill(0);
  noStroke();
  rect(-650, 140, 1300, 80);

  // ----- INFO TEXT -----
  fill(0,255,0);
  textAlign(LEFT);
  textSize(30);

  text("VIRAL SCIENCE", -450, 185);
  text("Angle : " + int(angle) + "°", -80, 185);
  text("Distance : " + int(dist) + " cm", 220, 185);
}
