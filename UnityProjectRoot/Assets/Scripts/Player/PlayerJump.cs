using UnityEngine;

public class PlayerJump : MonoBehaviour
{
    [Tooltip("�W�����v��"), SerializeField]
    float _playerJumpSpeed = 3.0f;

    [Tooltip("�v���C���[�X�e�[�g�R���|�[�l���g")]
    PlayerState _playerState;

    [Tooltip("���W�b�h�{�f�B�R���|�[�l���g")]
    Rigidbody _rb;

    [Tooltip("�v���C���[�̉��R���|�[�l���g")]
    SoundPlayer _soundPlayer;

    void Start()
    {
        _playerState = GetComponent<PlayerState>();
        _rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        PlayerJumpMethod();
    }

    /// <summary>
    /// �v���C���[���W�����v����@�\
    /// ���Ǘ\��
    /// </summary>
    void PlayerJumpMethod()
    {
        if (InputUtility.GetDownJump && _playerState.IsGround())
        {
            _rb.AddForce(Vector3.up * _playerJumpSpeed, ForceMode.Impulse);
            _soundPlayer.PlaySound("SE_jump1");
        }
    }
}
