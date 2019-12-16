using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Ink.Runtime;
using System.Linq;

public class Adventure : MonoBehaviour {

	public Lib lib;
	public InkLib inkLib;
	public RectTransform content;
	public Map map;
	public System.Random rng;
	public Color linkBackground;
	public Color linkHighlight;
	public Color textColor;
	public Room roomCurrent;
	public Story story;
	public Story deathStory;
	public ScrollCtrl scrollCtrl;
	public string optionIndent;
	public bool playedIntro;
	public int runCount;
	public int effortMax;
	public GameObject resetPromptFab;
	private int _effort;
	private int _luck;
	private int _wisdom;
	private int _gold;
	public int effort {
		get { return _effort; }
		set { _effort = value; effortText.text = "" + _effort; }
	}
	public int luck {
		get { return _luck; }
		set { _luck = value; luckText.text = "" + _luck; }
	}
	public int wisdom {
		get { return _wisdom; }
		set { _wisdom = value; wisdomText.text = "" + _wisdom; }
	}
	public int gold {
		get { return _gold; }
		set { _gold = value; goldText.text = "" + _gold; }
	}
	public TMP_Text effortText;
	public TMP_Text luckText;
	public TMP_Text wisdomText;
	public TMP_Text goldText;
	public Animator effortAnim;
	public Animator luckAnim;
	public Animator wisdomAnim;
	public Animator goldAnim;

	public List<GameObject> options;
	public List<LinkListener> linkListeners;
	public List<Button> buttons;
	public Dictionary<string, int> inventory;
	public Dictionary<string, int> spawnCount;
	public Image dividerBeforeOptions;

	private List<TextAsset> passages;
	private List<TextAsset> gates;
	private List<TextAsset> keys;
	private Room roomPrev;
	private Image dividerTop;
	private Image dividerTopPrev;
	private Color dividerColor;
	public string saveJsonBeforeReading;// I have to save the story before getting text from it

	public const string INDENT = "<line-indent=5%>";
	public const string BULLET_ = "<sprite name=bullet> ";
	public const string EFFORT_ = "<sprite name=effort> ";
	public const string LUCK_ = "<sprite name=luck> ";
	public const string WISDOM_ = "<sprite name=wisdom> ";
	public const string GOLD_ = "<sprite name=gold> ";
	public readonly Dictionary<string, string> EXIT_ = new Dictionary<string, string>{
		{"north","<sprite index=1> "}
		,{"east","<sprite index=2> "}
		,{"south","<sprite index=3> "}
		,{"west","<sprite index=4> "}
	};
	public const int EFFORT_MAX_DEFAULT = 7;
	public const int WIS_TO_EFFORT = 10;
	public const int LUCK_TOTAL = 3;

	public static bool OPTION_NUMBERS = true;
	void Start() {
		Application.targetFrameRate = 30;
		lib.Init();
		inkLib.Init();
		NewGame();
	}

	public void NewGame() {
		ClearData();
		NewDungeon(true);
		map.roomTip.tip = "hello everybody, how are things?";
	}

	private void ClearData() {
		runCount = 0;
		gold = 0;

		foreach(Transform t in content) {
			Destroy(t.gameObject);
		}
		inventory = new Dictionary<string, int>();
		options = new List<GameObject>();
		buttons = new List<Button>();
		linkListeners = new List<LinkListener>();
		passages = new List<TextAsset>(inkLib.passages);
		gates = new List<TextAsset>(inkLib.gates);
		keys = new List<TextAsset>(inkLib.keys);
		deathStory = new Story(inkLib.death.text);
		spawnCount = new Dictionary<string, int>();
		roomPrev = null;

	}

	public void NewDungeon(bool init) {

		ClearOptions();
		//ClearText();

		effort = effortMax = EFFORT_MAX_DEFAULT;
		luck = Mathf.Max(LUCK_TOTAL - runCount, 0);
		inventory.Clear();
		map.Create(runCount);
		rng = map.rng;
		roomCurrent = map.start;
		roomCurrent.visited = true;
		if(!playedIntro) {
			SetStory(new Story(inkLib.intro.text), null);
			playedIntro = true;
		} else {
			var startStory = new Story(inkLib.start.text);
			var endStory = new Story(inkLib.finish.text);
			SpawnStory(inkLib.start);
			SpawnStory(inkLib.finish);
			roomCurrent.SetStory(startStory, inkLib.start);
			map.exit.SetStory(endStory, inkLib.finish);
			SetStory(roomCurrent.story, roomCurrent);
		}
		AdvanceStory();
		if(init) FinishedScrolling();

	}

	public void SaveGame() {
		var adventureData = Serialize();
		var adventureJson = JsonUtility.ToJson(adventureData);
		Debug.Log("Adventure json\n" + adventureJson);
		PlayerPrefs.SetString("adventureJson", adventureJson);
	}

	public void LoadGame() {
		var json = PlayerPrefs.GetString("adventureJson", "");
		if(json != "") {
			var data = JsonUtility.FromJson<SaveData>(json);
			ClearData();
			ClearOptions();

			playedIntro = data.playedIntro;
			runCount = data.runCount;
			effort = data.effort;
			luck = data.luck;
			wisdom = data.wisdom;
			gold = data.gold;

			map.Load(data.rooms, inkLib, data.current);

			inventory = SaveData.Total.UnSerializeDictionary(data.inventory);
			spawnCount = SaveData.Total.UnSerializeDictionary(data.spawnCount);

			rng = map.rng;
			roomCurrent = map.rooms[data.current];
			if(data.current != data.previous) {
				roomPrev = map.rooms[data.previous];
			}
			Debug.Log("load:" + roomCurrent.ink.name + " " + roomCurrent.pos);

			// prep decks
			passages.Clear();
			gates.Clear();
			keys.Clear();
			// load decks
			for(int i = 0; i < data.passages.Count; i++) passages.Add(inkLib.INK_LOOKUP[data.passages[i]]);
			for(int i = 0; i < data.gates.Count; i++) gates.Add(inkLib.INK_LOOKUP[data.gates[i]]);
			for(int i = 0; i < data.keys.Count; i++) keys.Add(inkLib.INK_LOOKUP[data.keys[i]]);

			story = roomCurrent.story;

			AdvanceStory();
			FinishedScrolling();
		}
	}

	public void SpawnStory(TextAsset ink) {
		if(spawnCount.ContainsKey(ink.name)) {
			spawnCount[ink.name]++;
		} else {
			spawnCount[ink.name] = 0;
		}
	}

	public void AdvanceStory() {

		saveJsonBeforeReading = story.state.ToJson();

		var str = "";
		var tagsCollected = new List<string>();
		while(story.canContinue) {
			str += story.Continue();

			if(story.currentTags != null && story.currentTags.Count > 0) {
				tagsCollected.AddRange(story.currentTags);
			}
		}
		if(tagsCollected.Count > 0) {
			foreach(var k in tagsCollected) {
				Debug.Log("tag:"+k);
				var command = k.Substring(0, 2);
				switch(command) {
					// set name of room
					case "n_":
						var n = k.Substring(2);
						roomCurrent.name = n;
						break;
					// change the map
					case "m_":
						switch(k) {
							case "m_fade_0":
								map.coverTargetAlpha = 0; break;
							case "m_fade_1":
								map.coverTargetAlpha = 1; break;
						}
						break;
				}
			}
		}
		str = str.Trim();
		UpdateStats();
		AddText(str);
		// assign pre-option divider, ScrollCtrl uses this to orient text
		dividerBeforeOptions = AddDivider().GetComponent<Image>();
		dividerColor = dividerBeforeOptions.color;
		dividerTopPrev = dividerTop;
		dividerTop = dividerBeforeOptions;

		if(story.currentChoices.Count > 0) {
			// if only one choice that's an exit, show exit options
			if(story.currentChoices.Count == 1 && story.currentChoices[0].text.Contains("£E")) {
				AddExitOptions(0, false);
			} else {
				AddStoryOptions();
			}
		} else {
			AddDeathOption(1);
		}
	}

	public void AddStoryOptions() {
		for(int i = 0; i < story.currentChoices.Count; i++) {
			var choice = story.currentChoices[i];
			AddOption(choice);
		}
	}



	// UPDATE
	void Update() {
		if(Input.GetKeyDown(KeyCode.N)) {
			NewGame();
		} else if(Input.GetKeyDown(KeyCode.Escape)) {
			Application.Quit();
		} else if(Input.GetKeyDown(KeyCode.T)) {
			// test
			SaveGame();

		} else if(Input.GetKeyDown(KeyCode.L)) {
			// test
			LoadGame();

		} else if(Input.GetKeyDown(KeyCode.P)) {
			ScreenCapture.CaptureScreenshot("screenshot.png");
		} else {
			CheckKeyPress();
		}
	}

	public void SetStory(Story story, Room room) {
		VariablesState vars = null;
		// scrape inventory from old story
		if(this.story != null) {
			vars = this.story.variablesState;
			foreach(var k in vars) {
				if(k.Length > 2 && k.Substring(0, 2) == "i_") {
					var item = k.Substring(2);
					if(inventory.ContainsKey(item)) {
						inventory[item] = (int)vars[k];
						Debug.Log(item+" set to:"+vars[k]);
					}
				}
			}
		}
		// assign new story
		this.story = story;
		vars = story.variablesState;
		var varKeys = new List<string>();
		foreach(var k in vars) varKeys.Add(k);// need to extract properties before modifying
		foreach(var k in varKeys) {
			switch(k) {
				case "luck":
					vars[k] = _luck;
					break;
				case "gold":
					vars[k] = _gold; 
					break;
				case "wisToEffort":
					vars[k] = WIS_TO_EFFORT;
					break;
				case "wisdom":
					vars[k] = _wisdom;
					break;
				case "effortMax":
					vars[k] = effortMax;
					break;
				case "effort":
					vars[k] = _effort;
					break;
				case "runCount":
					vars[k] = runCount;
					break;
				case "spawnCount":
					vars[k] = spawnCount[room.ink.name];
					break;
				default:
					// update inventory - inventory vars start with "i_"
					if(k.Length > 2 && k.Substring(0, 2) == "i_") {
						var item = k.Substring(2);
						if(inventory.ContainsKey(item)) {
							vars[k] = inventory[item];
						} else {
							inventory[item] = 0;
							vars[k] = 0;// we always start without the item
						}
					}
					break;
			}
		}
	}

	public void UpdateStats() {
		var vars = story.variablesState;
		var oldValue = 0;
		var newValue = 0;
		Animator statAnim = null;
		foreach(var k in vars) {
			var value = 0;
			var indent = "";
			if(vars[k] is int) {
				value = (int)vars[k];
			}
			oldValue = value;
			switch(k) {
				case "effort":
					oldValue = _effort;
					effort = value = Mathf.Clamp(value, 0, effortMax);
					statAnim = effortAnim;
					indent = INDENT + EFFORT_;
					goto default;
				case "luck":
					oldValue = _luck;
					luck = Mathf.Max(value, 0);
					statAnim = luckAnim;
					indent = INDENT + LUCK_;
					goto default;
				case "wisdom":
					oldValue = _wisdom;
					wisdom = Mathf.Max(value, 0);
					statAnim = wisdomAnim;
					indent = INDENT + WISDOM_;
					goto default;
				case "gold":
					oldValue = _gold;
					gold = Mathf.Max(value, 0);
					statAnim = goldAnim;
					indent = INDENT + GOLD_;
					goto default;
				default:
					newValue = value;
					// oldValue will equal newValue if the stat is not updated
					if(oldValue != newValue) {
						var difference = newValue - oldValue;
						if(difference > 0) {
							AddText(
								indent+"<i>"+difference +
								" "+k+
								" gained. " + newValue + " total.</i>"
							);
							statAnim.SetTrigger("wib");
						} else if(difference < 0) {
							AddText(
								indent+"<i>"+difference +
								" "+k+
								". " + newValue + " total.</i>"
							);
							statAnim.SetTrigger("shake");
						}
						AddDivider();
						// handle level-up
						if(k == "wisdom") {
							var newEM = EFFORT_MAX_DEFAULT + wisdom / WIS_TO_EFFORT;
							if(newEM != effortMax) {
								effortMax = newEM;
								if(effort > newEM) {
									_effort = newEM;
									effortAnim.SetTrigger("shake");
								}
								AddText(INDENT + EFFORT_ + "<i>your new maximum effort is now " + newEM + "</i>");
								AddDivider();
							}
						}
					}
					break;
			}
		}
	}


	public void ClearOptions() {
		// destroy current options
		foreach(var obj in options) {
			Destroy(obj);
		}
		options.Clear();
		linkListeners.Clear();
		buttons.Clear();
	}

	public void ClearText() {
		ClearOptions();
		scrollCtrl.ClearContent();
	}

	private void MoveDividerTop() {
		if(dividerTopPrev != null) {
			dividerTopPrev.color = dividerColor;
		}
		if(dividerTop != null) {
			dividerTop.color = textColor;
		}
	}

	public void CheckKeyPress() {
		if(!scrollCtrl.IsScrolling() && Input.anyKeyDown) {
			//if(exitOption != null) {
			//	var x = Input.GetAxisRaw("Horizontal");
			//	var y = Input.GetAxisRaw("Vertical");
			//	var dir = "";
			//	if(x > 0 && exitOption.buttons["east"].interactable) {
			//		dir = "east";
			//	}
			//	if(x < 0 && exitOption.buttons["west"].interactable) {
			//		dir = "west";
			//	}
			//	if(y > 0 && exitOption.buttons["north"].interactable) {
			//		dir = "north";
			//	}
			//	if(y < 0 && exitOption.buttons["south"].interactable) {
			//		dir = "south";
			//	}
			//	if(dir != "") {
			//		exitOption.dir = dir;
			//		OnClickExit(exitOption);
			//		return;
			//	}
			//}
			int n = 0;
			int.TryParse(Input.inputString, out n);
			if(n > 0) {
				for(int i = 0; i < linkListeners.Count; i++) {
					var linker = linkListeners[i];
					if(i + 1 == n) {
						linker.over = true;
						linker.UpdateOver();
						OnClick(linker);
						return;
					}
				}
			}
			if(Input.GetKeyDown(KeyCode.Space) && linkListeners.Count > 0) {
				var linker = linkListeners[0];
				linker.over = true;
				linker.UpdateOver();
				OnClick(linker);
			}
		}
	}

	public void OnClick(LinkListener linkListener) {
		if(!scrollCtrl.IsScrolling()) {
			bool exitToggle =
				linkListener.act == LinkListener.Act.EXIT_OPTIONS ||
				linkListener.act == LinkListener.Act.CANCEL_EXIT;
			if(!exitToggle) MoveDividerTop();
			scrollCtrl.Hold(() => {
				ClearOptions();
				// make the choice
				if(!exitToggle) story.ChooseChoiceIndex(linkListener.choiceIndex);
				switch(linkListener.act) {
					case LinkListener.Act.EXIT_OPTIONS:
						AddExitOptions(linkListener.choiceIndex, true);
						scrollCtrl.PrepareScrolling();
						break;
					case LinkListener.Act.CANCEL_EXIT:
						AddStoryOptions();
						scrollCtrl.PrepareScrolling();
						break;
					case LinkListener.Act.EXIT:
						var direction = linkListener.linkName;
						if(roomCurrent.exits.ContainsKey(direction)) {
							EnterRoom(roomCurrent.exits[direction], direction);
						}
						break;
					case LinkListener.Act.ESCAPE:
						runCount++;
						goto case LinkListener.Act.NEXT_DUNGEON;
					case LinkListener.Act.NEXT_DUNGEON:
						ClearText();
						NewDungeon(false);
						scrollCtrl.heightPrev = content.rect.height;
						//scrollCtrl.PrepareScrolling();
						FinishedScrolling();
						break;
					case LinkListener.Act.RESET:
						NewGame();
						break;
					default:
						AdvanceStory();
						scrollCtrl.PrepareScrolling();
						break;
				}
			}, linkListener);
		}
	}

	public void EnterRoom(Room r, string direction) {
		if(direction.Length > 0) {
			AddText("<i>Travelled "+direction+".</i>");
			AddDivider();
		}
		roomPrev = roomCurrent;
		if(r.story == null) {
			// draw a new story from the deck
			TextAsset ink = inkLib.empty;
			TextAsset buddyInk = inkLib.empty;
			switch(r.id) {
				case Room.ID.PASSAGE:
					if(passages.Count == 0) {
						// refresh passages
						passages = new List<TextAsset>(inkLib.passages);
						AddText("<i>Ran out of passage stories. Shuffling deck.</i>");
						AddDivider();
					}
					if(passages.Count > 0) {
						ink = rng.Pluck(passages);
					}
					break;
				// need to draw gates and keys in pairs
				case Room.ID.KEY:
					RefreshGatesAndKeys();
					ink = GetGateBuddy(r, keys, gates);
					break;
				case Room.ID.GATE:
					RefreshGatesAndKeys();
					ink = GetGateBuddy(r, gates, keys);
					break;
			}
			var newStory = new Story(ink.text);
			SpawnStory(ink);
			// data change over
			r.SetStory(newStory, ink);
		}
		roomCurrent = r;
		roomCurrent.Enter();
		SetStory(roomCurrent.story, roomCurrent);
		map.player.Move(roomCurrent, false);
		AdvanceStory();
		scrollCtrl.PrepareScrolling();
	}

	/* Call this before calling GetGateBuddy, otherwise the game will crash */
	public void RefreshGatesAndKeys() {
		if(gates.Count == 0 || keys.Count == 0) {
			gates = new List<TextAsset>(inkLib.gates);
			keys = new List<TextAsset>(inkLib.keys);
			AddText("<i>Ran out of gate and key stories. Shuffling decks.</i>");
			AddDivider();
		}
	}

	/* Gates and keys are paired off.
	 * We want to draw the 1st of the pair at random,
	 * The 2nd must match its gateBuddy - meaning it uses the same inventory variables
	 */
	public TextAsset GetGateBuddy(Room r, List<TextAsset> a, List<TextAsset> b) {
		var ink = rng.Pluck(a);
		var buddyKey = inkLib.matchKey[ink];
		Debug.Log(ink.name + " looking for match " + buddyKey);
		var buddyInk = rng.PluckOnly(b, (t) => {
			Debug.Log("searching:" + t.name + " " + inkLib.matchKey[t]);
			return (inkLib.matchKey[t] & buddyKey) != 0;
		});
		if(buddyInk == null) {
			Debug.Log("no match in list for buddy " + ink.name + " " + buddyKey);
			buddyInk = inkLib.empty;
		}
		r.gateBuddy.SetStory(new Story(buddyInk.text), buddyInk);
		return ink;
	}

	public GameObject AddDivider() {
		var obj = Instantiate(lib.Divider, content);
		return obj;
	}

	public GameObject AddText(string s) {
		var obj = Instantiate(lib.Text, content);
		var t = obj.GetComponent<TMP_Text>();
		t.text = s;
		return obj;
	}

	public LinkListener CreateOption(int index) {
		var obj = Instantiate(lib.Option, content);
		var linker = obj.GetComponent<LinkListener>();
		linkListeners.Add(linker);
		options.Add(obj);
		options.Add(AddDivider());
		linker.choiceIndex = index;
		linker.SetIndent(BULLET_, linkListeners.Count);
		return linker;
	}

	

	public void AddOption(Choice choice) {
		var index = linkListeners.Count;
		var str = choice.text;
		// search for exit marker "£"
		var exit = ' ';
		for(int i = str.Length-2; i > 0 && i > str.Length - 4; i--) {
			if(str[i] == '£') {
				// trim marker
				exit = str[i + 1];
				str = str.Substring(0, i);
			}
		}
		var linker = CreateOption(index);
		switch(exit) {
			case 'R':
				foreach(var k in roomCurrent.exits.Keys) {
					var r = roomCurrent.exits[k];
					if(roomPrev == r) {
						linker.linkName = k;
						linker.SetIndent(EXIT_[k], index + 1);
						break;
					}
				}
				linker.act = LinkListener.Act.EXIT;
				break;
			case 'N':
				var exits = new List<string>();
				foreach(var k in roomCurrent.exits.Keys) {
					var r = roomCurrent.exits[k];
					if(roomPrev != r) {
						exits.Add(k);
					} else if(roomCurrent.exits.Count == 1) {
						exits.Add(k);
					}
				}
				var ex = rng.Pick(exits);
				linker.linkName = ex;
				linker.SetIndent(EXIT_[ex], index + 1);
				linker.act = LinkListener.Act.EXIT;
				break;
			case 'E':
				if(roomCurrent.exits.Count == 1) {
					// if only one exit, just leave
					var keys = roomCurrent.exits.Keys.ToList();
					linker.linkName = keys[0];
					linker.SetIndent(EXIT_[keys[0]], index + 1);
					linker.act = LinkListener.Act.EXIT;
				} else {
					linker.act = LinkListener.Act.EXIT_OPTIONS;
				}
				break;
			case 'D':
				linker.act = LinkListener.Act.NEXT_DUNGEON;
				break;
			case 'G':
				linker.act = LinkListener.Act.RESET;
				break;
			case 'X':
				linker.act = LinkListener.Act.ESCAPE;
				break;
			default:
				var cost = str.IndexOf("(");// are we showing an action with a cost?
				if(cost > -1) {
					if(str.IndexOf("effort", cost) > -1) {
						linker.SetIndent(EFFORT_, index + 1);
					} else if(str.IndexOf("luck", cost) > -1) {
						linker.SetIndent(LUCK_, index + 1);
					} else if(str.IndexOf("wisdom", cost) > -1) {
						linker.SetIndent(WISDOM_, index + 1);
					} else if(str.IndexOf("gold", cost) > -1) {
						linker.SetIndent(GOLD_, index + 1);
					}

				}
				break;
		}
		linker.SetLink(str, OnClick);
	}

	public void AddDeathOption(int index) {
		var linker = CreateOption(index);
		linker.SetLink(LinkListener.LINK_L + "You died." + LinkListener.LINK_R, (link) => {
			if(!scrollCtrl.IsScrolling()) {
				MoveDividerTop();
				scrollCtrl.Hold(() => {
					// reset difficulty
					runCount = 0;
					// go to the death story to prepare for a new dungeon
					ClearOptions();
					SetStory(deathStory, null);
					AdvanceStory();
					scrollCtrl.PrepareScrolling();
				}, linker);
			}
		});
	}

	public void AddExitOptions(int index, bool canCancel) {
		foreach(var s in roomCurrent.exits.Keys) {
			var linker = CreateOption(index);
			linker.linkName = s;
			linker.act = LinkListener.Act.EXIT;
			linker.SetIndent(EXIT_[s], index + 1);
			// examine adjacent room
			var conn = roomCurrent.exits[s];
			var str = (canCancel ? FirstLetterToUpperCase(s) : "Exit "+s)+": ";
			if(!conn.visited) {
				str += "Enter a new room.";
			} else {
				str += "Return to the " + conn.ink.name + " room.";
			}
			linker.SetLink(str, OnClick);
		}
		if(canCancel) {
			var cancel = CreateOption(linkListeners.Count);
			cancel.act = LinkListener.Act.CANCEL_EXIT;
			cancel.SetLink("Cancel exit.", OnClick);
		}
	}

	public void FinishedScrolling() {
		foreach(var link in linkListeners) {
			link.disableOver = false;
			link.UpdateOver();
		}
		foreach(var b in buttons) {
			b.enabled = true;
			b.image.color = Color.white;
		}
		scrollCtrl.TrimContent();
	}


	// UI ===============================================================
	public void CreateResetPrompt() {
		var obj = Instantiate(resetPromptFab, transform);
		var actionDialog = obj.GetComponent<ActionDialog>();
		actionDialog.onClickAction = ResetGame;
	}

	public void ResetGame() {
		playedIntro = false;
		NewGame();
	}



	public SaveData Serialize() {
		var prevPos = roomCurrent.pos;
		if(roomPrev != null) prevPos = roomPrev.pos;
		var passageNames = (from t in passages select t.name).ToList();
		var gateNames = (from t in gates select t.name).ToList();
		var keyNames = (from t in keys select t.name).ToList();
		Debug.Log("save:" + roomCurrent.ink.name + " " + roomCurrent.pos);
		var data = new SaveData(
			playedIntro,
			runCount,
			effort,
			luck,
			wisdom,
			gold,
			inventory,
			spawnCount,
			map,
			roomCurrent.pos,
			prevPos,
			passageNames,
			gateNames,
			keyNames
			);
		return data;
	}

	[System.Serializable]
	public class SaveData {
		public bool playedIntro;
		public int runCount;
		public int effort;
		public int luck;
		public int wisdom;
		public int gold;
		public List<Total> inventory;
		public List<Total> spawnCount;
		public List<string> passages;
		public List<string> gates;
		public List<string> keys;
		public Vector2Int current;// current location
		public Vector2Int previous;// previous location (used by exit commands)
		public List<Room.SaveData> rooms;

		public SaveData(
			bool playedIntro, int runCount, int effort, int luck, int wisdom, int gold, Dictionary<string, int> inventory, Dictionary<string, int> spawnCount, Map map, Vector2Int current, Vector2Int previous, List<string> passages, List<string> gates, List<string> keys
		) {
			this.playedIntro = playedIntro;
			this.runCount = runCount;
			this.effort = effort;
			this.luck = luck;
			this.wisdom = wisdom;
			this.gold = gold;
			this.inventory = Total.SerializeDictionary(inventory);
			this.spawnCount = Total.SerializeDictionary(spawnCount);
			rooms = new List<Room.SaveData>();
			foreach(var kv in map.rooms) {
				rooms.Add(kv.Value.Serialize());
			}
			this.current = current;
			this.previous = previous;
			this.passages = passages;
			this.gates = gates;
			this.keys = keys;
		}
		[System.Serializable]
		public class Total {
			public string key;
			public int value;
			public Total(string key, int value) {
				this.key = key;
				this.value = value;
			}
			public static List<Total> SerializeDictionary(Dictionary<string, int> dict) {
				var list = new List<Total>();
				foreach(var kv in dict) {
					list.Add(new Total(kv.Key, kv.Value));
				}
				return list;
			}
			public static Dictionary<string, int> UnSerializeDictionary(List<Total> list) {
				var dict = new Dictionary<string, int>();
				for(int i = 0; i < list.Count; i++) {
					var kv = list[i];
					dict[kv.key] = kv.value;
				}
				return dict;
			}
		}
	}

	/// <summary>
	/// Returns the input string with the first character converted to uppercase
	/// </summary>
	public static string FirstLetterToUpperCase(string s) {
		char[] a = s.ToCharArray();
		a[0] = char.ToUpper(a[0]);
		return new string(a);
	}

}


