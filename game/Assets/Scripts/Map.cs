using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;

using Ink.Runtime;

public class Map : MonoBehaviour {

	public Lib lib;
	public Adventure adventure;
	public System.Random rng;
	public Room start;
	public Room exit;
	public Dictionary<Vector2Int, Room> rooms;
	public Player player;
	public List<Loop> loops;
	public RectInt bounds;
	public Image cover;
	public MapCam mapCam;
	public RoomTip roomTip;
	
	public const int LOOP_SIZE_MAX = 4;
	public const int LOOP_SIZE_MIN = 2;
	public float coverTargetAlpha = 0f;
	public float coverFadeDelay = 0.5f;

	public static int trackRng = 0;

	public void Start() {
	}

	public void Clear() {
		// clear out workshop
		foreach(Transform t in transform) {
			Destroy(t.gameObject);
		}
		//rng = new System.Random(trackRng++);
		rng = new System.Random();
		rooms = new Dictionary<Vector2Int, Room>();
		loops = new List<Loop>();

	}

	public void Load(List<Room.SaveData> saveDatas, InkLib inkLib, Vector2Int current) {
		Clear();
		for(int i = 0; i < saveDatas.Count; i++) {
			var data = saveDatas[i];
			var r = AddRoom(data.pos);
			r.id = (Room.ID)data.id;
			r.visited = data.visited;
			r.name = data.name;
			switch(r.id) {
				case Room.ID.START:
					start = r;
					r.SetStory(new Story(inkLib.start.text), inkLib.start);
					break;
				case Room.ID.FINISH:
					exit = r;
					r.SetStory(new Story(inkLib.finish.text), inkLib.finish);
					break;
				default:
					if(data.story != "") {
						var ink = inkLib.INK_LOOKUP[data.story];
						r.SetStory(new Story(ink.text), ink);
					}
					break;
			}
			if(r.story != null && data.json != "") {
				Debug.Log("loaded json for:" + r.ink.name);
				r.story.state.LoadJson(data.json);
			}
		}
		var min = new Vector2Int(int.MaxValue, int.MaxValue);
		var max = new Vector2Int(int.MinValue, int.MinValue);
		// connect rooms
		for(int i = 0; i < saveDatas.Count; i++) {
			var data = saveDatas[i];
			var r = rooms[data.pos];
			for(int j = 0; j < Room.SaveData.CONNS.Length; j++) {
				// step thru exits
				var conn = (int)Room.SaveData.CONNS[j];
				if((data.conn & conn) != 0) {
					var dir = Room.SaveData.CONN_DIR[conn];
					if(rooms.ContainsKey(r.pos + dir)) {
						r.Connect(rooms[r.pos + dir], dir);
					}
				}
			}
			if(r.pos.x < min.x) min.x = r.pos.x;
			if(r.pos.y < min.y) min.y = r.pos.y;
			if(r.pos.x > max.x) max.x = r.pos.x;
			if(r.pos.y > max.y) max.y = r.pos.y;
			if(!r.visited) r.gameObject.SetActive(false);
			if(r.id == Room.ID.GATE || r.id == Room.ID.KEY) {
				r.gateBuddy = rooms[data.buddy];
			}
			Debug.Log("loading room:" + r.pos + (r.ink != null ? r.ink.name : "no story"));
		}


		bounds = new RectInt(min, (max + Vector2Int.one) - min);
		start.gameObject.SetActive(true);

		Debug.Log(bounds);

		var obj = Instantiate(lib.player, transform);
		player = new Player(obj.transform, this);
		player.Move(rooms[current], true);
	}

	public void Create(int runCount) {

		Clear();

		start = AddRoom(new Vector2Int());
		start.id = Room.ID.START;
		var entranceGate = new Loop.Gate(start.pos, rng.Pick(Room.DIRS));

		Loop loop = null;
		var loopSizes = new List<Vector2Int>(Loop.LOOP_SIZES);
		if(runCount == 0) loopSizes.RemoveAt(0);

		for(int i = 0; i < 2; i++) {
			loop = new Loop(entranceGate, rng.Pluck(loopSizes), this);

			var gate = rooms[loop.exit.pos];
			gate.id = Room.ID.GATE;

			var key = rooms[loop.key.pos];
			key.id = Room.ID.KEY;

			gate.gateBuddy = key;
			key.gateBuddy = gate;

			entranceGate = loop.exit;
			if(runCount == 0) break;
			else if(loop.big) {
				loopSizes = new List<Vector2Int> { new Vector2Int(2, 2) };
			} else if(!loop.small) {
				loopSizes.RemoveAt(loopSizes.Count - 1);
			}

		}
		Debug.Log("rooms total:" + rooms.Count);

		// add the exit
		var exitGate = new Loop.Gate(loop.exit.pos + loop.exit.dir, loop.exit.dir);
		exit = AddRoom(exitGate.pos);
		exitGate.Connect(this, true);
		exit.id = Room.ID.FINISH;


		var min = new Vector2Int(int.MaxValue, int.MaxValue);
		var max = new Vector2Int(int.MinValue, int.MinValue);

		foreach(var r in rooms.Values) {
			if(r.pos.x < min.x) min.x = r.pos.x;
			if(r.pos.y < min.y) min.y = r.pos.y;
			if(r.pos.x > max.x) max.x = r.pos.x;
			if(r.pos.y > max.y) max.y = r.pos.y;
			r.gameObject.SetActive(false);
		}//
		bounds = new RectInt(min, (max + Vector2Int.one) - min);
		start.gameObject.SetActive(true);

		Debug.Log(bounds);

		var obj = Instantiate(lib.player, transform);
		player = new Player(obj.transform, this);
		player.Move(start, true);
	}

	void Update() {
		// update fading cover
		var a = cover.color.a;
		if(a != coverTargetAlpha) {
			a = Mathf.MoveTowards(cover.color.a, coverTargetAlpha, Time.deltaTime / coverFadeDelay);
			var c = cover.color;
			c.a = a;
			cover.color = c;
		}
		if(player != null) {
			player.Update();
		}//
	}

	public Dictionary<Room, bool> Flood(Room room, bool gateSearch = false) {
		var visited = new Dictionary<Room, bool> { { room, true } };
		room.dist = 0;
		//room.text.text = "0";
		rooms.Values.ToList().ForEach(r => r.dist = int.MaxValue);
		var queue = new Queue<Room>();
		queue.Enqueue(room);
		var total = 1;
		var dist = 0;
		while(total > 0) {
			while(total > 0) {
				total--;
				var r = queue.Dequeue();
				foreach(var next in r.exits.Values) {
					if(!visited.ContainsKey(next)) {
						visited[next] = true;
						queue.Enqueue(next);
						next.dist = dist + 1;
						//next.text.text = ""+next.dist;
						if(gateSearch && next.id == Room.ID.GATE && next.gateSearched < Room.gateSearchedCount) {
							return visited;
						}
					}
				}
			}
			dist++;
			total = queue.Count;
		}
		return visited;
	}

	public Room AddRoom(Vector2Int p) {
		var obj = Instantiate(lib.room, transform);
		var r = obj.GetComponent<Room>();
		r.SetPos(p, this);// rooms[p] = r#
		return r;
	}

	public class Loop {
		public Map map;
		public RectInt rect;
		public Vector2Int size;
		public List<Vector2Int> prongs;
		public Vector2Int dir;
		public bool big { get { return size.x == size.y && size.x == 3; } }
		public bool small { get { return size.x == size.y && size.x == 2; } }
		// prongs
		public Gate enter;
		public Gate exit;
		public Gate key;

		public static readonly List<Vector2Int> LOOP_SIZES = new List<Vector2Int> {
			new Vector2Int(2, 2)
			,new Vector2Int(2, 3)
			,new Vector2Int(3, 2)
			,new Vector2Int(3, 3)
	};

		public Loop(Gate enter, Vector2Int size, Map map) {
			this.map = map;
			this.enter = enter;
			this.size = size;
			var orient = map.rng.NextBool();
			//size = new Vector2Int(
			//	orient ? map.rng.Next(LOOP_SIZE_MIN, LOOP_SIZE_MAX) : LOOP_SIZE_MIN, orient ? LOOP_SIZE_MIN : map.rng.Next(LOOP_SIZE_MIN, LOOP_SIZE_MAX)
			//);

			var dirs = new List<Vector2Int>(Room.DIRS);
			dirs.Remove(enter.dir * -1);
			map.rng.Shuffle(dirs);
			dirs.RemoveAt(dirs.Count - 1);

			rect = new RectInt(enter.pos - map.rng.NextVector2Int(size), size);
			while(rect.Contains(enter.pos)) {
				rect.position += enter.dir;
			}

			exit = new Gate(
				map.rng.NextVector2Int(rect.min, rect.max), dirs[0]
			);
			key = new Gate(
				map.rng.NextVector2Int(rect.min, rect.max), dirs[1]
			);
			exit.LeaveRect(rect);
			key.LeaveRect(rect);
			CreateRooms();
			enter.Connect(map, false);
			exit.Connect(map, true);
			key.Connect(map, true);

			var rooms = map.rooms;
			var pos = rect.position;

			// horizontal sweep connect
			Room r;
			for(int x = 0; x < size.x; x++) {
				var p = new Vector2Int(pos.x + x, pos.y);
				r = rooms[p];
				if(x > 0) {
					var prev = p + Vector2Int.left;
					if(rooms.ContainsKey(prev)) r.Connect(rooms[prev], Vector2Int.left);
				}
				p = new Vector2Int(pos.x + x, pos.y + (size.y - 1));
				r = rooms[p];
				if(x > 0) {
					var prev = p + Vector2Int.left;
					if(rooms.ContainsKey(prev)) r.Connect(rooms[prev], Vector2Int.left);
				}
			}
			// vertical sweep connect
			for(int y = 0; y < size.y; y++) {
				var p = new Vector2Int(pos.x, pos.y + y);
				r = rooms[p];
				if(y > 0) {
					var prev = p + Vector2Int.down;
					if(rooms.ContainsKey(prev)) r.Connect(rooms[prev], Vector2Int.down);
				}
				p = new Vector2Int(pos.x + (size.x - 1), pos.y + y);
				r = rooms[p];
				if(y > 0) {
					var prev = p + Vector2Int.down;
					if(rooms.ContainsKey(prev)) r.Connect(rooms[prev], Vector2Int.down);
				}
			}
		}

		public void CreateRooms() {
			map.AddRoom(exit.pos);
			map.AddRoom(key.pos);
			for(int y = 0; y < rect.size.y; y++) {
				for(int x = 0; x < rect.size.x; x++) {
					if(x == 0 || y == 0 || x == rect.size.x - 1 || y == rect.size.y - 1) {
						map.AddRoom(new Vector2Int(x + rect.position.x, y + rect.position.y));
					}
				}
			}
		}

		public class Gate {
			public Vector2Int pos;
			public Vector2Int dir;
			public Gate(Vector2Int pos, Vector2Int dir) {
				this.pos = pos;
				this.dir = dir;
			}
			public void LeaveRect(RectInt rect) {
				while(rect.Contains(pos)) {
					pos += dir;
				}
			}
			public void Connect(Map map, bool exiting) {
				if(map.rooms.ContainsKey(pos)) {
					var room = map.rooms[pos];
					if(exiting) {
						if(map.rooms.ContainsKey(pos - dir)) {
							var next = map.rooms[pos - dir];
							room.Connect(next, dir * -1);
						}
					} else {
						if(map.rooms.ContainsKey(pos + dir)) {
							var next = map.rooms[pos + dir];
							room.Connect(next, dir);
						}
					}
				}
			}
		}
	}

	public bool Overlaps(RectInt loop) {
		for(int y = 0; y < loop.size.y; y++) {
			for(int x = 0; x < loop.size.x; x++) {
				if(x == 0 || y == 0 || x == loop.size.x - 1 || y == loop.size.y - 1) {
					if(rooms.ContainsKey(new Vector2Int(x, y))) {
						return true;
					}
				}
			}
		}
		return false;
	}

	public class Player {
		public Map map;
		public Transform transform;
		public Vector2 offset;
		public Vector2 start;
		public Vector2 finish;
		public float count;
		public float trotCount;
		public float trotStep;
		public const float WALK_DELAY = 1.1f;
		public const float TROT_UP_DELAY = 0.16f;
		public const float TROT_DOWN_DELAY = 0.07f;
		public const float TROT_UP = 2f;
		public Player(Transform transform, Map map) {
			this.transform = transform;
			offset = transform.localPosition;
			this.map = map;
			count = 0;
		}

		public void Update() {
			if(count > 0) {
				count -= Time.deltaTime;
				if(count <= 0) count = 0;
				var p = transform.localPosition;
				p.x = (float)Easing.Linear(count, finish.x, start.x - finish.x, WALK_DELAY);
				p.y = (float)Easing.Linear(count, finish.y, start.y - finish.y, WALK_DELAY);
				if(count > 0) {
					trotCount -= Time.deltaTime;
					if(trotCount <= 0) {
						if(trotStep == TROT_UP) {
							trotStep = 0;
							trotCount = TROT_DOWN_DELAY;
						} else {
							trotStep = TROT_UP;
							trotCount = TROT_UP_DELAY;
						}
					}
					p.y += trotStep;
				}
				transform.localPosition = p;
			}
		}

		public void Move(Room r, bool rightNow) {
			map.mapCam.Goto(r, rightNow);
			if(rightNow) {
				transform.localPosition = r.transform.localPosition + (Vector3)offset;
			} else {
				count = WALK_DELAY;
				trotStep = TROT_UP;
				trotCount = TROT_UP_DELAY;
				start = transform.localPosition;
				finish = r.transform.localPosition + (Vector3)offset;
			}
		}
	}
}

public static class RectIntExtensions {
	public static bool Intersects(
			this RectInt rect,
			RectInt r) {
		return (
			r.x < rect.x + rect.width &&
			r.y < rect.y + rect.height &&
			rect.x < r.x + r.width &&
			rect.y < r.y + r.height
			);
	}
	public static float LoopSize(this RectInt rect) {
		return (rect.width - 1) * 2 + (rect.height - 1) * 2;
	}
	public static Rect Union(this Rect rect, Rect other) {
		var xMin = Mathf.Min(rect.xMin, other.xMin);
		var yMin = Mathf.Min(rect.yMin, other.yMin);
		var xMax = Mathf.Max(rect.xMax, other.xMax);
		var yMax = Mathf.Max(rect.yMax, other.yMax);
		return Rect.MinMaxRect(
				xmin: xMin,
				xmax: xMax,
				ymin: yMin,
				ymax: yMax
		);
	}
}

public static class Vector2IntExtensions {
	public static void SwapAxis(
			this Vector2Int v) {
		var temp = v.x;
		v.x = v.y;
		v.y = temp;
	}
}
