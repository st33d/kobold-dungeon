using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

[CreateAssetMenu()]
public class InkLib : ScriptableObject {
	public TextAsset intro;
	public TextAsset start;
	public TextAsset finish;
	public TextAsset empty;
	public TextAsset death;
	public List<TextAsset> passages;
	public List<TextAsset> gates;
	public List<TextAsset> keys;

	public Dictionary<TextAsset, int> matchKey;
	public Dictionary<string, int> keyToInt;

	public Dictionary<string, TextAsset> INK_LOOKUP;

	public const int VAR_SCRAPE_SIZE = 500;
	public const string INVENTORY_TOKEN = "i_";

	[ContextMenu("Sort inks")]
	void SortInks() {
		passages = passages.OrderBy(o => o.name).ToList();
		gates = gates.OrderBy(o => o.name).ToList();
		keys = keys.OrderBy(o => o.name).ToList();
		Debug.Log(
			passages.Count+" passages, "
			+gates.Count+" gates, "
			+keys.Count+" keys, "
			+"sorted."
		);
	}

	public void Init() {
		matchKey = new Dictionary<TextAsset, int>();
		keyToInt = new Dictionary<string, int>();
		var list = gates.Concat(keys).ToList();
		var bitKey = 1;
		foreach(var t in list) {
			var intKey = 0;
			var text = t.text;
			if(text.Length > VAR_SCRAPE_SIZE) {
				text = text.Substring(text.Length - VAR_SCRAPE_SIZE);
			}
			var len = text.Length;
			var n = text.IndexOf(INVENTORY_TOKEN);
			var breaker = 0;
			//Debug.Log(n+" "+len);
			while(n > -1) {
				n += INVENTORY_TOKEN.Length;
				var key = "";
				for(int i = n; i < len; i++) {
					if(text[i] == '"') {
						//Debug.Log("sub start "+(i - n));
						key = text.Substring(n, i - n);
						break;
					}
				}
				if(!keyToInt.ContainsKey(key)) {
					Debug.Log("inventory item: "+key+" n:"+bitKey);
					keyToInt[key] = bitKey;
					intKey |= bitKey;
					bitKey <<= 1;
				} else {
					intKey |= keyToInt[key];
				}
				n = text.IndexOf(INVENTORY_TOKEN, n);
				//Debug.Log("token at:"+n);
				if(breaker++ > 100) {
					//Debug.Log("token search failed");
					break;
				}
			}
			matchKey[t] = intKey;
		}

		INK_LOOKUP = new Dictionary<string, TextAsset>();
		foreach(var ink in passages) {
			INK_LOOKUP[ink.name] = ink;
		}
		foreach(var ink in gates) {
			INK_LOOKUP[ink.name] = ink;
		}
		foreach(var ink in keys) {
			INK_LOOKUP[ink.name] = ink;
		}


		//Debug.Log("GATES =================");
		//foreach(var t in gates) {
		//	Debug.Log(t.name+" "+matchKey[t]);
		//}
		//Debug.Log("KEYS =================");
		//foreach(var t in keys) {
		//	Debug.Log(t.name+" "+matchKey[t]);
		//}
		//Debug.Log("INT LOOKUP =================");
		//foreach(var s in keyToInt.Keys) {
		//	Debug.Log(s+" "+keyToInt[s]);
		//}

	}
	
}
