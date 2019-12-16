using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScrollCtrl : MonoBehaviour {

	public Adventure adventure;
	public ScrollRect scrollRect;
	public VerticalLayoutGroup layoutGroup;
	public Image wipe;
	public Image scrollContinue;
	public RectTransform content;
	public float speed = 2f;
	public float wipeDelay = 0.5f;
	public float heightPrev;
	public float yTarget;
	public float viewPortY;
	public int optionsCount;
	public State state;
	public System.Action changeOver;
	private bool scrolling;
	private float scrollDist;
	private bool cancelInput;

	public const int CONTENT_MAX = 100;

	public enum State {
		WAIT, OUT, IN, SCROLL, HOLD
	}

	public bool IsScrolling() {
		return scrolling || cancelInput;
	}


	// RectMask2D is broken in 2019.? so this fixes it apparently
#if UNITY_WEBGL
	void Awake() {
		var items = GetComponentsInChildren<MaskableGraphic>(true);
		for(int i = 0; i < items.Length; i++) {
			Material m = items[i].materialForRendering;
			if(m != null)
				m.EnableKeyword("UNITY_UI_CLIP_RECT");
		}
	}
#endif

	public void Hold(System.Action changeOver, LinkListener linkListener) {
		if(scrolling || cancelInput) return;// abandon changeOver, no action taken

		this.changeOver = changeOver;
		heightPrev = content.rect.height;
		optionsCount = adventure.options.Count;
		scrollRect.enabled = false;
		var option = adventure.options[0].transform;
		var targetY = option.localPosition.y;
		var currentY = content.localPosition.y;

		wipe.rectTransform.sizeDelta =  new Vector2(
			wipe.rectTransform.sizeDelta.x, adventure.dividerBeforeOptions.transform.localPosition.y
		);
		viewPortY = scrollRect.viewport.rect.height - scrollContinue.rectTransform.rect.height;
		scrolling = false;
		scrollDist = viewPortY - (scrollRect.viewport.rect.height - adventure.dividerBeforeOptions.transform.localPosition.y);
		//if(scrollDist > viewPortY)
		//Debug.Log("hold:"+wipe.rectTransform.sizeDelta.y);

		if(linkListener.act == LinkListener.Act.NEXT_DUNGEON) {
			wipe.rectTransform.sizeDelta = new Vector2(
				wipe.rectTransform.sizeDelta.x, scrollRect.viewport.rect.height
			);
		}


		SetWipe(0);
		state = State.OUT;
	}

	public void SetWipe(float a) {
		var c = wipe.color;
		c.a = a;
		wipe.color = c;
	}

	void Update() {
		var a = 0f;
		switch(state) {
			case State.OUT:
				a = wipe.color.a;
				a = Mathf.MoveTowards(a, 1f, Time.deltaTime / wipeDelay);
				SetWipe(a);
				if(a == 1f) {
					changeOver();
					state = State.IN;
				}
				break;
			case State.IN:
				a = wipe.color.a;
				a = Mathf.MoveTowards(a, 0f, Time.deltaTime / wipeDelay);
				SetWipe(a);
				if(a == 0f) {
					if(scrolling) {
						state = State.SCROLL;
					} else {
						scrollRect.enabled = true;
						state = State.WAIT;
					}
				}
				break;
			case State.SCROLL:
				var v = content.localPosition;
				var d = speed * Time.deltaTime;
				v.y += d;
				scrollDist += Mathf.Abs(d);
				//Debug.Log(v.y - yTarget);
				if(scrollDist > viewPortY) {
					if(v.y - yTarget < -scrollContinue.rectTransform.rect.height * 0.5f) {
						scrollContinue.enabled = true;
						state = State.HOLD;
						break;
					}
				}
				if(v.y > yTarget) {
					v.y = yTarget;
					scrolling = false;
					scrollRect.enabled = true;
					adventure.FinishedScrolling();
					state = State.WAIT;
				}
				content.localPosition = v;
				break;
			case State.HOLD:
				if(Input.anyKeyDown) {
					scrollDist = 0;
					scrollContinue.enabled = false;
					state = State.SCROLL;
					cancelInput = true;
				}
				break;
		}
		if(cancelInput) {
			if(!Input.anyKey) {
				cancelInput = false;
			}
		}
	}

	public void TrimContent() {
		// cull history
		if(content.childCount > CONTENT_MAX) {
			var total = content.childCount - CONTENT_MAX;
			for(int i = total; i > -1; i--) {
				var obj = content.GetChild(i);
				//Debug.Log(obj.name+" "+obj.GetInstanceID());
				Destroy(obj.gameObject);
			}
			//Debug.Log(content.childCount);
		}
	}

	public void ClearContent() {
		var total = content.childCount;
		for(int i = 0; i < total; i++) {
			var obj = content.GetChild(i);
			Destroy(obj.gameObject);
		}
	}

	public void PrepareScrolling() {


		// need the new layout right now
		LayoutRebuilder.ForceRebuildLayoutImmediate(content);

		//Debug.Log(content.rect.height+" "+heightPrev);
		var delta = heightPrev - content.rect.height;// + Mathf.Max(0, optionsCount - 1) * layoutGroup.spacing;




		if(content.rect.height < heightPrev) {
			// if the wipe is bigger than the viewport, we just let it cross fade to the new trucated passage
			if(wipe.rectTransform.sizeDelta.y < scrollRect.viewport.rect.height) {
				// create a buffer to keep the content in position
				var obj = new GameObject("buffer");
				var layout = obj.AddComponent<LayoutElement>();
				layout.minHeight = delta;
				obj.transform.SetParent(content);
				adventure.options.Add(obj);
			}
			adventure.FinishedScrolling();
		} else {
			var v = content.localPosition;
			yTarget = v.y;
			v.y += delta;
			content.localPosition = v;
			scrolling = true;
		}
		// pop up to the new options line if we've scrolled past it
				if(
			adventure.dividerBeforeOptions.transform.localPosition.y > scrollRect.viewport.rect.height &&
			wipe.rectTransform.sizeDelta.y > scrollRect.viewport.rect.height
			) {
					var v = content.localPosition;
					v.y = -(wipe.rectTransform.sizeDelta.y);
					content.localPosition = v;
				}


	}

}
