using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/* Quick way to insert a delegate into a button,
 * as opposed to digging out the button through a search */
public class ActionDialog : MonoBehaviour {

	public System.Action onClickAction;

	public void OnClick() {
		if(onClickAction != null) {
			onClickAction();
		}
	}

}
