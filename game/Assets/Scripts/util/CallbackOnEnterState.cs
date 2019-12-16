using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CallbackOnEnterState : StateMachineBehaviour {

	public static System.Action callback;

	override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex) {
		if(callback != null) {
			callback();
		}
	}

}
