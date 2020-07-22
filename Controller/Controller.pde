import themidibus.*;
import javax.sound.midi.MidiMessage;


color red   = color(255, 0, 0),
      green = color(0, 255, 0);

boolean note1,
        note2,
        note3,
        note4,
        note5,
        note6,
        note7,
        note8,
        downOffset,
        upOffset;

int offset = 0;

MidiBus bus;

void setup() {
  size(676, 120);
  
  note1 = note2 = note3 = note4 = note5 = note6 = note7 = note8 = downOffset = upOffset = false;
  
  bus = new MidiBus(this, 0, 3); //0 input, 3 output
  
  println(bus.attachedInputs());
  println(bus.attachedOutputs());
}

void draw() {
    
  for (int x = 75; x <= 600; x += 75) {
    fill(red);
    switch(x/75) {
    case 1:
      if (note1)
        fill(green);
      break;
    case 2:
      if (note2)
        fill(green);
      break;
    case 3:
      if (note3)
        fill(green);
      break;
    case 4:
      if (note4)
        fill(green);
      break;
    case 5:
      if (note5)
        fill(green);
      break;
    case 6:
      if (note6)
        fill(green);
      break;
    case 7:
      if (note7)
        fill(green);
      break;
    case 8:
      if (note8)
        fill(green);
      break;
    }
    circle(x, 75, 50);
  }
  
  fill(red);
  if (downOffset)
    fill(green);
    
   rect(0, 0, 50, 25);
   
  fill(red);
  if (upOffset)
    fill(green);
    
   rect(625, 0, 50, 25);
}

void keyPressed()
{
  if (key == 'q') {
    offset -= 12;
    downOffset = true;
  }
  else if (key == 'p') {
    offset += 12;
    upOffset = true;
  }
  else {
    int note = 0;
    switch(key) {
      case 'a': //1 - C3
        note1 = true;
        note = 48;
        break;
      case 's': //2 - D3
        note2 = true;
        note = 50;
        break;
      case 'd': //3 - E3
        note3 = true;
        note = 52;
        break;
      case 'f': //4 - F3
        note4 = true;
        note = 53;
        break;
      case 'g': //5 - G3
        note5 = true;
        note = 55;
        break;
      case 'h': //6 - A3
        note6 = true;
        note = 57;
        break;
      case 'j': //7 - B3
        note7 = true;
        note = 59;
        break;
      case 'k': //8 - C4
        note8 = true;
        note = 60;
        break;
    }
    
    bus.sendNoteOn(0, note + offset, (note > 0) ? 127 : 0);
  }
}

void keyReleased()
{
  if (key == 'q') {
    offset += 12;
    downOffset = false;
  }
  else if (key == 'p') {
    offset -= 12;
    upOffset = false;
  }
  else {
    int note = 0;
    switch(key) {
      case 'a': //1 - C3
        note1 = false;
        note = 48;
        break;
      case 's': //2 - D3
        note2 = false;
        note = 50;
        break;
      case 'd': //3 - E3
        note3 = false;
        note = 52;
        break;
      case 'f': //4 - F3
        note4 = false;
        note = 53;
        break;
      case 'g': //5 - G3
        note5 = false;
        note = 55;
        break;
      case 'h': //6 - A3
        note6 = false;
        note = 57;
        break;
      case 'j': //7 - B3
        note7 = false;
        note = 59;
        break;
      case 'k': //8 - C4
        note8 = false;
        note = 60;
        break;
    }
    
    bus.sendNoteOff(0, note + offset, (note > 0) ? 100 : 0);
  }
}
