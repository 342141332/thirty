package com.gearbrother.mushroomWar;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.TreeSet;

import com.gearbrother.mushroomWar.util.GMathUtil;

public class BinaryTree {
	public TreeSet<Node> tree = new TreeSet<Node>(
				new Comparator<Node>() {

					@Override
					public int compare(Node o1, Node o2) {
						return o1.value - o2.value;
					}
				}
			);

	public BinaryTree() {
	}

	public static void main(String[] args) {
		int offset = Integer.MAX_VALUE - Integer.MIN_VALUE;
		List<BinaryTree> instances = new ArrayList<BinaryTree>();
		long initialize = System.currentTimeMillis();
		for (int j = 0; j < 2000; j++) {
			BinaryTree instance = new BinaryTree();
			for (int i = 0; i < 300; i++) {
				instance.tree.add(new Node(GMathUtil.random(Integer.MAX_VALUE >> 8, Integer.MIN_VALUE >> 8)));
			}
			System.out.println("fff");
			instance.tree.pollFirst();
			instances.add(instance);
		}
		System.out.println("initialize 2000 instance cause "+ (System.currentTimeMillis() - initialize) + " milliseconds");
		initialize = System.currentTimeMillis();
		for (Iterator<BinaryTree> iterator = instances.iterator(); iterator.hasNext();) {
			BinaryTree binaryTree = (BinaryTree) iterator.next();
			for (int i = 0; i < 150; i++) {
				binaryTree.tree.add(new Node(GMathUtil.random(Integer.MAX_VALUE >> 8, Integer.MIN_VALUE >> 8)));
				binaryTree.tree.pollFirst();
			}
		}
		System.out.println("IO 300 * 2000 instance cause "+ (System.currentTimeMillis() - initialize) + " milliseconds");
	}
	
	@Override
	public String toString() {
		List<String> str = new ArrayList<String>();
		for (Iterator<Node> iterator = tree.iterator(); iterator.hasNext();) {
			Node node = (Node) iterator.next();
			str.add(node.toString());
		}
		return str.toString();
	}
	
	static class Node {
		public int value;

		public Node(int value) {
			this.value = value;
		}
		
		@Override
		public String toString() {
			return "{" + value + "}";
		}
	}
}