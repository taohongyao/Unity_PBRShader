using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelfSpinning : MonoBehaviour
{
    public float speed;
    public GameObject Center;
    public GameObject RotationObj;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 dirction= Center.transform.position-RotationObj.transform.position;
        RotationObj.transform.RotateAround(Center.transform.position,dirction,Time.deltaTime*speed);
        
    }
}
