// ControlP5 library - GUI for processing (https://www.sojamo.de/libraries/controlP5/)
import controlP5.*;
// Swing library - Class for dialogue windows (https://www.javatpoint.com/java-joptionpane)
import javax.swing.JOptionPane;
// Processing library for SVG epoxrt (https://processing.org/reference/libraries/svg/index.html)
import processing.svg.*;

ControlP5 cp5;
int bgColor = 45; 
int terrainColor = 20;
int hilliness = 1;
int detail = 1;
int noiseSeedValue = 0;
int treeFreq = 2;

boolean changesConfirmed = false; 
boolean showAbout = false;

PrintWriter paramsWriter;

Terrain terrain;
float yPos;
Koch koch;

void setup() {  
  colorMode(HSB);
  fullScreen();
  
  cp5 = new ControlP5(this);
  cp5.addSlider("bgColor")
     .setPosition(20, 20)
     .setSize(200, 20)
     .setRange(0, 360) 
     .setValue(45) 
     .setLabel("Background Color");
     
   cp5.addSlider("terrainColor")
     .setPosition(20, 50)
     .setSize(200, 20)
     .setRange(0, 360) 
     .setValue(20) 
     .setLabel("Terrain Color");
     
  cp5.addSlider("hilliness")
     .setPosition(20, 80)
     .setSize(200, 20)
     .setRange(1, 60) 
     .setValue(15) 
     .setLabel("Hilliness - Flatness");
     
  cp5.addSlider("detail")
     .setPosition(20, 110)
     .setSize(200, 20)
     .setRange(1, 5) 
     .setValue(1) 
     .setLabel("Level of Detail");
     
   cp5.addSlider("treeFreq")
     .setPosition(20, 140)
     .setSize(200, 20)
     .setRange(2, 20) 
     .setValue(2) 
     .setLabel("Tree Frequency");
     
   cp5.addSlider("noiseSeedValue")
     .setPosition(20, 170)
     .setSize(200, 20)
     .setRange(0, 1000) 
     .setValue(0) 
     .setLabel("Noise Seed");
     
  cp5.addButton("confirmChanges")
    .setPosition(20, 200)
    .setSize(200, 20)
    .setLabel("Confirm Changes")
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        changesConfirmed = true; 
      }
    });
    
  cp5.addButton("saveParams")
    .setPosition(20, 230)
    .setSize(200, 20)
    .setLabel("Save Parameters")
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        saveParams();
      }
    });
    
  cp5.addButton("loadParams")
    .setPosition(20, 260)
    .setSize(200, 20)
    .setLabel("Load Parameters")
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        selectInput("Select a file to load parameters:", "loadParams");
      }
    });
    
  cp5.addButton("exportImage")
    .setPosition(20, 290)
    .setSize(200, 20)
    .setLabel("Export Image")
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        exportImage();
      }
    });
    
   cp5.addButton("about")
    .setPosition(20, 320)
    .setSize(200, 20)
    .setLabel("About")
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        showAbout = !showAbout;
        if(showAbout){
          String msg = "<html>FractalScape<br>"
                      + "Author: Tereza Cahová<br>"
                      + "PV097, Spring 2024</html>";
          JOptionPane.showMessageDialog(null, msg, "About FractalScape", JOptionPane.INFORMATION_MESSAGE);
          showAbout = false;
        }
      }
    });

  drawBackground(bgColor);
  koch = new Koch(width/3, -height*0.01, height*0.15, 6, 4);
  koch.show();
  terrain = new Terrain();
  terrain.show();
}

void draw() {   
  if (changesConfirmed) {    
    drawBackground(bgColor);
    
    if (bgColor > 180 && bgColor < 300){
      terrain = new Terrain();
      terrain.show();
      for (int i = 0; i < width * 0.1; i++){
        koch = new Koch(random(width), random(height), height * 0.01, 3, 1);
        koch.show();
      }
    }
    else {
      koch = new Koch(width/3, -height*0.01, height*0.15, 6, 4);
      koch.show();
      terrain = new Terrain();
      terrain.show();
    }
    changesConfirmed = false; 
  } 
}

void drawBackground(float hueValue) {
  noStroke();
  for (float i = width * 2; i > 0; i--) {
    float val = map(i, 0, width, hueValue, hueValue - 40);
    fill(val, 180, 200, 255);
    circle(width/2, height/2, i);
  }
}


void exportImage(){
  String name = "fractalScape" + frameCount;
  
  // export .jpg
  save(name + ".jpg");
  
  // export .svg
  beginRecord(SVG, name + ".svg");
  colorMode(HSB);
  drawBackground(bgColor);
  if (bgColor > 180 && bgColor < 300){
    terrain = new Terrain();
    terrain.show();
    for (int i = 0; i < width * 0.1; i++){
      koch = new Koch(random(width), random(height), height * 0.01, 3, 1);
      koch.show();
    }
  }
  else {
    koch = new Koch(width/3, -height*0.01, height*0.15, 6, 4);
    koch.show();
    terrain = new Terrain();
    terrain.show();
  }
  endRecord();
}


// Logic for saving and loading parameters to/from a textfile 
void saveParams() {
  String filename = "fractalScapeParameters" + frameCount + ".txt";
  paramsWriter = createWriter(filename);
  paramsWriter.println("bgColor=" + bgColor);
  paramsWriter.println("terrainColor=" + terrainColor);
  paramsWriter.println("hilliness=" + hilliness);
  paramsWriter.println("detail=" + detail);
  paramsWriter.println("treeFreq=" + treeFreq);
  paramsWriter.println("noiseSeedValue=" + noiseSeedValue);
  paramsWriter.flush(); 
  paramsWriter.close(); 
}

void loadParams(File selection) {
  if (selection != null) {
    String[] lines = loadStrings(selection.getAbsolutePath());
    for (String line : lines) {
      String[] parts = line.split("=");
      if (parts.length == 2) {
        String key = parts[0];
        String value = parts[1];
        if (key.equals("bgColor")) {
          bgColor = Integer.parseInt(value);
          cp5.getController("bgColor").setValue(bgColor);
        } else if (key.equals("terrainColor")) {
          terrainColor = Integer.parseInt(value);
          cp5.getController("terrainColor").setValue(terrainColor);
        } else if (key.equals("hilliness")) {
          hilliness = Integer.parseInt(value);
          cp5.getController("hilliness").setValue(hilliness);
        } else if (key.equals("detail")) {
          detail = Integer.parseInt(value);
          cp5.getController("detail").setValue(detail);
        } else if (key.equals("treeFreq")) {
          treeFreq = Integer.parseInt(value);
          cp5.getController("treeFreq").setValue(treeFreq);
        } else if (key.equals("noiseSeedValue")) {
          noiseSeedValue = Integer.parseInt(value);
          cp5.getController("noiseSeedValue").setValue(noiseSeedValue);
        }
      }
    }
    changesConfirmed = true;
  }
}
