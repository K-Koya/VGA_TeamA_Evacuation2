using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    [Tooltip("�v���C���[�̃X�s�[�h"), SerializeField]
    float _playerSpeed = 5.0f;

    [Tooltip("�v���C���[�̈ړ����͂ɑ΂���Ǐ]�x�APlayerSpeed�ɏ���"), SerializeField]
    float _playerSpeedMultiply = 5.0f;

    [Tooltip("�X�s�[�h�̏��"), SerializeField]
    float _maximizePlayerSpeed = 5.0f;

    [Tooltip("���W�b�h�{�f�B")]
    Rigidbody _rb;

    [Tooltip("���݂̍ő�X�s�[�h")]
    float _currentMaximizeSpeed;

    [Tooltip("���݂̃X�s�[�h")]
    float _currentSpeed;

    [Tooltip("�T�E���h�v���C���[�R���|�[�l���g")]
    SoundPlayer _soundPlayer;

    [Tooltip("�����������̃X�s�[�h"), SerializeField]
    float _merameraPlayerSpeed = 10.0f;

    [Tooltip("�����������̍ő�X�s�[�h"), SerializeField]
    float _merameraPlayerMaximizeSpeed = 10.0f;

    [Tooltip("�v���C���[�X�e�[�g�R���|�[�l���g")]
    PlayerState _playerState;

    void Start()
    {
        SetUp();
    }

    void FixedUpdate()
    {
        PlayerMoveMethod();
    }

    /// <summary>
    /// Start�ōs�������Z�b�g�A�b�v
    /// </summary>
    void SetUp()
    {
        if (!TryGetComponent(out _rb))
        {
            _rb = gameObject.AddComponent<Rigidbody>();
        }
        _soundPlayer = GetComponent<SoundPlayer>();
        _playerState = GetComponent<PlayerState>();
        PlayerPowerDown();
        GameManager.Instance.OnPowerUpEvent += PlayerPowerUp;
        GameManager.Instance.OnPowerDownEvent += PlayerPowerDown;
    }

    void OnDestroy()
    {
        GameManager.Instance.OnPowerUpEvent -= PlayerPowerUp;
        GameManager.Instance.OnPowerDownEvent -= PlayerPowerDown;
    }

    /// <summary>
    /// Player�̈ړ����@�����肷��X�e�[�g
    /// </summary>
    void PlayerMoveMethod()
    {
        if (_rb.velocity.magnitude <= _currentMaximizeSpeed)
        {
            Vector3 dir = PlayerVec(InputUtility.GetDirectionMove);
            _rb.AddForce(_playerSpeedMultiply * (dir - _rb.velocity));
        }

        if (_playerState.IsMove)
        {
            _soundPlayer.PlaySound("SE_walk wood 3");
        }
    }

    /// <summary>
    /// �i�s���������肷��֐�
    /// </summary>
    /// <param name="inputVec">���͕�����Vector2��</param>
    /// <returns>�i�s����</returns>
    Vector3 PlayerVec(Vector2 inputVec)
    {
        Vector3 vec = new Vector3(inputVec.x, 0, inputVec.y);
        vec.Normalize();
        vec *= _currentSpeed;
        vec.y = _rb.velocity.y;
        vec = transform.TransformDirection(vec);
        return vec;
    }

    void PlayerPowerUp()
    {
        _currentSpeed = _merameraPlayerSpeed;
        _currentMaximizeSpeed = _merameraPlayerMaximizeSpeed;
    }

    void PlayerPowerDown()
    {
        _currentSpeed = _playerSpeed;
        _currentMaximizeSpeed = _maximizePlayerSpeed;
    }
}
