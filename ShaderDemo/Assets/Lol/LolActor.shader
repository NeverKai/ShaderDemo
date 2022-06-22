Shader "Unlit/LolActor"
{
    Properties
    {
        _MainTex ("Albedo", 2D) = "white" {}

        _BumpScale("Scale", Float) = 1.0
        [Normal] _BumpMap("Normal Map", 2D) = "bump" {}
        
        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("Metallic", 2D) = "white" {}
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
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _BumpMap;
            float4 _MainTex_ST, _LightColor0;
            float _BumpScale;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 normalMap = tex2D(_BumpMap, i.uv);
                normalMap = normalMap * 2 - 1;

                fixed2 bumpOffset = normalMap.xy * _BumpScale;

                fixed3 mainColor = tex2D(_MainTex, i.uv);
                return fixed4(mainColor.rgb, 1);
            }
            ENDCG
        }
    }
}
