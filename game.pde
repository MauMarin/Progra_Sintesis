import themidibus.*;
import javax.sound.midi.MidiMessage;

interface DrawState {
  void draw();
};

/**
 * Track : manage track drawing.
 */
private class Track {
  
  float   tHue;       // track hue
  float   tRadius;    // track radius
  float   sRadian;    // drawing start angle
  float   pSize;      // drawing size
  float   pDiv;       // gap of each drawing point
  int     tick;       // time tick
  int     sweepStart; // sweep start time
  int     sweepCnt;   // how long to sweep
  float   ell_width;  // width of an ellipse
  float   ell_mov;    // moves the ellipse inside a track
  boolean cold;       // dictates the color range of the circles
  float   saturation;  
  float   brightness;  //
  
  DrawState drawState, pattern, filler;
  
  Track(float _tHue, float _tRadius, float _sRadian, float _pSize, float _pDiv, boolean _cold, float _saturation, float _brightness) {
    tHue    = _tHue;
    tRadius = _tRadius;
    sRadian = _sRadian;
    pSize   = _pSize;
    pDiv    = _pDiv;
    cold    = _cold;
    saturation = _saturation;
    brightness = _brightness;

    tick       = 0;
    sweepStart = 0;
    sweepCnt   = 30;
    ell_width  = random(0.3, 0.6);
    ell_mov   = random(0, 0.5);

    pattern   = new Pattern();
    filler    = new Filler();
    drawState = filler;
  }
  
  public void fillCold(float curr){
    if(curr >= 90 && curr <= 270) fill(curr, saturation, brightness, 100.0);
    else if (curr < 90) fill(270 - curr, saturation, brightness, 100.0);
    else{
      float offset = 360 - curr;
      fill(270 - offset, saturation, brightness, 100.0);
    }  
  }
  
  public void fillWarm(float curr){
    if(curr <= 90 || curr >= 270) fill(curr, saturation, brightness, 100.0);
    else if(curr > 90 && curr <= 180){
      float offset = abs(90 - curr);
      fill(offset, saturation, brightness, 100.0);
    }
    else if(curr > 180 && curr < 270){
      float offset = 360 - abs(180 - curr);
      fill(offset, saturation, brightness, 100.0);
    }
  }

  public void circulate() {
    
    if(cold){
      float curr = tHue % 360;
      fillCold(curr);
    }
    
    else{
      float curr = tHue % 180;
      fillWarm(curr);
    }
    
    if (toggle) {
      tick++;
      
      drawState.draw();
      if (tick > sweepStart + sweepCnt) {
        drawState = pattern;
      }
    }
  }
  
  public void sweep() {
    drawState  = filler;
    sweepStart = tick;
    tHue += random(30.0, 120.0);  // Cambio de HUE con cada iteración
    pDiv = random(0.1, 0.7);      // Cambio de patrón con cada iteración
  }

/**
 * Pattern : draw checker pattern.
 */
  private class Pattern implements DrawState {
    public void draw() {
      blendMode(DIFFERENCE);  // Always changes the color of the ellipse
      pushMatrix();
      fill(60, 255, 249);
      rotate(sRadian + tick * PI * (pDiv + ell_mov));
      ellipse(tRadius, 0.0, pSize * ell_width, pSize);
      popMatrix();
    }
  }
  
  /**
 * Filler : fill with plain color.
 */
  private class Filler implements DrawState {
    public void draw() {
      blendMode(BLEND);
      pushMatrix();
      rotate(sRadian + tick * pSize / tRadius);
      rect(tRadius , 0.0, pSize, pSize);
      for (int i = 0; i < 2; i++) {
        rotate(PI * 2.0 / 3.0);
        rect(tRadius , 0.0, pSize, pSize);
      }
      popMatrix();
    }
  }
  
}






/**
  _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
 * MAIN
 _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
 */
float baseHue = random(360.0);
ArrayList<Track> tracks = new ArrayList();
int frames = 0;  // 300
boolean cold = true;
boolean toggle = false;
int maxFrames = 200;  //25 frames por tick

MidiBus midi_bus;

float baseSat = random(50.0, 100.0);
float baseBright = random(50.0, 100.0);




void setup() {
  midi_bus = new MidiBus(this, 0, 1);
  size(1920, 1080);
  colorMode(HSB, 360.0, 100.0, 100.0, 100.0);
  rectMode(CENTER);
  background(0.0, 0.0, 100.0, 100.0);
  smooth();
  noStroke();

  float trackCnt = 9;
  float radius   = 120.0;
  float radian   = random(TWO_PI);
  float pDiv     = floor(random(1.0, 5.0)) * 0.1;
  
  for (int i = 0; i < trackCnt; i++) {
    float pSize = map(i, 0, trackCnt, 50.0, 40.0);
    tracks.add(new Track(
                       baseHue + 30.0 * (i % trackCnt),
                       radius,
                       radian,
                       pSize,
                       pDiv,
                       cold,
                       baseSat + 30.0 * (i % trackCnt),
                       baseBright + 30.0 * (i % trackCnt)));
    radius += pSize + random(-1.0, 1.0); // (- 1.0) makes nice sweep.
    radian += PI * 2.0 / 3.0;
  }
}

void draw() {               
  translate(width * 0.5, height * 0.5);     //Centra los tracks al centro de la pantalla
  
  if(toggle) frames++;

  if (frames == maxFrames) {              // % es qué tan rápido se le hace reset
    frames = 0;
    for (Track t : tracks) {
      t.sweep();                            // Reset a los tracks para que aparezca un patrón y colores nuevos
    }
  }
  
  for (Track t : tracks) {
    t.circulate();                          // Patrón dentro de ck
  }
  
  if(toggle & frames % (maxFrames / 8) == 0){
    toggle = false;
  }
}



void midiMessage(MidiMessage message) {
  int note = (int) (message.getMessage()[1] & 0xFF);
  
  // Depending on the note that comes from SC, a different animation with its respective horizontal movement is played
  // .ignoreRepeat() is used to run the gif just once, in order to coordinate movement with the sound input
  switch(note) {
    case 10: //idle
      toggle = true;
      
    default:
     break;
  }
}
