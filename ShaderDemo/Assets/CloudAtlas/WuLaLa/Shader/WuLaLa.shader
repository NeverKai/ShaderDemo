Shader "Unlit/WuLaLa"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightThreshold ("LightThreshold", Float) = 0.3
        _ShadowIntensity ("ShadowIntensity", Float) = 1

        _HighlightColor ("HighlightColor Color", Color) =(0.75472, 0.75472, 0.75472, 1.00)
        _ShadowColor ("ShadowColor Color", Color) =(0.07356, 0.14598, 0.27358, 1.00)
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
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST, _HighlightColor, _ShadowColor;
            float _ShadowIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.vertex);
                float NdV = saturate(dot(viewDir, i.worldNormal));
                float NdL = dot(_WorldSpaceLightPos0.xyz, i.worldNormal);

                fixed4 lightColor = fixed4(_ShadowIntensity, _ShadowIntensity, _ShadowIntensity, _ShadowIntensity) * fixed4(_LightColor0.xyz, 1);

                fixed4 color = lerp(_HighlightColor, _ShadowColor, lightColor * 0.3);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
