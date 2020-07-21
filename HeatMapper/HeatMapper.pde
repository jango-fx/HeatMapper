import controlP5.*;

ControlP5 cp5;

PImage mapImage;
PImage backgroundImage;
ArrayList<PVector> data = new ArrayList<PVector>();


@ControlElement (properties = { "min=0", "max=255", "value=255"}, x=20, y=30)
  public int FLOORPLAN_OPACITY;
@ControlElement (properties = { "min=0", "max=255", "value=127"}, x=20, y=50)
  public int HEAT_MAP_OPACITY;

void setup() {
  size(800, 600);
  colorMode(HSB);
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  cp5.addTab("_");
  cp5.addControllersFor(this);
  cp5.hide();

  backgroundImage = loadImage("floorplan2.png");

  //for (int i=0; i<10; i++) {
  //  data.add(  new PVector(random(width), random(height), random(-90, -50))  );
  //}

  mapImage = makeHeatMap(data);
}

void draw() {
  background(255);

  blendMode(BLEND);
  tint(255, FLOORPLAN_OPACITY);
  image(backgroundImage, 0, 0);

  blendMode(MULTIPLY);
  tint(255, HEAT_MAP_OPACITY);
  image(mapImage, 0, 0);

  blendMode(BLEND);
  tint(255, 255);

  for (int i=0; i<data.size(); i++) {
    fill(0);
    text(str(data.get(i).z), data.get(i).x, data.get(i).y);
  }
}

void mouseReleased()
{

  if (cp5.getWindow().getMouseOverList().size() <= 0) {
    data.add(  new PVector(mouseX, mouseY, getWiFiStrength() )  );
    //data.add(  new PVector(mouseX, mouseY, map(noise(mouseX*0.02, mouseY*0.02), 0.0, 1.0, -100, -50) )  );
  }

  PVector[] bounds = getBounds(data);
  MIN_STRENGTH = bounds[0].z;
  MAX_STRENGTH = bounds[1].z;

  mapImage = makeHeatMap(data);
}

void keyPressed()
{
  if (key == ' ')
    saveData(data);
}

PVector[] getBounds(ArrayList<PVector> data)
{
  PVector min = new PVector(Float.MAX_VALUE, Float.MAX_VALUE, Float.MAX_VALUE);
  PVector max = new PVector(Float.MIN_VALUE, Float.MIN_VALUE, -Float.MAX_VALUE);
  for (PVector p : data)
  {
    min.x = min(min.x, p.x);
    min.y = min(min.y, p.y);
    min.z = min(min.z, p.z);

    max.x = max(max.x, p.x);
    max.y = max(max.y, p.y);
    max.z = max(max.z, p.z);
  }
  PVector[] bounds = {min, max};
  return bounds;
}

void saveData(ArrayList<PVector> d)
{
  String[] lines = new String[d.size()];

  for (int i = 0; i < d.size(); i++)
  {
    PVector p = d.get(i);
    lines[i] = p.x +", "+ p.y +", "+ p.z;
  }
  String fileName = "out/"+getTime()+"_data";

  saveStrings(fileName+".csv", lines);
  mapImage.save(fileName+".png");
  println("saved "+fileName);
  
}

String getTime() {
  return new java.text.SimpleDateFormat("yyMMdd-HHmmss", java.util.Locale.GERMANY).format(new java.util.Date());
}
