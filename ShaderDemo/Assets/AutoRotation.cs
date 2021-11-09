using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoRotation : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        this.transform.Rotate(Vector3.left, 45 * Time.deltaTime, Space.Self);
    }
}
