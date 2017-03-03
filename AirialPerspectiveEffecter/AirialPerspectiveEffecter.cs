using UnityEngine;
using System.Collections;

//Author	: 堀田昇吾.
//Summary	: 空気遠近法を実現するエフェクター.

[ExecuteInEditMode]
[RequireComponent(typeof (Camera))]
public class AirialPerspectiveEffecter : MonoBehaviour {

	//遠景の色.
	[SerializeField]
	private Color fadeColor = new Color(1, 1, 1, 0.5f);

	//空気遠近法(APE)の色レベルが最小となる距離.
	[SerializeField]
	private float distanceAPE_MIN = 0.0f;
	//空気遠近法(APE)の色レベルが最大となる距離.
	[SerializeField]
	private float distanceAPE_MAX = 100.0f;

	//空気遠近法シェーダー.
	[SerializeField]
	private Shader AirialPersprctiveShader;

	private Material airialPerspectiveMaterial;

	void Start(){
		airialPerspectiveMaterial = new Material (AirialPersprctiveShader);
	}

	void Update () {
		Camera cam = this.GetComponent<Camera> ();
		if (cam.depthTextureMode == DepthTextureMode.None)
			cam.depthTextureMode = DepthTextureMode.Depth;
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Debug.Log (source.width + ", " + source.height);
		Camera cam = this.GetComponent<Camera> ();
		airialPerspectiveMaterial.SetColor ("_FadeColor", fadeColor);

		airialPerspectiveMaterial.SetFloat ("_NearAdopt", distanceAPE_MIN);
		airialPerspectiveMaterial.SetFloat ("_FarAdopt", distanceAPE_MAX);

		airialPerspectiveMaterial.SetFloat ("_Near", cam.nearClipPlane);
		airialPerspectiveMaterial.SetFloat ("_Far", cam.farClipPlane);
		airialPerspectiveMaterial.SetInt ("_IsPerspective", cam.orthographic ? 0 : 1);

		Graphics.Blit (source, destination, airialPerspectiveMaterial);
	}
}
