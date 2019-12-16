using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyParentOnEnterState : StateMachineBehaviour {

	override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex) {
		Destroy(animator.transform.parent.gameObject);
	}

}
