const int trigPin = 9;
const int echoPin = 10;

const int buzzer = 5;
const int led = 6;

int angle = 0;
bool forwardSweep = true;

long duration;
int distance;

void setup() {
  Serial.begin(9600);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  pinMode(buzzer, OUTPUT);
  pinMode(led, OUTPUT);

  digitalWrite(buzzer, LOW);
  digitalWrite(led, LOW);
}

void loop() {

  // ---- Angle sweep simulation (NO SERVO) ----
  if (forwardSweep) {
    angle++;
    if (angle >= 180) forwardSweep = false;
  } else {
    angle--;
    if (angle <= 0) forwardSweep = true;
  }

  delay(15);

  // ---- Distance Measurement ----
  distance = getDistance();

  // ---- Alert (distance < 20 cm) ----
  if (distance > 0 && distance < 20) {
    digitalWrite(buzzer, HIGH);
    digitalWrite(led, HIGH);
  } else {
    digitalWrite(buzzer, LOW);
    digitalWrite(led, LOW);
  }

  // ---- Send angle,distance to Processing ----
  Serial.print(angle);
  Serial.print(",");
  Serial.println(distance);

  delay(20);
}

int getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duration = pulseIn(echoPin, HIGH, 30000);
  int dist = duration * 0.034 / 2;

  if (dist <= 0 || dist > 400) dist = 400;
  return dist;
}
