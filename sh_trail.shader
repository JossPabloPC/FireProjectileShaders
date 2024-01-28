Shader "Unlit/sh_trail"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Velocity ("Velocity", float) = 0

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
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Velocity;

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
                fixed4 col = tex2D(_MainTex, float2 (i.uv.x + (_Velocity * _Time.y), i.uv.y));
                float4 res = float4(col.xyz * i.color.xyz, col.r * i.color.a);
                return res;
            }
            ENDCG
        }
    }
}
