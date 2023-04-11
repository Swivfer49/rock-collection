Rock r;
boolean load = false;

XML root,rocks;
int idr = 0;

void setup(){
  size(1000,1000,P2D);
  root = loadXML("data/Collection.xml");
  rocks = root.getChild("rocks");
  r = loadRock("1");//MakeRock();
  r.display(500,500);
  
}

void draw(){
  //background(0);
  //r.display(width/2,height/2);
}

void mouseClicked(){
  if(mouseY>800)load=!load;
  if(load){
    if(mouseX<500){
      XML ro = r.toXML();
      if(ro!=null)
      rocks.addChild(ro);
      root.setContent("");
      root.addChild(rocks);
      saveXML(root,"data/Collection.xml");
    }
    r = MakeRock();
    background(255);
    r.display(500,500); 
    fill(0);
    text(r.g.boringness,20,20);
    image(r.image,1000-255,0);
  }else{
    if(mouseX<500){
      idr++;
      if(idr>=rocks.getChildren("rock").length)
      idr = 0;
    }else{
      idr--;
      if(idr<0)
      idr = rocks.getChildren("rock").length-1;
    }
    
    r = loadRock(idr);//MakeRock();
    background(255);
    r.display(500,500); 
    fill(0);
    text(r.Id+": "+r.Name,20,20);
    image(r.image,1000-255,0);
  }
}
