import java.util.LinkedList;
import java.util.Iterator;

int populationSize = 50;
LinkedList<Critter> population;

LinkedList<int[]> food;
int foodInitAmount = 2000;
color foodColor = color(0, 195, 39);
LinkedList<int[]> water;
int waterInitAmount = 2000;
color waterColor = color(0, 39, 195);

void setup() {
  background(117);
  size(800,500);
  initializePopulation();
  initializeMap();
}

void draw() {
  background(117);
  tickPopulation();
  drawResources();
  drawPopulation();
}

void initializePopulation() {
  population = new LinkedList<Critter>();
  for (int i=0; i < populationSize; i++) {
    population.add(new Critter());
  }
}

void tickPopulation() {
  Iterator critIt = population.iterator();
  while (critIt.hasNext()) {
    Critter c = (Critter) critIt.next();
    if (c.tick(food, water, population)) {
      Iterator foodIt = food.iterator();
      while (foodIt.hasNext()) {
        int[] coord = (int[]) foodIt.next();
        if (distance(coord[0], coord[1], c.x, c.y)< 5) {
          foodIt.remove();
          c.eat(100);
        }
      }
      
      Iterator waterIt = water.iterator();
      while (waterIt.hasNext()) {
        int[] coord = (int[]) waterIt.next();
        if (distance(coord[0], coord[1], c.x, c.y)< 5) {
          waterIt.remove();
          c.drink(100);
        }
      }
    } else {
      food.add(new int[] {c.x, c.y});
      critIt.remove();
    }
  }
}

void drawPopulation() {
  for (Critter c : population) {
    c.draw();
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


float distance(float x1, float y1, float x2, float y2) {
  return sqrt(pow(x1-x2,2) + pow(y1-y2, 2));
}