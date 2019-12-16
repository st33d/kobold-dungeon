using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Ink.Runtime;

public class Room : MonoBehaviour {

	public Map map;
	public Story story;
	public TextAsset ink;
	public Vector2Int pos;
	public ID id;
	public bool visited;
	public SpriteRenderer spriteRenderer;
	public List<SpriteRenderer> wallSpriteRenderers;
	public List<SpriteRenderer> outerWallSpriteRenderers;
	public TMP_Text text;
	public int dist;
	public int gateCount;
	public Room gateBuddy;
	public int gateSearched;

	public Dictionary<Vector2Int, bool> walls;
	public Dictionary<string, Room> exits;
	public const float ROOM_FADE_SPEED = 0.05f;
	public static int gateSearchedCount = 0;
	public static float SIZE = 16;

	public enum ID {
		START, FINISH, PASSAGE, GATE, KEY
	}

	public static readonly List<Vector2Int> DIRS = new List<Vector2Int> {
		Vector2Int.down, Vector2Int.right, Vector2Int.up, Vector2Int.left
	};

	public static readonly Dictionary<Vector2Int, Vector2Int> FLIP_DIRS = new Dictionary<Vector2Int, Vector2Int> {
		{ Vector2Int.down, Vector2Int.up },
		{ Vector2Int.right, Vector2Int.left },
		{ Vector2Int.up, Vector2Int.down },
		{ Vector2Int.left, Vector2Int.right }
	};

	public static readonly Dictionary<Vector2Int, int> DIR_INT = new Dictionary<Vector2Int, int> {
		{ Vector2Int.down, 0 },
		{ Vector2Int.right, 1 },
		{ Vector2Int.up, 2 },
		{ Vector2Int.left, 3 }
	};
	public static readonly Dictionary<Vector2Int, string> DIR_TO_COMPASS = new Dictionary<Vector2Int, string> {
		{ Vector2Int.down, "north" },
		{ Vector2Int.right, "east" },
		{ Vector2Int.up, "south" },
		{ Vector2Int.left, "west" }
	};

	public void SetStory(Story story, TextAsset ink) {
		this.story = story;
		this.ink = ink;
		name = ink.name;
	}

	public void Enter() {
		if(!gameObject.activeInHierarchy) {
			visited = true;
			gameObject.SetActive(true);
			StartCoroutine(FadeRoomIn());
		}
	}

	public IEnumerator FadeRoomIn() {
		for(float f = 0f; f <= 1f; f += 0.1f) {
			Color c = spriteRenderer.color;
			c.a = f;
			spriteRenderer.color = c;
			for(int i = 0; i < wallSpriteRenderers.Count; i++) {
				var renderer = wallSpriteRenderers[i];
				c = renderer.color;
				c.a = f;
				renderer.color = c;
			}
			for(int i = 0; i < outerWallSpriteRenderers.Count; i++) {
				var renderer = outerWallSpriteRenderers[i];
				c = renderer.color;
				c.a = f;
				renderer.color = c;
			}
			yield return new WaitForSeconds(ROOM_FADE_SPEED);
		}
	}

	/* Set position whilst creating walls next to existing rooms */
	public void SetPos(Vector2Int pos, Map map) {
		this.map = map;
		this.pos = pos;
		map.rooms[pos] = this;
		id = ID.PASSAGE;
		exits = new Dictionary<string, Room>();
		walls = new Dictionary<Vector2Int, bool> {
			{ Vector2Int.down, true },
		{ Vector2Int.right, true },
		{ Vector2Int.up, true },
		{ Vector2Int.left, true }
		};
		var size = spriteRenderer.bounds.size;
		var position = Vector2.Scale(pos, size);
		position.y *= -1;
		transform.localPosition = position;
		text.text = "";
	}

	public void Connect(Room r, Vector2Int dir) {
		var flipDir = FLIP_DIRS[dir];
		walls[dir] = false;
		r.walls[flipDir] = false;
		wallSpriteRenderers[DIR_INT[dir]].enabled = false;
		outerWallSpriteRenderers[DIR_INT[dir]].enabled = false;
		r.wallSpriteRenderers[DIR_INT[flipDir]].enabled = false;
		r.outerWallSpriteRenderers[DIR_INT[flipDir]].enabled = false;
		exits[DIR_TO_COMPASS[dir]] = r;
		r.exits[DIR_TO_COMPASS[flipDir]] = this;
	}

	public SaveData Serialize() {
		string json = "";
		if(story != null) {
			if(map.adventure.roomCurrent == this) {
				// we have to save the game before we get to the choices or we only get choices
				json = map.adventure.saveJsonBeforeReading;
			} else {
				json = story.state.ToJson();
			}
		}
		string storyName = "";
		if(ink != null) {
			storyName = ink.name;
		}
		var conn = 0;
		foreach(var kv in walls) {
			if(!kv.Value) {
				conn |= SaveData.DIR_CONN[kv.Key];
			}
		}
		var buddy = Vector2Int.zero;
		if(gateBuddy != null) {
			buddy = gateBuddy.pos;
		}

		Debug.Log("saving room:"+pos+(ink != null ? ink.name : "no story"));
		var data = new SaveData(
			(int)id,
			json,
			storyName,
			pos,
			conn,
			name,
			visited,
			buddy
			);
		return data;
	}

	[System.Serializable]
	public class SaveData {
		public int id;
		public string json;// save story
		public string story;// story name
		public Vector2Int pos;
		public int conn;// Connections
		public string name;// name of the room
		public bool visited;
		public Vector2Int buddy;// position of gate/key buddy if applicable

		public SaveData(int id, string json, string story, Vector2Int pos, int conn, string name, bool visited, Vector2Int buddy) {
			this.id = id;
			this.json = json;
			this.story = story;
			this.pos = pos;
			this.conn = conn;
			this.name = name;
			this.visited = visited;
			this.buddy = buddy;
		}

		[System.Flags]
		public enum Conn {
			UP = 1, RIGHT = 2, DOWN = 4, LEFT = 8
		}
		public static readonly Conn[] CONNS = new Conn []{ Conn.UP, Conn.RIGHT, Conn.DOWN, Conn.LEFT };
		public static readonly Dictionary<Vector2Int, int> DIR_CONN = new Dictionary<Vector2Int, int> {
		{ Vector2Int.down, (int)Conn.UP },
		{ Vector2Int.right, (int)Conn.RIGHT },
		{ Vector2Int.up, (int)Conn.DOWN },
		{ Vector2Int.left, (int)Conn.LEFT }
	};
		public static readonly Dictionary<int, Vector2Int> CONN_DIR = new Dictionary<int, Vector2Int> {
		{ (int)Conn.UP,  Vector2Int.down},
		{ (int)Conn.RIGHT,  Vector2Int.right},
		{ (int)Conn.DOWN,  Vector2Int.up},
		{ (int)Conn.LEFT,  Vector2Int.left}
	};
	}
	

}
