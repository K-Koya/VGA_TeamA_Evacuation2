using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using BreakObject;
using UniRx;

/// <summary>
/// �����؂̑ϋv�́i�����Ƃ��납�痎�����HP������j
/// </summary>
public class Durability : MonoBehaviour
{
    [Header("�ϋv��")]
    [SerializeField, Tooltip("�ϋv��")] IntReactiveProperty _hp = new IntReactiveProperty(5);

    [Header("���x�ɉ����ă_���[�W���󂯂鏈��")]
    [SerializeField, Tooltip("�_���[�W���󂯂鑬�x�̉���")] float _damageSpeed = 5f;
    [SerializeField, Tooltip("�_���[�W")] int _damage = 1;
    [SerializeField] Breaker _breaker;
    [SerializeField] Fracture _fracture;
    [Header("���G�t���O")]
    [SerializeField] bool _godMode;

    public IReactiveProperty<int> HP => _hp;

    private void CheckVelocity(Collision collision)
    {
        // �Ռ���5�Ŋ���i�v�Z���y�ɂ��邽�߁j
        float impulse = collision.impulse.magnitude / 5f;

        Debug.Log(impulse);

        if(impulse > _damageSpeed)
        {
            TakeDamage(_damage);
            if(_hp.Value <= 0)
            {
                OnDead();
            }
        }
    }

    /// <summary>
    /// �_���[�W���󂯂鏈���i���������ɂ���āj
    /// </summary>
    /// <param name="damage">�󂯂�_���[�W</param>
    public void TakeDamage(int damage)
    {
        if(!_godMode)
            _hp.Value -= damage;

        Debug.Log($"�_���[�W���󂯂� : HP = {_hp} : Damage = {damage}");
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.layer != 10)
        {
            CheckVelocity(collision);
        }
        else
        {
            Debug.Log("�N�b�V�����ɏՓ�");
        }
    }

    void OnDead()
    {
        Debug.Log("����");
        _breaker.Break(_fracture, Vector3.zero);
        GameManager.Instance.OnGameOver();
    }
}
