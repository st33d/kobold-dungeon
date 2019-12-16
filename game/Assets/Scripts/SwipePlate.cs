using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System.Collections;
using System.Collections.Generic;

public class SwipePlate : MonoBehaviour, IPointerDownHandler, IPointerUpHandler {

	public static SwipePlate inst;

	public Vector2 position;
	public Vector2 delta;
	public Vector2 lastDelta;
	public Vector2 moved;
	public Vector2 downPosition;
	public bool platePressed; // true if the UI swipe plate element is pressed
	public bool onPlateReleased; // true if the UI swipe plate element is released this frame
	public bool pressed; // global mouse down
	public bool onPress; // true on frame the mouse is pressed
	public bool onRelease; // true on frame the mouse is pressed
//	public static int swipe; // direction extrapolated from swipe

	public Camera cam;

	public delegate void Action();
	
	public static bool touchDevice = false;
	public static float SWIPE_TOLERANCE = 5;

	void Start(){
		inst = this;
	}

	/* Call before code reading inputs */
	public void Read(){

		if(Input.touchCount > 0) touchDevice = true;
		pressed = onPress = false;

		// mobile
		if(touchDevice){
			if(Input.touchCount > 0 && platePressed){
				position = (Vector2)(cam.ScreenToWorldPoint(new Vector3(Input.touches[0].position.x, Input.touches[0].position.y)) - cam.transform.position);
				pressed = true;
				if(Input.touches[0].phase == TouchPhase.Began){
					downPosition = position;
					onPress = true;
				}
			}
		
		// desktop
		} else {
			position = (Vector2)(cam.ScreenToWorldPoint(Input.mousePosition) - cam.transform.position);
			if(platePressed){
				if(Input.GetMouseButtonDown(0)){
					onPress = true;
					downPosition = position;
				}
				if(Input.GetMouseButton(0)){
					pressed = true;
				}
			}
		}

		if(pressed){

			lastDelta = delta;
			delta = position - downPosition;
			moved = delta - lastDelta;

			if(delta.magnitude > SWIPE_TOLERANCE){
//				if(Mathf.Abs(delta.x) > Mathf.Abs(delta.y)){
//					if(delta.x < 0){
//						swipe = Block.LEFT;
//					}
//					if(delta.x > 0){
//						swipe = Block.RIGHT;
//					}
//				} else {
//					if(delta.y < 0){
//						swipe = Block.DOWN;
//					}
//					if(delta.y > 0){
//						swipe = Block.UP;
//					}
//				}
//				if(swipe != Block.NONE){
//					switch(swipe){
//					case Block.LEFT:
//						if(delta.x > lastDelta.x + SWIPE_TOLERANCE) goto case 0;
//						break;
//					case Block.RIGHT:
//						if(delta.x < lastDelta.x - SWIPE_TOLERANCE) goto case 0;
//						break;
//					case 0:
//						downPosition = position;
//						swipe = Block.FLIP_DIR[swipe];
//						lastDelta = delta;
//						break;
//						
//					}
//					// clear swipe input by clearing down position
////					downPosition = position;
//				}

			} else {
//				swipe = Block.NONE;
			}
		} else {
//			swipe = Block.NONE;
		}

		onRelease = onPlateReleased;
		onPlateReleased = false;
	}

	public void OnPointerUp(PointerEventData data){
		platePressed = false;
		onPlateReleased = true;
		moved = Vector2.zero;
		delta = lastDelta = Vector2.zero;
	}

	public void OnPointerDown(PointerEventData data){
		platePressed = true;
		onPlateReleased = false;
	}

}
