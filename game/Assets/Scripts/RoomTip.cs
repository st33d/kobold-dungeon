using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class RoomTip : MonoBehaviour
{
	public TMP_Text text;
	public SpriteRenderer back;
	public SpriteRenderer outline;

	public string tip {
		get { return text.text; }
		set {
			text.text = value;
			var s = back.size;
			s.x = text.preferredWidth + 8;
			back.size = outline.size = s;
		}
	}
}
