Shader "Unlit/Actor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("Texture", 2D) = "white" {}
        _FirstShadow ("FirstShadow ID", Float) = 0.43
        _SecondShadow ("SecondShadow ID", Float) = 0
        _FirstShadowMultColor ("Light Color", Color) = (1,0,0,1)
        _SecondShadowMultColor ("Light Color", Color) = (0,1,0,1)

        _SpecSmooth ("SecondShadow ID", Float) = 0.314
        _ShadowSmooth ("ShadowSmooth", Float) = 0.02

        _Shininess ("SecondShadow ID", Float) = 6
        _LightColor0 ("Light Color", Color) = (1,1,1,1)
        _LightSpecColor ("Light Spec Color", Color) = (1,1,1)
        _CustomLightDir ("Custom Light Dir", Color) = (0.27641, 0.07001, 0.95849, 1.00)
        _Color ("Color", Color) = (0.53774, 0.53774, 0.53774, 1.00)
        _GlobalCharColor ("GlobalCharColor", Color) = (1.00, 1.00, 1.00, 1.00)

        _MainTexInvisible ("MainTexInvisible", Float) = 0.0

        _LightVector ("_LightVector", Color) = (24.30, 46.90, -113.37, 0.00)


        _LightColorInt ("LightColorInt", Float) = 2.0
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

            float _FirstShadow, _SecondShadow, _Shininess, _SpecSmooth, _ShadowSmooth;

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
                //float intensity = NoL > _FirstShadow ? 1.0f : intensity > _SecondShadow

                //float ramp = saturate()
                float4 diffuse = lerp(_FirstShadowMultColor, _SecondShadowMultColor, i.color.z);
                float4 diffuseColor = diffuse * col;

                
                float threshold = halfLambert + ilmTex.g;
                float secThreshold = _SecondShadow - threshold * 0.5 + _ShadowSmooth;
                float  threshold1 = 1 / threshold;

                secThreshold = saturate(secThreshold * threshold1);

                stmoothstep()

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
