package com.gearbrother.sheepwolf;

import java.awt.geom.Rectangle2D;
import java.util.ArrayList;
import java.util.List;

/**
 * @author lifeng
 * @create on 2013-12-17
 * 
 * @see http://gamedevelopment.tutsplus.com/tutorials/quick-tip-use-quadtrees-to-detect-likely-collisions-in-2d-space--gamedev-374
 */
public class Quadtree {
	private int MAX_OBJECTS = 10;
	private int MAX_LEVELS = 7;

	private int level;
	private List<Rectangle2D> objects;
	private Rectangle2D bounds;
	private Quadtree[] children;

	/*
	* Constructor
	*/
	public Quadtree(Rectangle2D pBounds, int maxObjects/* = 10*/, int maxLevel/* = 7*/, int currentLevel/* = 1*/) {
		objects = new ArrayList<Rectangle2D>();
		MAX_OBJECTS = maxObjects;
		MAX_LEVELS = maxLevel;
		level = currentLevel;
		bounds = pBounds;
		children = new Quadtree[4]; //new Quadtree[4];
	}

	/*
	* Clears the quadtree
	*/
	public void clear() {
		objects.clear();

		for (int i = 0; i < children.length; i++) {
			if (children[i] != null) {
				children[i].clear();
				children[i] = null;
			}
		}
	}

	/*
	* Splits the node into 4 subnodes
	*/
	private void split() {
		double subWidth = bounds.getWidth() / 2;
		double subHeight = bounds.getHeight() / 2;
		double x = bounds.getX();
		double y = bounds.getY();

		children[0] = new Quadtree(new Rectangle2D.Double(x + subWidth, y, subWidth, subHeight), MAX_OBJECTS, MAX_LEVELS, level + 1);
		children[1] = new Quadtree(new Rectangle2D.Double(x, y, subWidth, subHeight), MAX_OBJECTS, MAX_LEVELS, level + 1);
		children[2] = new Quadtree(new Rectangle2D.Double(x, y + subHeight, subWidth, subHeight), MAX_OBJECTS, MAX_LEVELS, level + 1);
		children[3] = new Quadtree(new Rectangle2D.Double(x + subWidth, y + subHeight, subWidth, subHeight), MAX_OBJECTS, MAX_LEVELS, level + 1);
	}

	/*
	* Determine which node the object belongs to. -1 means
	* object cannot completely fit within a child node and is part
	* of the parent node
	*/
	private int getIndex(Rectangle2D pRect) {
		int index = -1;
		double verticalMidpoint = bounds.getX() + bounds.getWidth() / 2;
		double horizontalMidpoint = bounds.getY() + bounds.getHeight() / 2;

		// Object can completely fit within the top quadrants
		boolean topQuadrant = (pRect.getY() < horizontalMidpoint && pRect.getY() + pRect.getHeight() < horizontalMidpoint);
		// Object can completely fit within the bottom quadrants
		boolean bottomQuadrant = (pRect.getY() > horizontalMidpoint);

		// Object can completely fit within the left quadrants
		if (pRect.getX() < verticalMidpoint && pRect.getX() + pRect.getWidth() < verticalMidpoint) {
			if (topQuadrant) {
				index = 1;
			} else if (bottomQuadrant) {
				index = 2;
			}
		}
		// Object can completely fit within the right quadrants
		else if (pRect.getX() > verticalMidpoint) {
			if (topQuadrant) {
				index = 0;
			} else if (bottomQuadrant) {
				index = 3;
			}
		}

		return index;
	}
	
	/*
	* Insert the object into the quadtree. If the node
	* exceeds the capacity, it will split and add all
	* objects to their corresponding nodes.
	*/
	public void insert(Rectangle2D pRect) {
		/*pRect.graphics.clear();
		pRect.graphics.beginFill(c, .3);
		pRect.graphics.drawRect(0, 0, 16, 16);
		pRect.graphics.endFill();*/
		if (children[0] != null) {
			int index = getIndex(pRect);
			if (index != -1) {
				children[index].insert(pRect);
				return;
			}
		}

		objects.add(pRect);

		if (objects.size() > MAX_OBJECTS && level < MAX_LEVELS) {
			if (children[0] == null) {
				split();
			}

			int i = 0;
			while (i < objects.size()) {
				int index = getIndex(objects.get(i));
				if (index != -1) {
					children[index].insert(objects.remove(i));
				} else {
					i++;
				}
			}
		}
	}

	/*
	* Return all objects that could collide with the given object
	*/
	public List<Rectangle2D> retrieve(Rectangle2D pRect) {
		List<Rectangle2D> res = new ArrayList<Rectangle2D>();
		int index = getIndex(pRect);
		if (index != -1 && children[0] != null) {
			 children[index].retrieve(pRect);
		}

		res.addAll(objects);
		return res;
	}
	
	public static void main(String[] args) {
		Quadtree tree = new Quadtree(new Rectangle2D.Double(0, 0, 1000, 800), 10, 10, 1);
		for (int i = 0; i < 30 * 30; i++) {
			tree.insert(new Rectangle2D.Double(Math.random() * 1000, Math.random() * 800, 32, 32));
		}
		
		long c = System.currentTimeMillis();
		for (int j = 0; j < 100000; j++) {
			List<Rectangle2D> r = tree.retrieve(new Rectangle2D.Double(Math.random() * 1000, Math.random() * 800, Math.random() * 300 + 50, Math.random() * 300 + 50));
			System.out.println(r.size());
		}
		System.out.println(System.currentTimeMillis() - c);
	}
}