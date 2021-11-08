using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spine : MonoBehaviour
{
    public float speed;
    public GameObject Center;
    public GameObject RotationObj;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 dirction= Center.transform.position-RotationObj.transform.position;
        RotationObj.transform.RotateAround(Center.transform.position,dirction,speed);
        
    }
}
