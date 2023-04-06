class Generator{
  int seed, colorSeed, number;
  float detail,colorDetail;
  boolean rx,ry;
  PointMatrix pm;
  ColorMatrix r,g,b,a;
  Generator(int s, int num, float nd, float cd, boolean rx, boolean ry, PointMatrix p, 
  ColorMatrix red, ColorMatrix green, ColorMatrix blue, ColorMatrix alpha){
    seed = s;detail=nd;colorDetail=cd;pm=p;r=red;g=green;b=blue;a=alpha;this.rx=rx;this.ry=ry;number=num;
  }
}

Rock MakeRock(){
  
  //make values
  int seed = int(random(100000));
  int colorSeed = int(random(100000));
  float detail = random(10);
  float nd = 1/detail;
  float colorDetail = random(200);
  float cd = 1/colorDetail;
  int number = int(random(3,200));
  boolean rx = (random(1)>0.3);
  boolean ry = (random(1)>0.3);
  PointMatrix pm = randomPointMatrix();
  ColorMatrix r = randomColorMatrix();
  ColorMatrix g = randomColorMatrix();
  ColorMatrix b = randomColorMatrix();
  ColorMatrix a = randomColorMatrix();
  
  Generator gen = new Generator(seed,number,detail,colorDetail,rx,ry,pm,
  r,g,b,a);
  gen.colorSeed = colorSeed;
  
  
  
  //make points
  
  noiseSeed(seed);
  RockPoint[] rps = new RockPoint[number];
  float rq = TWO_PI/number;
  for(int i=0;i<number;i++){
    float l = pointMatrix(rq*i,pm,nd);
    rps[i] = new RockPoint(l,rq*i,255/2);
  }
  
  //make color
  
  noiseSeed(colorSeed);
  PImage im = createImage(255,255,ARGB);
  //each pixel
  for(int x=0;x<255;x++){
    for(int y=0;y<255;y++){
      
      //which xy to set
      int x2 = x;
      int y2 = y;
      if(rx)
      x2 = 254 - x;
      if(ry)
      y2 = 254 - y;
      
      im.set(x2,y2,color(
      colorMatrix(x,y,r,cd),
      colorMatrix(x,y,g,cd),
      colorMatrix(x,y,b,cd),
      colorMatrix(x,y,a,cd)));
    }
  }
  
  Rock ro = new Rock(rps);
  ro.image = im;
  ro.g=gen;
  return ro;
}
// ---------- random point matrix

PointMatrix randomPointMatrix(){
  float[] rf = new float[4];
  float total = 0;
  for(int i=0;i<4;i++){
    rf[i] = (random(10));
    total+=rf[i];
  }
  total *= random(0.5,1.5);
  return new PointMatrix(
    2/float(round(random(2,30))),
    random(PI),
    (rf[0]/total)*50,
    (rf[1]/total)*50,
    (rf[2]/total)*200,
    (rf[3]/total)*100
  );
}

// ---------- random point matrix





// ---------- random color matrix

ColorMatrix randomColorMatrix(){
  float[] rf = new float[6];
  float total = 0;
  for(int i=0;i<6;i++){
    rf[i] = sq(random(10));
    total+=rf[i];
  }
  total*=random(0.5,1.5);
  return new ColorMatrix(
    (rf[0]/total),
    (rf[1]/total),
    (rf[2]/total),
    (rf[3]/total),
    (rf[4]/total)*255,
    (rf[5]/total)*255,
    round(random(3))*0.9
  );
}

// ---------- random color matrix
