using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

/* I like to use an instance of an RNG so we can have multiple seeds.
 * 
 * But we're also lacking a few tools for manipulating lists and floats with System.Random */
public static class RandomExtensions {

	public static bool NextBool(this System.Random random) {
		return random.NextDouble() < 0.5;
	}

	public static double NextDouble(
			this System.Random random,
			double minValue,
			double maxValue) {
		return random.NextDouble() * (maxValue - minValue) + minValue;
	}

	public static float NextFloat(
			this System.Random random,
			float minValue,
			float maxValue) {
		return (float)random.NextDouble() * (maxValue - minValue) + minValue;
	}

	public static float NextFloat(
			this System.Random random,
			float maxValue) {
		return (float)random.NextDouble() * maxValue;
	}

	public static Vector2Int NextVector2Int(
			this System.Random random,
			Vector2Int maxValue) {
		return new Vector2Int(
			random.Next(maxValue.x),
			random.Next(maxValue.y)
		);
	}

	public static Vector2Int NextVector2Int(
			this System.Random random,
			Vector2Int minValue,
			Vector2Int maxValue) {
		return new Vector2Int(
			random.Next(maxValue.x - minValue.x) + minValue.x,
			random.Next(maxValue.y - minValue.y) + minValue.y
		);
	}

	/* Pick one from a list */
	public static T Pick<T>(this System.Random random, List<T> list) {
		return list[random.Next(list.Count)];
	}

	/* Pick one from a list when Predicate returns true 
	 * 
	 * eg, pick only a random 3: rng.PickOnly(myInts, (n) => {return n == 3});
	 */
	public static T PickOnly<T>(this System.Random random, List<T> list, Predicate<T> condition) {
		var n = random.Next(list.Count);
		var total = list.Count;
		for(int i = 0; i < total; i++) {
			T item = list[(i + n) % total];
			if(condition(item)) {
				return item;
			}
		}
		return default(T);
	}

	/*Pick one from a list and remove it from the list */
	public static T Pluck<T>(this System.Random random, List<T> list) {
		int n = random.Next(list.Count);
		T item = list[n];
		list.RemoveAt(n);
		return item;
	}

	/* Pick one from a list and remove it from the list when Predicate returns true 
	 * 
	 * eg, pluck only a random 3: rng.PluckOnly(myInts, (n) => {return n == 3});
	 */
	public static T PluckOnly<T>(this System.Random random, List<T> list, Predicate<T> condition) {
		var n = random.Next(list.Count);
		var total = list.Count;
		for(int i = 0; i < total; i++) {
			var j = (i + n) % total;
			T item = list[j];
			if(condition(item)) {
				list.RemoveAt(j);
				return item;
			}
		}
		return default(T);
	}

	public static List<T> Shuffle<T>(this System.Random random, List<T> list) {
		T x;
		for(int j, i = list.Count; i > 0; j = random.Next(i), x = list[--i], list[i] = list[j], list[j] = x) ;
		return list;
	}
}
