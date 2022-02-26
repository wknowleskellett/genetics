import java.util.LinkedList;
import java.util.Iterator;

PrintWriter output;
int dataTick = 50;

int populationSize = 50;
LinkedList<Critter> population;

LinkedList<int[]> food;
int foodInitAmount = 300;
color foodColor = color(200, 0, 200);
LinkedList<int[]> water;
int waterInitAmount = 300;
color waterColor = color(0, 39, 195);

int ticks = 0;

void setup() {
  background(117);
  size(800,500);
  initializeMap();
  initializePopulation();
  
  output = createWriter("data.csv");
  output.println("t, Population, Food, Water");
}

void draw() {
  background(117);
  tickResources();
  tickPopulation();
  drawResources();
  drawPopulation();
  
  if (ticks % dataTick == 0) {
    String out = "";
    out += (ticks/dataTick);
    println(out);
    out += ", " + population.size();
    out += ", " + food.size();
    out += ", " + water.size();
    output.println(out);
  }
  ticks += 1;
}

void keyPressed() {
  if (keyCode == ESC) {
    output.flush();
    output.close();
    exit();
  }
}

void initializeMap() {
  food = new LinkedList<int[]>();
  water = new LinkedList<int[]>();
  for (int i=0; i<foodInitAmount; i++) {
    food.add(new int[] {(int) random(0, width), (int) random(0, height)});
  }
  for (int i=0; i<waterInitAmount; i++) {
    water.add(new int[] {(int) random(0, width), (int) random(0, height)});
  }
}

void initializePopulation() {
  population = new LinkedList<Critter>();
  for (int i=0; i < populationSize; i++) {
    population.add(new Critter());
  }
}

void tickResources() {
  for (int i=0; i<5; i++) {
    water.add(new int[] {(int) random(0, width), (int) random(0, height)});
  }
  for (int i=0; i<4; i++) {
    food.add(new int[] {(int) random(0, width), (int) random(0, height)});
  }
}

void tickPopulation() {
  LinkedList<int[]> babies = new LinkedList<int[]>();
  Iterator<Critter> critIt = population.iterator();
  while (critIt.hasNext()) {
    Critter c = critIt.next();
    if (c.tick(food, water, population)) {
      Iterator<int[]> foodIt = food.iterator();
      while (foodIt.hasNext()) {
        int[] coord = foodIt.next();
        if (distance(coord[0], coord[1], c.x, c.y)< 5) {
          foodIt.remove();
          c.eat(10);
        }
      }
      
      Iterator<int[]> waterIt = water.iterator();
      while (waterIt.hasNext()) {
        int[] coord = waterIt.next();
        if (distance(coord[0], coord[1], c.x, c.y)< 5) {
          waterIt.remove();
          c.drink(10);
        }
      }
      
      Iterator<Critter> critIt2 = population.iterator();
      if (c.consumed > 230 && c.hydrated > 230) {
        while (critIt2.hasNext()) {
          Critter o = critIt2.next();
          if (o != c && o.consumed > 230 && o.hydrated > 230 && distance(o.x, o.y, c.x, c.y)< 5) {
            c.consumed -= 100;
            c.hydrated -= 100;
            o.consumed -= 100;
            o.hydrated -= 100;
            babies.add(new int[] {c.x, c.y});
            break;
          }
        }
      }
    } else {
      food.add(new int[] {c.x, c.y});
      critIt.remove();
    }
  }
  
  for (int[] baby : babies) {
    population.add(new Critter(baby[0], baby[1], 5));
  }
}

void drawPopulation() {
  for (Critter c : population) {
    c.draw(true);
  }
}

void drawResources() {
  fill(foodColor);
  for (int[] coord : food) {
    ellipse(coord[0], coord[1], 5, 5);
  }
  fill(waterColor);
  for (int[] coord : water) {
    ellipse(coord[0], coord[1], 5, 5);
  }
}


float distance(float x1, float y1, float x2, float y2) {
  return sqrt(pow(x1-x2,2) + pow(y1-y2, 2));
}
