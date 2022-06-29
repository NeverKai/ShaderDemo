Shader "Lol/ActorHair"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OcclusionMap ("OcclusionMap", 2D) = "white" {}
        _Matcap ("Matcap", 2D) = "white" {}
        _BumpTex ("Normal", 2D) = "white" {}
        
        _BumpScale ("BumpScale", Float) = 1
        _Color ("Color", Color) = (1,1,1,1)
        _AmbientCol ("AmbientCol", Color) = (0.3669, 0.80336, 0.91509, 0.30)

        _Metallic ("Metallic", Float) = 0
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

            #include "UnityCG.cginc"

            inline float3 Unity_SafeNormalize(float3 inVec)
            {
                float dp3 = max(0.001f, dot(inVec, inVec));
                return inVec * rsqrt(dp3);
            }

            half3 UnpackScaleNormal(half4 packednormal, half bumpScale)
            {
                half3 normal = packednormal.xyz * 2 - 1;
                #if (SHADER_TARGET >= 30)
                    // SM2.0: instruction count limitation
                    // SM2.0: normal scaler is not supported
                    normal.xy *= bumpScale;
                #endif
                return normal;
            }

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 normal : TEXCOORD2;
                float3 tangent : TEXCOORD3;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex, _OcclusionMap, _Matcap, _BumpTex;
            float4 _MainTex_ST,_Color, _AmbientCol;

            float _BumpScale, _Metallic;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.worldNormal = normalize(mul(unity_ObjectToWorld, v.normal));
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed3 mainTex = tex2D(_MainTex, i.uv);
                mainTex *= _Color;
                
                fixed3 albedo = (mainTex.rgb * 0.305 + 0.68) * mainTex.rgb + fixed3(0.0125229, 0.0125229, 0.0125229);
                albedo = albedo * (1 - _Metallic) * 0.96;
                fixed4 col = _AmbientCol * fixed4(albedo, 1);
                
                fixed4 col1 = tex2D(_OcclusionMap, i.uv);

                fixed4 normalTex = tex2D(_BumpTex, i.uv);
                half3 worldNormal = normalize(UnpackScaleNormal(normalTex, _BumpScale));
                
                return fixed4(col);
                // return fixed4(albedo, 1);
            }
            ENDCG
        }
    }
}
