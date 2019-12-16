using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

/* Stores the history of the game played thus far */
public class Log {

	public static List<string> text;// the raw text we have already read
	public static string[] SEPARATOR = new string[] { "---" };

	public static void Clear() {
		text = new List<string>();
	}

	public static void Save() {
		var joined = string.Join("---", text);
		PlayerPrefs.SetString("log", joined);
	}

	public static void Load() {
		var joined = PlayerPrefs.GetString("log", "");
		if(joined.Length > 0) {
			text = joined.Split(SEPARATOR, System.StringSplitOptions.None).ToList();
		}
	}

	public static void AddText(string str) {
		text.Add(str);
	}


	public static void FillDebug() {
		for(int i = 0; i < 100; i++) {
			text.Add("Blah.");
		}
	}


}
