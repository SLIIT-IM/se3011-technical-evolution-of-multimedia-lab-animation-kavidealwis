// --- VARIABLES FROM ACTIVITIES ---
int state = 0;        // Activity 6: 0=Start, 1=Play, 2=End
int startTime;
int duration = 30;    // Activity 6: modified to 30s
int score = 0;

float px = 350, py = 175; // Activity 4: Player position
float step = 6;
float pr = 20;

float hx, hy;             // Activity 5: Helper position
float ease = 0.10;

float ox = 100, oy = 100; // Activity 3: Orb position
float osx = 4, osy = 3;   // Activity 3: Orb speed
float or = 15;            // Orb radius

boolean trails = false;   // Activity 2: Trail toggle

void setup() {
  size(700, 350);
  hx = px; // Activity 5 init
  resetOrb();
}

void draw() {
  // Activity 2: Trail Toggle Logic
  if (!trails) {
    background(245); 
  } else {
    noStroke();
    fill(245, 35); 
    rect(0, 0, width, height);
  }

  // Activity 6: State Switching
  if (state == 0) {
    drawStart();
  } else if (state == 1) {
    runGame();
  } else if (state == 2) {
    drawEnd();
  }
}

// --- SCREEN FUNCTIONS ---

void drawStart() {
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(0);
  text("CATCH THE ORB\nPress ENTER to Start", width/2, height/2);
}

void runGame() {
  // 1. Timer Logic (Activity 6)
  int elapsed = (millis() - startTime) / 1000;
  int left = duration - elapsed;
  if (left <= 0) state = 2;

  // 2. Player Control (Activity 4)
  if (keyPressed) {
    if (keyCode == RIGHT) px += step;
    if (keyCode == LEFT)  px -= step;
    if (keyCode == DOWN)  py += step;
    if (keyCode == UP)    py -= step;
  }
  px = constrain(px, pr, width - pr);
  py = constrain(py, pr, height - pr);

  // 3. Helper Easing (Activity 5)
  hx = hx + (px - hx) * ease;
  hy = hy + (py - hy) * ease;

  // 4. Orb Bouncing (Activity 3)
  ox += osx;
  oy += osy;
  if (ox > width - or || ox < or) osx *= -1;
  if (oy > height - or || oy < or) osy *= -1;

  // 5. Collision Check (The "Catch" Logic)
  if (dist(px, py, ox, oy) < pr + or) {
    score++;
    resetOrb();     // Move orb randomly
    osx *= 1.1;     // Increase speed (Activity 3)
    osy *= 1.1;
  }

  // 6. Draw Everything
  fill(255, 120, 80); ellipse(ox, oy, or*2, or*2); // Orb
  fill(60, 120, 200);  ellipse(px, py, pr*2, pr*2); // Player
  fill(80, 200, 120);  ellipse(hx, hy, 16, 16);     // Helper

  // UI (Activity 2 & 6)
  fill(0);
  textAlign(LEFT, TOP);
  textSize(16);
  text("Score: " + score, 20, 20);
  text("Time Left: " + left, 20, 40);
  text("Trails: " + (trails ? "ON" : "OFF") + " (T)", 20, 60);
}

void drawEnd() {
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(0);
  text("Final Score: " + score + "\nPress R to Restart", width/2, height/2);
}

// --- INPUT & HELPERS ---

void keyPressed() {
  // Activity 6: Start and Reset
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
    score = 0;
  }
  if (state == 2 && (key == 'r' || key == 'R')) {
    state = 0;
    osx = 4; osy = 3; // Reset speed
  }
  
  // Activity 2: Toggle Trails
  if (key == 't' || key == 'T') {
    trails = !trails;
  }
}

void resetOrb() {
  ox = random(or, width - or);
  oy = random(or, height - or);
}
