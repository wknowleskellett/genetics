import java.util.LinkedList;
import java.lang.Math;

public class Critter {
  int x, y, targetX, targetY, size, consumed, hydrated, stepSize;
  color c;
  
  public Critter() {
    this((int) random(0, width), (int) random(0, height), 10);
  }
  
  public Critter(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.consumed = 255;
    this.hydrated = 255;
    this.stepSize = 5;
  }
  
  public boolean tick(LinkedList<int[]> foodList, LinkedList<int[]> waterList, LinkedList<Critter> mates) {
    consumed -= 1;
    hydrated -= 1;
    if (consumed == 0 || hydrated == 0) {
      return false;
    }
    
    findTarget(foodList, waterList, mates);
    
    step(0, 0);
    return true;
  }
  
  public void eat(int foodAmount) {
    consumed += foodAmount;// min(255, consumed+foodAmount);
  }
  
  public void drink(int waterAmount) {
    hydrated += waterAmount;// min(255, hydrated+waterAmount);
  }
  
  public void draw() {
    c = color(255, consumed, hydrated);
    fill(c);
    ellipse(x, y, size, size);
  }
  
  private int[] closerCoords(int oX, int oY) {
    if (x - oX > width / 2) {
      oX += width;
    } else if (oX - x > width / 2) {
      oX -= width;
    }
    if (y - oY > height / 2) {
      oY += height;
    } else if (oY - y > height / 2) {
      oY -= height;
    }
    
    return new int[] {oX, oY};
  }
  
  private float distanceToCritter(Critter o) {
    int[] closeO = closerCoords(o.x, o.y);
    
    sqrt(pow(x - closeO[0], 2) + pow(y - closeO[0], 2));
    return 5;
  }
  
  private void findTarget(LinkedList<int[]> foodList, LinkedList<int[]> waterList, LinkedList<Critter> mates) {
    if (consumed > 150 && hydrated > 150 && mates.size() > 1) {
      // plenty food, plenty water, try to mate
      Critter minCritter = null;
      float minDist = -1;
      for (Critter other : mates) {
        if (other != this) {
          if (minDist == -1) {
            minDist = distanceToCritter(other);
            minCritter = other;
          } else {
            float dist = distanceToCritter(other);
            if (dist < minDist) {
              minDist = dist;
              minCritter = other;
            }
          }
        }
      }
      
      if (minCritter != null) {
        targetX = minCritter.x;
        targetY = minCritter.y;
      }
    } else if (foodList.size() == 0 && waterList.size() != 0) {
      // try to drink
      
    } else if (waterList.size() == 0 && foodList.size() != 0) {
      // try to eat
    } else if (foodList.size() != 0 && waterList.size() != 0) {
      // do whatever is the quickest
      
    } 
  }
  
  int[] findClosest(LinkedList<int[]> resource) {
    int[] closest = null;
    
    return null;
  }
  
  private void step(int tX, int tY) {
    int[] tC = closerCoords(tX, tY);
    if (tC[0] == x) {
      if (tC[1]> y) {
        y += stepSize;
      } else {
        y -= stepSize;
      }
    } else if (tC[1] == y) {
      if (tC[0]> x) {
        x += stepSize;
      } else {
        x -= stepSize;
      }
    } else {
      float theta = atan((tC[1] - y)/(tC[0]-x));
      int dX = (int) (stepSize * cos(theta));
      int dY = (int) (stepSize * sin(theta));
    }
    x = Math.floorMod((x + (int)random(-5, 5)), width);
    y = Math.floorMod((y + (int)random(-5, 5)), height);
  }
}
