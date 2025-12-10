Shader "Unlit/Xiaomi_Test"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "include.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            // 描画関数
            float Draw(subpixel sp, float leftImage, float rightImage)
			{
				if (sp.num < _PatternNum / 2){
                    return rightImage;
                }
                else {
                    return leftImage;
                }
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // 初期カラー
                float4 rgba = float4(0, 0, 0, 1);

                // LR テクスチャ取得
                float4 leftImage = tex2D(_LTex, i.uv);
	            float4 rightImage = tex2D(_RTex, i.uv);

                // サブピクセル設定
                pixel p = InitPixel(i.uv * _DisplayResolution);

                // RGBサブピクセルにLR割り当て
                rgba.r = Draw(p.r, leftImage.r, rightImage.r);
                rgba.g = Draw(p.g, leftImage.g, rightImage.g);
                rgba.b = Draw(p.b, leftImage.b, rightImage.b);
                return rgba;
            }
            ENDCG
        }
    }
}
