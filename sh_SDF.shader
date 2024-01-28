Shader "Unlit/sh_SDF"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Thickness("Thickness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        BLend SrcAlpha OneMinusSrcAlpha
        ZWrite off
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float smoothstep(float a, float b, float x)
            {
                float t = saturate((x - a)/(b - a));
                return t*t*(3.0 - (2.0*t));
            }

            struct appdata
            {
                float4 vertex : POSITION;
                float3 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Thickness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
                o.uv.z = v.uv.z;
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed col = tex2D(_MainTex, i.uv).r;

                

                fixed sdf = smoothstep(1- i.uv.z, 1 - i.uv.z, col);

                fixed res = sdf * col;

                fixed3 particleColor = i.color;



                return fixed4(particleColor, res);

            }
            ENDCG
        }
    }
}
