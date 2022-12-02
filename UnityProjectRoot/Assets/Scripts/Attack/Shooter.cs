using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooter : MonoBehaviour
{
    [SerializeField, Tooltip("��������e�̃v���n�u���A�^�b�`")]
    GameObject _bulletPref = null;

    [SerializeField, Tooltip("��x�ɕ\���ł���e�̐�")]
    int _bulletCapacity = 30;

    /// <summary> ���˂����e </summary>
    GameObject[] _bullets = null;

    // Start is called before the first frame update
    void Start()
    {
        _bullets = new GameObject[_bulletCapacity];
        for (int i = 0; i < _bullets.Length; i++)
        {
            _bullets[i] = Instantiate(_bulletPref);
            _bullets[i].SetActive(false);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (_bulletPref && InputUtility.GetDownFire)
        {
            foreach(GameObject bullet in _bullets)
            {
                if (!bullet.activeSelf)
                {
                    Debug.Log($"{bullet.name}");
                    bullet.SetActive(true);
                    bullet.transform.position = transform.position;
                    bullet.transform.forward = transform.forward;
                    break;
                }
            }
        }
    }
}
