
// ---------- load XML

//from name or id
Rock loadRock(String name){
  XML[] c = root.getChild("rocks").getChildren("rock");
  for(int i=0;i<c.length;i++){
    if(c[i].getString("name").equals(name) || c[i].getString("Id").equals(name))
    return XMLGenerator(c[i].getChild("generator"));
  }
  return null;
}

//from index
Rock loadRock(int index){
  XML[] c = root.getChild("rocks").getChildren("rock");
  if(index<c.length)
  return XMLGenerator(c[index].getChild("generator"));
  return null;
}

// ---------- load XML




// ---------- From XML

Rock XMLGenerator(XML gen){  
  //the noise xml
  XML noiseXML = gen.getChild("noise");
  
  //xy multiplier
  float nd = 1/noiseXML.getFloat("detail");
  //color xy multiplier
  float cd = 1/noiseXML.getFloat("colordetail");
  //set the seed
  noiseSeed(noiseXML.getInt("seed"));
  
  //the points xml
  XML pointsXML = gen.getChild("points");
  
  //number of points
  int numPoints = pointsXML.getInt("number");
  
  //the matrix for points
  PointMatrix pm = new PointMatrix(pointsXML.getContent());
  
  //the pts
  RockPoint[] rps = new RockPoint[numPoints];
  //the angle of change
  float rq = TWO_PI/numPoints;
  
  //for all the points
  for(int i=0;i<numPoints;i++){
    //length
    float l = pointMatrix(rq*i,pm,nd);
    //rockpoint
    rps[i] = new RockPoint(l,rq*i,float(255)/2);
  }
  
  //the color XML
  XML colorsXML = gen.getChild("colors");
  //image
  PImage im;
  
  //can be transparent?
  if(colorsXML.hasAttribute("a"))
  im = createImage(255,255,ARGB);
  else
  im = createImage(255,255,RGB);
  
  ColorMatrix red = new ColorMatrix(colorsXML.getString("r"));
  ColorMatrix green = new ColorMatrix(colorsXML.getString("g"));
  ColorMatrix blue = new ColorMatrix(colorsXML.getString("b"));
  ColorMatrix alpha = null;
  if(colorsXML.hasAttribute("a"))
  alpha = new ColorMatrix(colorsXML.getString("a"));

  if(noiseXML.hasAttribute("colorSeed"))
  noiseSeed(noiseXML.getInt("colorSeed"));
  
  //each pixel
  for(int x=0;x<255;x++){
    for(int y=0;y<255;y++){
      
      //which xy to set
      int x2 = x;
      int y2 = y;
      if(colorsXML.getString("rx").equals("true"))
      x2 = 254 - x;
      if(colorsXML.getString("ry").equals("true"))
      y2 = 254 - y;
      
      //get the rgb
      float r = colorMatrix(x,y,red,cd);
      float g = colorMatrix(x,y,green,cd);
      float b = colorMatrix(x,y,blue,cd);
      
      //if has transparent
      if(colorsXML.hasAttribute("a")){
        //get alpha
        float a = colorMatrix(x,y,alpha,cd);
        //set pixel
        im.set(x2,y2,color(r,g,b,a));
      }else{
        //set pixel
        im.set(x2,y2,color(r,g,b));
      }
      
    }
  }
  
  Rock r = new Rock(rps);
  r.image = im;
  r.Id = gen.getParent().getString("Id");
  r.Name = gen.getParent().getString("name");
  return r;
}

// ---------- From XML





// ---------- color

//make r,g,b, or a value from string
float colorMatrix(int x,int y,String m,float nd){
  String[] ms = m.split(",");
  float[] msf = new float[ms.length];
  for(int i=0;i<msf.length;i++){
    msf[i] = parseFloat(ms[i]);
  }
  return abs(
  x*msf[0]+
  y*msf[1]+
  msf[2]*min(x,y)+
  msf[3]*max(x,y)+
  msf[4]*noise(x*nd,y*nd,msf[6])+
  msf[5]);
}
//with colormatrix
float colorMatrix(int x,int y,ColorMatrix cm,float nd){
  return abs(
  x*cm.X+
  y*cm.Y+
  cm.Min*min(x,y)+
  cm.Max*max(x,y)+
  cm.Noise*noise(x*nd,y*nd,cm.NoiseOffset)+
  cm.Offset);
}

//color matrix class
class ColorMatrix{
  float X, Y, Min, Max, Noise, Offset, NoiseOffset;
  
  //floats
  ColorMatrix(float x,float y, float min, float max, float noise, float off, float noiseOff){
    X=x;Y=y;Min=min;Max=max;Noise=noise;Offset=off;NoiseOffset=noiseOff;
  }
  //from string
  ColorMatrix(String s){
    String[] ss = s.split(",");
    float[] fs = new float[ss.length];
    for(int i=0;i<ss.length;i++){
      fs[i] = parseFloat(ss[i]);
    }
    if(fs.length>=6){
      X=fs[0];Y=fs[1];Min=fs[2];Max=fs[3];Noise=fs[4];Offset=fs[5];
      if(fs.length>=7)
      NoiseOffset=fs[6];
      else
      NoiseOffset=0;
    }
    
  }
  String string(){
    return X+","+Y+","+Min+","+Max+","+Noise+","+Offset+","+NoiseOffset;
  }
}

// ---------- color



// ---------- shape

//point generation matrix
class PointMatrix{
  float E,F,Sine,Cos,Noise,Offset;
  
  //from floats
  PointMatrix(float e,float f, float sine, float cos, 
  float noise, float off){
    E=e;F=f;Sine=sine;Cos=cos;Noise=noise;Offset=off;
  }
  
  //from string
  PointMatrix(String s){
    String[] ss = s.split(",");
    float[] fs = new float[ss.length];
    for(int i=0;i<ss.length;i++){
      fs[i] = parseFloat(ss[i]);
    }
    if(fs.length>=6){
      E=fs[0];F=fs[1];Sine=fs[2];Cos=fs[3];Noise=fs[4];Offset=fs[5];
    }
  }
  String string(){
    return E+","+F+","+Sine+","+Cos+","+Noise+","+Offset;
  }
}

//get the length
float pointMatrix(float r, PointMatrix p,float nd){
  //theta
  float t = (p.F+r)/p.E;
  //noise value
  float nv = noise(nd*sin(r)+12.4,nd*cos(r)+54.2);
  //length
  float l = p.Sine*abs(sin(t)) + p.Cos*abs(cos(t)) + p.Noise*nv + p.Offset;
  return l;
}

// ---------- shape
