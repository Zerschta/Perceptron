float[] weights = new float[2];
float bias = 0;
float lr = 0.1;
float[][] inputs = new float[0][2];
int[] labels = new int[0];
int trainStep = 0;
int addLabel = 1;

void setup() {
  size(500, 500);
  frameRate(30);
  weights[0] = random(-1, 1);
  weights[1] = random(-1, 1);
  textSize(13);

  inputs = new float[][]{{0.2, 0.2}, {0.2, 0.8}, {0.8, 0.2}, {0.8, 0.8}};
  labels = new int[]     {0, 0, 1, 1};
}

void draw() {
  background(245);

  for (int x = 0; x < width; x += 8) {
    for (int y = 0; y < height; y += 8) {
      float ix = map(x, 50, 450, -0.5, 1.5);
      float iy = map(y, 450, 50, -0.5, 1.5);
      int p = predict(ix, iy);
      noStroke();
      fill(p == 1 ? color(29, 158, 117, 35) : color(226, 75, 74, 35));
      rect(x, y, 8, 8);
    }
  }

  drawBoundary();

  for (int i = 0; i < inputs.length; i++) {
    float px = map(inputs[i][0], -0.5, 1.5, 50, 450);
    float py = map(inputs[i][1], -0.5, 1.5, 450, 50);
    fill(labels[i] == 1 ? color(29, 158, 117) : color(226, 75, 74));
    noStroke();
    ellipse(px, py, 22, 22);
  }

  fill(60);
  text("w1=" + nf(weights[0], 1, 2) + "  w2=" + nf(weights[1], 1, 2) + "  b=" + nf(bias, 1, 2), 12, 20);
  text("Punkte: " + inputs.length + "   Schritte: " + trainStep, 12, 38);

  fill(addLabel == 1 ? color(29, 158, 117) : color(226, 75, 74));
  text("● Linksklick = " + (addLabel == 1 ? "Gruen (1)" : "Rot (0)"), 12, height - 36);
  fill(100);
  text("R = Farbe wechseln   C = alles loeschen", 12, height - 18);

  if (inputs.length > 0) {
    for (int i = 0; i < 5; i++) {
      int idx = trainStep % inputs.length;
      train(inputs[idx], labels[idx]);
      trainStep++;
    }
  }
}

int predict(float x1, float x2) {
  float sum = x1 * weights[0] + x2 * weights[1] + bias;
  return sum >= 0 ? 1 : 0;
}

void train(float[] inp, int label) {
  int error = label - predict(inp[0], inp[1]);
  weights[0] += lr * error * inp[0];
  weights[1] += lr * error * inp[1];
  bias       += lr * error;
}

void drawBoundary() {
  if (abs(weights[1]) < 0.001) return;
  float x1 = -0.5, x2 = 1.5;
  float y1 = -(weights[0] * x1 + bias) / weights[1];
  float y2 = -(weights[0] * x2 + bias) / weights[1];
  stroke(80, 120, 200);
  strokeWeight(2);
  line(map(x1, -0.5, 1.5, 50, 450), map(y1, -0.5, 1.5, 450, 50),
    map(x2, -0.5, 1.5, 50, 450), map(y2, -0.5, 1.5, 450, 50));
}

void mousePressed() {
  float ix = map(mouseX, 50, 450, -0.5, 1.5);
  float iy = map(mouseY, 450, 50, -0.5, 1.5);

  float[][] newInputs = new float[inputs.length + 1][2];
  for (int i = 0; i < inputs.length; i++) {
    newInputs[i] = inputs[i];
  }
  newInputs[inputs.length] = new float[]{ix, iy};
  inputs = newInputs;

  labels = append(labels, addLabel);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    addLabel = addLabel == 1 ? 0 : 1;
  }
  if (key == 'c' || key == 'C') {
    inputs = new float[0][2];
    labels = new int[0];
    weights[0] = random(-1, 1);
    weights[1] = random(-1, 1);
    bias = 0;
    trainStep = 0;
  }
}
