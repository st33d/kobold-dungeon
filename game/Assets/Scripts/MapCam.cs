using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapCam : MonoBehaviour {

	public Map map;
	public Camera cam;
	public SwipePlate swipePlate;

	public Vector2 speed;
	public Vector2 mousePos;
	public bool mouseDown;
	public Rect border;
	public Vector3 offset;
	public bool dragging;

	private string roomName = "";

	public const float DAMPING = 0.9f;
	public const float BOUNCE = 0.5f;

	void Start () {
		offset = Camera.main.transform.position;
	}

	public void Goto(Room room, bool start) {
		var size = room.spriteRenderer.bounds.size;
		var roomRect = new Rect((offset + room.transform.position - size * 0.5f), size);
		if(start) {
			Camera.main.transform.position = room.transform.position + offset;
			border = roomRect;
		} else {
			border = border.Union(roomRect);
		}
		speed = Vector2.zero;
		dragging = false;
	}

	void OnDrawGizmos() {
		Gizmos.color = Color.green;
		Gizmos.DrawWireCube(border.center, border.size);
	}

	void Update () {
		
		cam = Camera.main;
		swipePlate.Read();// update the swipe plate for this instant only
		if(swipePlate.platePressed) {
			dragging = true;
		}
		if(dragging) {
			if(swipePlate.platePressed) {
				speed = -swipePlate.moved;
			} else {
				speed *= DAMPING;
			}
			cam.transform.position += (Vector3)speed;
			Vector2 p = cam.transform.position;
			if(!border.Contains(p)) {
				if(p.x > border.xMax) {
					p.x = border.xMax;
					if(swipePlate.platePressed) speed.x = 0;
					else speed.x = -speed.x * BOUNCE;
				}
				if(p.x < border.xMin) {
					p.x = border.xMin;
					if(swipePlate.platePressed) speed.x = 0;
					else speed.x = -speed.x * BOUNCE;
				}
				if(p.y > border.yMax) {
					p.y = border.yMax;
					if(swipePlate.platePressed) speed.y = 0;
					else speed.y = -speed.y * BOUNCE;
				}
				if(p.y < border.yMin) {
					p.y = border.yMin;
					if(swipePlate.platePressed) speed.y = 0;
					else speed.y = -speed.y * BOUNCE;
				}
				cam.transform.position = new Vector3(p.x, p.y, cam.transform.position.z);
			}
		} else {
			cam.transform.position = Vector3.MoveTowards(cam.transform.position, map.adventure.roomCurrent.transform.position + offset, 2);
		}

		// mouse over room
		var corrected = swipePlate.position + (Vector2)cam.transform.position;
		var pos = Vector2Int.FloorToInt((corrected+(Vector2.up+Vector2.right)*Room.SIZE*0.5f) / Room.SIZE);
		pos.y *= -1;// room Ys are upside down relative to screen
		var newTip = "";
		if(map.rooms.ContainsKey(pos)) {
			var room = map.rooms[pos];
			if(room.ink != null && room.visited) {
				if(map.adventure.roomCurrent == room) {
					newTip = "current room";
				} else {
					newTip = room.name;
				}
				map.roomTip.transform.localPosition = room.transform.localPosition + Vector3.up * 15;
			} else {
				newTip = "";
			}
		}
		if(newTip != roomName) {
			if(newTip != "") {
				if(roomName == "") map.roomTip.gameObject.SetActive(true);
				map.roomTip.tip = newTip;
			} else {
				map.roomTip.gameObject.SetActive(false);
			}
			roomName = newTip;
		}
		

	}
}
