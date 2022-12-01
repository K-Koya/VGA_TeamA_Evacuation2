using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmokeBullet : MonoBehaviour
{
    [SerializeField, Tooltip("�e��")]
    float _speed;
    
    /// <summary>�e�����݂��鎞�Ԃ��v������ϐ�</summary>
    float _sponeTime = 0;

    [SerializeField, Tooltip("�e�����݂��鎞��")]
    float _LifeTime;

    [SerializeField, Tooltip("�^����_���[�W��")]
    int _damage;

    void Update()
    {
        transform.position += transform.forward * _speed * Time.deltaTime;
        _sponeTime += Time.deltaTime;
        if (_sponeTime > _LifeTime)
        {
            _sponeTime = 0;
            gameObject.SetActive(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 7)
        {
            Debug.Log("�Ⴊ�e�ɓ�������");
            var obj = other.GetComponent<MosquitoHealth>();
            obj.TakeDamage(_damage);
        }
    }
}
