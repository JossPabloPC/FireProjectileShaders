Shader "Unlit/sh_SimpleParticle"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("NoiseTexture", 2D) = "white" {}
        _UseTexture ("Use Texture", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        BLend SrcAlpha OneMinusSrcAlpha
        ZWrite off
        Cull Off
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;                
            };

            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float4 _NoiseTex_ST;
            fixed _UseTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                
                fixed4 col = tex2D(_MainTex, i.uv);
                float4 res = float4(col.rgb * i.color.rgb, col.r * i.color.a);
                if(_UseTexture > 0){
                    fixed noise = tex2D(_NoiseTex, i.uv * _NoiseTex_ST + _Time.y);
                    res.a *= noise;
                }
                return res;
            }
            ENDCG
        }
    }
}
