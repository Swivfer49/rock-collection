


class Rock{
  RockPoint[] points;
  float aa = 0.15;
  PImage image;
  String Name, Id;
  Generator g = null;
  
  Rock(RockPoint[] pts){
    points = pts;
    image = createImage(255,255,RGB);
    for(int x=0;x<255;x++){
      for(int y=0;y<255;y++){
        image.set(254-x,254-y,color(y,min(x,y),x));
      }
    }
  }
  
  
  void display(int x,int y){
    noStroke();
      beginShape();
      texture(image);
      for(int i=0;i<points.length;i++){
        vertex(x+points[i].Point.x,y+points[i].Point.y,points[i].rP.x,points[i].rP.y);
      }
      endShape(CLOSE);
  }
  
  XML toXML(){
    if(g==null)return null;
    XML roc = parseXML("<rock> <generator> <noise> </noise> <points></points> <colors></colors> </generator> </rock>");
    XML noise = roc.getChild("generator").getChild("noise");
    noise.setInt("seed",g.seed);
    noise.setInt("colorSeed",g.colorSeed);
    noise.setFloat("detail",g.detail);
    noise.setFloat("detail",g.detail);
    XML pts = roc.getChild("generator").getChild("points");
    pts.setInt("number",g.number);
    pts.setContent(g.pm.string());
    XML colors = roc.getChild("generator").getChild("colors");
    colors.setString("rx",""+g.rx);
    colors.setString("ry",""+g.ry);
    colors.setString("r",g.r.string());
    colors.setString("g",g.g.string());
    colors.setString("b",g.b.string());
    colors.setString("a",g.a.string());
    if(Name!=null){
      roc.setString("name",Name);
    }else
    roc.setString("name",""+this);
    if(Id!=null){
      roc.setString("Id",Id);
    }else
    roc.setString("Id",""+this);
    return roc;
  }
  
  
}




class RockPoint{
  float length;
  float angle;
  PVector Point;
  PVector rP;
  RockPoint(float l, float a,float w){
    length = l;
    angle = a;
    Point = Point();
    rP = rPoint(w);
  }
  
  RockPoint(PVector p,float w){
    length = p.mag();
    float rAngle = 0;
    if(p.x == 0){rAngle = HALF_PI;
      if(p.y < 0){angle = rAngle + PI;
      }else angle = rAngle; }
    else if(p.y == 0){rAngle = 0;
      if(p.x < 0){angle = PI;
      }else angle = 0; }
    else{atan(p.y/p.x);
      if(p.x>0&&p.y>0){angle = rAngle;
      }else if(p.x<0&&p.y>0){angle = PI - rAngle;
      }else if(p.x<0&&p.y<0){angle = PI + rAngle;
      }else{angle = TWO_PI - rAngle;}}
      
      Point = p;
      rP = rPoint(w);
  }
  PVector Point(){
    return new PVector(cos(angle)*length,sin(angle)*length);
  }
  PVector rPoint(float w){
    if(abs(Point.x)>abs(Point.y)){
      float r = w/Point.x;
      return new PVector(round(abs(r)*Point.x+w),round(abs(r)*Point.y+w));
    }else{
      float r = w/Point.y;
      return new PVector(round(abs(r)*Point.x+w),round(abs(r)*Point.y+w));
    }
  }
}
