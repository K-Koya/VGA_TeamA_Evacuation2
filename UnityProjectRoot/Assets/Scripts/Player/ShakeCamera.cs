using UnityEngine;
using Cinemachine;

public class ShakeCamera : MonoBehaviour
{
    public static ShakeCamera Instance;
    CinemachineImpulseSource _source;
    [Tooltip("振動強度、ゲーム中は変えれない"), SerializeField] float _shakeGain;

    void Awake()
    {
        if(!Instance)
        {
            Instance = this;
            return;
        }

        Destroy(gameObject);
    }
    void Start()
    {
        _source = GetComponent<Cinemachine.CinemachineImpulseSource>();
        _source.m_ImpulseDefinition.m_AmplitudeGain = _shakeGain;
        _source.m_ImpulseDefinition.m_FrequencyGain = _shakeGain;
    }

    public void Update()
    {
        if(Input.GetKeyDown(KeyCode.I))
        {
            Debug.Log("読んだ");
            ShakeMethod();
        }
    }

    public void ShakeMethod()
    {
        _source.GenerateImpulse();
    }
}
