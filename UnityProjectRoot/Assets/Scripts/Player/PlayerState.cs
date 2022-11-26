using UnityEngine;

public class PlayerState : MonoBehaviour
{
    [Tooltip("���W�b�h�{�f�B�R���|�[�l���g")]
    Rigidbody _rb;

    [Tooltip("�����Ă��邩�ǂ���")]
    bool _isMove;

    [Tooltip("�n�ʂɂ���Ƃ��̏d��"), SerializeField]
    float _groundDrag = 0f;

    [Tooltip("�󒆂ɂ���Ƃ��̏d��"), SerializeField]
    float _airDrag = 0f;

    [Tooltip("�v���C���[�̒��S�_"), SerializeField]
    Vector3 _playerCentor;

    [Tooltip("�n�ʂ̃��C���["), SerializeField]
    LayerMask _groundLayer;

    [Tooltip("����̃v���C���[�̃��[�h")]
    int _currentPlayerMode;

    [Tooltip("���S")]
    Vector3 _centor;

    [Tooltip("�ݒu������������邩�ǂ���")]
    bool _isGroundDebug = true;

    [Tooltip("�ݒu����̃T�C�Y"), SerializeField]
    Vector3 _groundCollisionSize;

    public bool IsMove => _isMove;

    void Update()
    {
        PlayerStateMethod();
        ControlDrag();
        PlayerPowerUpControll();
    }

    /// <summary>
    /// Update�ŉ�Player��State
    /// </summary>
    void PlayerStateMethod()
    {
        _centor = transform.position + _playerCentor;

        if (InputUtility.GetDirectionMove == Vector2.zero || !IsGround())
        {
            _isMove = false;
        }
        else
        {
            _isMove = true;
        }
    }

    /// <summary>
    /// PowerUp�{�^�����������R���g���[���[
    /// </summary>
    void PlayerPowerUpControll()
    {
        if (InputUtility.GetDownActionSwitch)
        {
            _currentPlayerMode = _currentPlayerMode++ % 2;
            GameManager.Instance.PlayerModeChange((PlayerMode)_currentPlayerMode);
        }
    }

    /// <summary>
    /// �d�͊Ǘ�
    /// </summary>
    void ControlDrag()
    {
        if (IsGround())
        {
            _rb.drag = _groundDrag;
        }
        else
        {
            _rb.drag = _airDrag;
        }
    }


    /// <summary>
    /// �ݒu����
    /// </summary>
    /// <returns>�ݒu���Ă��邩�ǂ���</returns>
    public bool IsGround()
    {
        Collider[] collision = Physics.OverlapBox(_centor, _groundCollisionSize, Quaternion.identity, _groundLayer);
        if (collision.Length != 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }


    /// <summary>
    /// Layer�����Gizmo�\��
    /// </summary>
    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        if (_isGroundDebug)
        {
            Gizmos.DrawCube(_centor, _groundCollisionSize);
        }
    }
}
