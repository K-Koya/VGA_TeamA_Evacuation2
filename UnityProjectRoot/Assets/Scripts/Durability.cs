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

    [Tooltip("�ۑ��p��Velocity")] float _currentVelocity;

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
    }

    private void Update()
    {
        CheckVelocity();
    }

    /// <summary>
    /// �������̃_���[�W����
    /// </summary>
    private void CheckHeight()
    {
        
    }

    /// <summary>
    /// �ړ����̏Փ˃_���[�W����
    /// </summary>
    private void CheckVelocity()
    {
        _currentVelocity = _rb.velocity.magnitude;
        Debug.Log(_currentVelocity.ToString("F2"));
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
