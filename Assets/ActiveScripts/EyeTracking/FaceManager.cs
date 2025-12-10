using UnityEngine;
using UnityEngine.XR.ARFoundation; // ARFaceManagerを使用するために必要

public class FaceManager : MonoBehaviour
{
    [SerializeField] ARFaceManager arFaceManager; // インスペクターで設定

    // 両眼位置[mm] (Unity単位はメートルなので適宜変換が必要ですが、ここでは生の座標を渡します)
    public Vector3 leftEye { get; protected set; }
    public Vector3 rightEye { get; protected set; }

    void Update()
    {
        if (arFaceManager == null || arFaceManager.trackables.count == 0) return;

        // 検出された最初の顔を取得
        foreach (var face in arFaceManager.trackables)
        {
            if (face.trackingState == UnityEngine.XR.ARSubsystems.TrackingState.Tracking)
            {
                // 顔の中心位置を取得（ARCoreの場合、鼻のあたりが原点になることが多い）
                // 簡易的に左目・右目のオフセットを加算するか、FaceMeshの頂点から取得します。
                // ここでは動作確認用として、顔の位置そのものをベースにします。
                Vector3 facePos = face.transform.position;
                
                // カメラ座標系に対する相対位置へ変換（MainCameraが原点の場合、そのままでも可）
                // ※実機で座標がズレる場合はオフセット調整が必要です
                
                // 仮の実装：顔の位置から左右に3cm(0.03m)ずらした位置を代入
                leftEye = facePos + new Vector3(-0.03f, 0.03f, 0); 
                rightEye = facePos + new Vector3(0.03f, 0.03f, 0);
                
                break; // 1人だけ追跡
            }
        }
    }
}