Shader "Lol/ActorHair"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TangentMap ("TangentMap", 2D) = "white" {}
        _Occlusion ("Occlusion", 2D) = "white" {}
        _BumpTex ("Normal", 2D) = "white" {}
        
        _BumpScale ("BumpScale", Float) = 1
        _Color ("Color", Color) = (1,1,1,1)
        _AmbientCol ("AmbientCol", Color) = (0.3669, 0.80336, 0.91509, 0.30)

        _Metallic ("Metallic", Float) = 0
        _PrimarySpecularShift ("PrimarySpecularShift", Float) = 0
        _SecondarySpecularShift ("SecondarySpecularShift", Float) = -0.9
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
                float3 bittagentNormal : TEXCOORD2;
            };

            sampler2D _MainTex, _TangentMap, _Occlusion, _BumpTex;
            float4 _MainTex_ST,_Color, _AmbientCol;

            float _BumpScale, _Metallic, _PrimarySpecularShift, _SecondarySpecularShift;

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
                fixed3 mainTex = tex2D(_MainTex, i.uv);
                mainTex *= _Color;
                
                fixed3 albedo = (mainTex.rgb * 0.305 + 0.68) * mainTex.rgb + fixed3(0.0125229, 0.0125229, 0.0125229);
                fixed3 oneMinusReflectivity = albedo * (1 - _Metallic) * 0.96;
                
                fixed3 specular = lerp(fixed3(0.4, 0.4, 0.4), albedo, _Metallic);
                fixed3 diffuse = albedo * oneMinusReflectivity;
                fixed3 col = _AmbientCol.rgb * specular;
                
                fixed4 tangentMap = tex2D(_TangentMap, i.uv);
                tangentMap = tangentMap * 2 - 1;
                
                
                fixed4 normalTex = tex2D(_BumpTex, i.uv);
                half3 worldNormal = normalize(UnpackScaleNormal(normalTex, _BumpScale));

                // 头发高光的occlution，只有g通道有颜色
                fixed4 Occlusion = tex2D(_Occlusion, i.uv);
                fixed2 shift2 = fixed2(_PrimarySpecularShift, _SecondarySpecularShift) * Occlusion.g;
                
                //worldNormal * shift2.x;
                // fixed3 col1 = satare(dot(tf1, tf5)) * _LightColor0;
                
                return fixed4(tangentMap);
                // return fixed4(albedo, 1);
            }
            ENDCG
        }
    }
}
