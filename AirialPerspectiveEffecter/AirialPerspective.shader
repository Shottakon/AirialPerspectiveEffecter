Shader "Custom/AirialPerspective"
{
	Properties
	{
		_MainTex 	("Texture", 2D) = "White" {}
		_CameraDepthTexture ("Depth Texture", 2D) = "White" {}
	}

	CGINCLUDE
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos   : SV_POSITION;
		float2 uv    : TEXCOORD0;
	};

	sampler2D _MainTex;
	sampler2D _CameraDepthTexture;
	half4 _FadeColor;
	float _NearAdopt;
	float _FarAdopt;

	float _Near;
	float _Far;
	bool _IsPerspective;

	fixed4 frag (v2f i) : SV_Target
	{
		// sample the texture
		fixed4 col = tex2D(_MainTex, i.uv);

		//深度を求めて、0~1の間に納め直す(深度情報の線形化).
		float dep;
		dep = tex2D(_CameraDepthTexture, i.uv);
		if (_IsPerspective) {
			dep = -_Near/(dep * (1-_Near/_Far) - 1);
		} else {
			dep = dep * (_Far - _Near) + _Near;
		}

		float bias = 0;
		float adjDep = min(max(0, (dep - _NearAdopt) / (_FarAdopt - _NearAdopt)), 1);
		if (abs(_Far - dep) > abs(_Far - _Near) * 0.0001) {
			bias = pow(adjDep, 2) * _FadeColor.a;
		}

		return fixed4(col.rgb * (1.0 - bias) + _FadeColor.rgb * bias, 1);
		//return col;
		//return half4(adjDep, adjDep, adjDep, 1);
	}

	ENDCG

	SubShader {	
		//Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		//Blend SrcAlpha OneMinusSrcAlpha
		//AlphaTest Greater .01
		Cull Off Lighting Off ZWrite Off
		Pass {
			CGPROGRAM
			#pragma vertex   vert_img
			#pragma fragment frag
			ENDCG
		}
	}
	FallBack off

}
