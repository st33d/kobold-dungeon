using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.EventSystems;
using TMPro;

public class LinkListener : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler {

	public TMP_Text text;
	public int choiceIndex;
	public Color hoverCol;
	public string linkName;
	public string indent = Adventure.BULLET_;
	private Color defaultCol;
	public System.Action<LinkListener> action;
	public Act act;
	public bool over;
	public bool disableOver;
	public enum Act {
		NONE, EXIT, NEXT_DUNGEON, RESET, ESCAPE, EXIT_OPTIONS, CANCEL_EXIT
	}

	public const string LINK_L = "<b>";
	public const string LINK_R = "</b>";

	public void Awake() {
		defaultCol = text.color;
		disableOver = true;
	}

	public void SetLink(string str, Action<LinkListener> action) {
		text.text = indent + LINK_L + str + LINK_R;
		this.action = action;
	}

	public void SetIndent(string str, int optionNumber) {
		if(Adventure.OPTION_NUMBERS) {
			indent = optionNumber + " " + str;
		} else {
			indent = Adventure.INDENT + str;
		}
	}

	public void OnPointerClick(PointerEventData eventData) {
		if(action != null) {
			action(this);
		}
	}

	public void OnPointerEnter(PointerEventData eventData) {
		over = true;
		UpdateOver();
	}

	public void OnPointerExit(PointerEventData eventData) {
		over = false;
		UpdateOver();
	}

	public void UpdateOver() {
		if(over && !disableOver) {
			text.color = hoverCol;
		} else {
			text.color = defaultCol;
		}
	}
	

}
