Shader "Unlit/Actor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("Texture", 2D) = "white" {}
        _FirstShadow ("FirstShadow", Float) = 0.46
        _SecondShadow ("SecondShadow", Float) = 0
        _FirstShadowMultColor ("FirstShadowMultColor", Color) = (0.99,0.86,0.82,1)
        _SecondShadowMultColor ("SecondShadowMultColor", Color) = (0.75,0.6,0.65,1)

        _SpecSmooth ("SecondShadow ID", Float) = 0.173
        _ShadowSmooth ("ShadowSmooth", Float) = 0.02

        _Shininess ("Shininess", Float) = 23.8
        _LightColor0 ("Light Color", Color) = (0.65094, 0.60393, 0.53734, 1.00)
        _LightSpecColor ("Light Spec Color", Color) = (1,1,1)
        _CustomLightDir ("Custom Light Dir", Color) = (0.57, 0.82, -0.01, 1.00)
        _Color ("Color", Color) = (0.53774, 0.53774, 0.53774, 1.00)

        _GlobalCharColor ("GlobalCharColor", Color) = (1.00, 1.00, 1.00, 1.00)

        _MainTexInvisible ("MainTexInvisible", Float) = 0.0

        _LightVector ("_LightVector", Color) = (24.30, 46.90, -113.37, 0.00)
        _LightColorInt ("LightColorInt", Float) = 2.0
        _LightColorInf ("LightColorInf", Float) = 0.18

        _FresnelRange ("FresnelRange", Float) = 2.5
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
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float3 color : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
                float3 color : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST, _LightColor0;

            sampler2D _MaskTex;
            float4 _MaskTex_ST, _FirstShadowMultColor, _SecondShadowMultColor, _CustomLightDir, _Color, _GlobalCharColor;

            float3 _LightSpecColor;

            float _FirstShadow, _SecondShadow, _Shininess, _SpecSmooth, _ShadowSmooth, _LightColorInt, _LightColorInf;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.color = v.color;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 ilmTex = tex2D(_MaskTex, i.uv);

                // 漫反射

                // 世界灯光方向
                fixed3 lightWorldDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 Color = _Color;
                if (_CustomLightDir.w > 0.5)
                {
                    lightWorldDir = normalize(_CustomLightDir.rgb);
                    Color *= _GlobalCharColor.rgb;
                }
                // [-1, 1]
                float NoL = dot(i.normal, lightWorldDir);
                // [0, 1]
                float halfLambert = NoL * 0.5 + 0.5;

                float4 diffuse = lerp(_FirstShadowMultColor, _SecondShadowMultColor, i.color.z);
                float4 diffuseColor = diffuse * col;

                float threshold = (halfLambert + ilmTex.g) * 0.5;
                float ramp = smoothstep(0, _ShadowSmooth, threshold);

                 float3 secDiffuseColor = col * _SecondShadowMultColor;

                float3 shadowColor = lerp(col, diffuse, ramp);

                if (threshold < _FirstShadow)
                {
                    shadowColor = diffuse;
                }

                float4 lightColor = (2 * _LightColor0 - _LightColorInt) * _LightColorInf;

                //  ();

                // half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                // // 高光
                // float3 halfDir = normalize(viewDir + _WorldSpaceLightPos0);
                // float NoH = saturate(dot(i.normal, halfDir));
                // float intensity = pow(NoH, _Shininess);

                // half3 specular = 0;
                // // 控制高光区域
                // half specularMask = ilmTex.b;
                // if (intensity >= 1 - specularMask)
				// {
				// 	specular = (ilmTex.r) * _LightSpecColor * intensity;
				// }

                // col.rgb += specular  * _LightColor0.rgb;
                // // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);


                return diffuseColor;
            }
            ENDCG
        }
    }
}
