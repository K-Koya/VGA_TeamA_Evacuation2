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

    [Header("�_���[�W����")]
    [SerializeField, Tooltip("�ǂ̈ʂ̑��x����_���[�W���󂯂邩")] float _damageSpeed = 5f;
    [SerializeField, Tooltip("�ǂ̈ʂ̍�������_���[�W���󂯂邩")] float _damageHeight = 5f;

    [Tooltip("1�t���[���O��Velocity")] Vector3 _prevVelocity;
    [Tooltip("���݂�Velocity")] Vector3 _velocity;
    [Tooltip("1�t���[���O��position")] Vector3 _prevPos;

    [Header("�_���[�W��j�󎞂̏���")]
    [SerializeField, Tooltip("�_���[�W")] int _damage = 1;
    [SerializeField] Breaker _breaker;
    [SerializeField] Fracture _fracture;

    [Header("���G�t���O")]
    [SerializeField] bool _godMode;

    Rigidbody _rb;

    public IReactiveProperty<int> HP => _hp;

    private void Start()
    {
        _rb = GetComponent<Rigidbody>();
        _prevPos = transform.position;
    }

    private void Update()
    {
        CheckVelocity();
    }

    /// <summary>
    /// �Փ˃_���[�W����
    /// </summary>
    private void CheckVelocity()
    {
        if (Mathf.Approximately(Time.deltaTime, 0))
        {
            return;
        }

        var position = transform.position;
        _velocity = (position - _prevPos) / Time.deltaTime;
        _prevVelocity = _velocity;
        //Debug.Log($"velocity = {_velocity}");
        _prevPos = position;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.layer == LayerMask.NameToLayer("Ground"))
        {
            var y = _prevVelocity.y;
            Debug.Log(y);
        }
    }

    /// <summary>
    /// �_���[�W���󂯂鏈��
    /// </summary>
    /// <param name="damage">�󂯂�_���[�W</param>
    public void TakeDamage(int damage)
    {
        if (!_godMode)
            _hp.Value -= damage;

        Debug.Log($"�_���[�W���󂯂� : HP = {_hp} : Damage = {damage}");
    }

    void OnDead()
    {
        Debug.Log("����");
        _breaker.Break(_fracture, Vector3.zero);
        GameManager.Instance.OnGameOver();
    }
}
