using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/* Prepare to reset the game when it is left alone for too long.
 * 
 * This is intended only for use when exhibiting the game */
public class IdleTimer : MonoBehaviour {

	public State state;
	public float idleDelay;
	public float fadeInDelay;
	public float fadeOutDelay;
	public float count;
	public CanvasGroup canvasGroup;
	public Button clicker;
	public GameObject prompt;

	private Vector3 mousePosition;

	public enum State {
		IDLE, FADE_OUT, WAIT_FOR_CLICK, FADE_IN
	}

	void Start() {
		WaitForClick();
	}

	// Update is called once per frame
	void Update() {
		switch(state) {
			case State.WAIT_FOR_CLICK:
				break;
			case State.FADE_OUT:
				if(FadeAlpha(-fadeOutDelay)) {
					state = State.IDLE;
				}
				break;
			case State.IDLE:
				if((Input.mousePosition - mousePosition).magnitude >= 1f) {
					count = 0;
				} else {
					count += Time.deltaTime;
					if(count >= idleDelay) {
						state = State.FADE_IN;
					}
				}
				mousePosition = Input.mousePosition;
				break;
			case State.FADE_IN:
				if((Input.mousePosition - mousePosition).magnitude < 1f) {
					if(FadeAlpha(fadeInDelay)) {
						WaitForClick();
					}
				} else {
					state = State.FADE_OUT;
				}
				mousePosition = Input.mousePosition;
				break;
		}
	}

	public bool FadeAlpha(float value) {
		var done = false;
		var alpha = canvasGroup.alpha;
		alpha += Time.deltaTime / value;
		if(value > 0 && alpha >= 1f) {
			alpha = 1f;
			done = true;
		}
		if(value < 0 && alpha <= 0f) {
			alpha = 0f;
			done = true;
		}
		canvasGroup.alpha = alpha;
		return done;
	}

	public void WaitForClick() {
		state = State.WAIT_FOR_CLICK;
		clicker.interactable = true;
		clicker.image.raycastTarget = true;
		canvasGroup.alpha = 1f;
		prompt.SetActive(true);
	}

	public void OnClick() {
		state = State.FADE_OUT;
		clicker.interactable = false;
		clicker.image.raycastTarget = false;
		count = 0;
		prompt.SetActive(false);
	}

}
