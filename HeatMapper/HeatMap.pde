/** 
 * based on tomschofield's code at https://forum.processing.org/one/topic/heatmap-using-inverse-distance-weighted-interpolation-solution.html
 * 
 * A processing.org implementation of SHEPARD's METHOD for INVERSE DISTANCE WEIGHTING FOLLOWING FORMULA FOUND AT http://www.ems-i.com/smshelp/Data_Module/Interpolation/Inverse_Distance_Weighted.htm
 * TOMSCHOFIELDART.COM THIS CODE IS FREE UNDER CREATIVE COMMONS NON COMMERCIAL ATTRIBUTION SHARE ALIKE 2012
 */

@ControlElement (properties = { "min=-200", "max=0", "value=-90"}, x=20, y=90)
  public float MIN_STRENGTH;
@ControlElement (properties = { "min=-200", "max=0", "value=-50"}, x=20, y=110)
  public float MAX_STRENGTH;

//returns the a pimage of screen size
PImage makeHeatMap(ArrayList<PVector> d) {
  PImage timg=createImage(width, height, RGB);
  timg.loadPixels();

  loadPixels();

  //maxpossible distance between any 2 pixels is the diagonal distance across the screen
  //float maxDist = sqrt((width*width)+(height*height));

  float x=0.0f;
  float y=0.0f;
  for (int i=0; i<pixels.length; i++) {
    float _hue = getInterpValue( x, y, d);

    // TODO: lerpColor() ?
    color from = color(0);
    color to = color(255);
    color interA = lerpColor(from, to, _hue);

    color aColor=color(255-(255*_hue), 255, 255);
    timg.pixels[i]= aColor;//interA;
    x++;
    if (x>=width) {
      x=0; 
      y++;
    }
  }
  timg.updatePixels();
  return timg;
}

//ITERATES THROUGH ALL THE DATA POINTS AND FINDS THE FURTHERS ONE
float getMaxDistanceFromPoint(float x, float y, ArrayList<PVector> d) {
  float maxDistance=0.0f;
  //get disance between this and each pther point
  for (int i=0; i < d.size(); i++) {
    float thisDist=dist(x, y, d.get(i).x, d.get(i).y);
    //if this distance is greater than previous distances, this is the new max
    if (thisDist>maxDistance) {
      maxDistance=thisDist;
    }
  }
  return maxDistance;
}

//RETURNS AN ARRAY OF THE DISTANCE BETWEEN THIS PIXEL AND ALL DATA POINTS
float [] getAllDistancesFromPoint(float x, float y, ArrayList<PVector>d) {
  float [] allDistances = new float [d.size()];
  for (int i=0; i<d.size(); i++) { 
    allDistances[i]= dist(x, y, d.get(i).x, d.get(i).y);
  }

  return allDistances;
}


//RETURNS THE ACTUAL WEIGHTED VALUE FOR THIS PIXEL
float getInterpValue(float x, float y, ArrayList<PVector> d) {
  float interpValue=0.0f;

  for (int i=0; i < d.size(); i++) {
    float maxDist = getMaxDistanceFromPoint( x, y, d);
    float [] allDistances = getAllDistancesFromPoint( x, y, d);
    float thisDistance = dist(x, y, d.get(i).x, d.get(i).y);
    interpValue += map(d.get(i).z, MAX_STRENGTH, MIN_STRENGTH, 1.0, 0.0) * getWeight( maxDist, thisDistance, allDistances );
    //interpValue += d.get(i).z * getWeight( maxDist, thisDistance, allDistances );
  }
  return interpValue;
}


//THE WEIGHT IS THE VALUE COEFFICIENT (? RIGHT TERM) BY WHICH WE WILL MULTIPLY EACH VALUE TO GET THE CORRECT WEIGHTING
float getWeight(float maxDistance, float thisDistance, float [] allDistances ) {
  float weight=0.0f;
  float firstTerm = pow(((maxDistance - thisDistance   )/( maxDistance * thisDistance  )), 2);
  float secondTerm=0.0f;
  for (int i=0; i<allDistances.length; i++) {
    secondTerm+=pow(((maxDistance - allDistances[i]   )/( maxDistance * allDistances[i]  )), 2);
  }
  weight = firstTerm/secondTerm;
  return weight;
} 
