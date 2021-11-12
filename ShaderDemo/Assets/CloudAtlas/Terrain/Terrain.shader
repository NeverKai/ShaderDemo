Shader "Unlit/Terrain"
{
    Properties
    {
        _LightMapTex ("Light Map Texture", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _MaskTex ("多通道贴图", 2D) = "white" {}
        _Occlusion ("Occlusion", 2D) = "white" {}
        
        _unity_OcclusionMaskSelector("_unity_OcclusionMaskSelector Color", Color) = (1.0, 0, 0, 0)
        
        _Color ("Color", Color) = (1,1,1,1)
        _Metallic ("Metallic", Float) = 1
        _Glossiness ("Glossiness", Float) = 1
        
        
        _EmissiveSwitch ("EmissiveSwitch", Float) = 1
        _EmissionColor ("_EmissionColor Color", Color) =(0, 0, 0, 1.00)
        _EmissionColorA ("_EmissionColorA Color", Color) = (0, 0, 0, 1.00)
        _EmissionColorB ("_EmissionColorB Color", Color) = (0, 0, 0, 1.00)
        _EmissionColorC ("_EmissionColorC Color", Color) = (0, 0, 0, 1.00)
        
        _SpecularColor ("Specular Color", Color) = (0.87736, 0.30609, 0.00, 1.00)
        _LightColor0 ("Light Color", Color) = (0.65094, 0.60393, 0.53734, 1.00)
        
        
        _ColorIntensity ("Light Spec Color", Color) = (1,1,1,1)
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
                float4 vertex : POSITION; // position
                float3 normal : TEXCOORD0;  // normal
                float2 uv : TEXCOORD1;     
                float2 uvAo : TEXCOORD2;
                float4 VertexColor : TEXCOORD3; // 顶点色
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float2 uv2 : TEXCOORD1;
                float4 VertexColor : TEXCOORD2;
                float2 uvAo : TEXCOORD3;
                float3 worldNormal : TEXCOORD4;
            };

            sampler2D _LightMapTex, _RampTex, _MaskTex, _Occlusion;
            float4 _LightMapTex_ST, _RampTex_ST, _MaskTex_ST, _Color, _SpecularColor, _unity_OcclusionMaskSelector;
            float _Metallic, _Glossiness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.VertexColor = v.VertexColor;
                o.uv = TRANSFORM_TEX(v.uv, _RampTex);
                o.uv2 = TRANSFORM_TEX(v.uv, _LightMapTex);
                o.uvAo = TRANSFORM_TEX(v.uv, _MaskTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 渐变图
                fixed3 rampColor = tex2D(_RampTex, i.uv).xyz;
                rampColor *= _Color;

                fixed3 maskColor = tex2D(_MaskTex, i.uvAo).xyz;
                float metallic = maskColor.r * _Metallic;
                float roughness = 1 - maskColor.y * _Glossiness;
                float nonMetallic = 1 - metallic;
                
                rampColor = lerp(rampColor.xyz, fixed3(0.220916, 0.220916, 0.220916), metallic);

                fixed3 lightDir = normalize(_WorldSpaceLightPos0);
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.vertex);
                fixed3 worldNormal = normalize(i.worldNormal);
                // 菲涅尔近似项
                // // F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0); 
                fixed NoV = dot(worldNormal, viewDir);
                rampColor = rampColor + (1 - rampColor) * pow(NoV, 5);

                // 高光
                fixed NoH = saturate(dot(worldNormal, (lightDir + viewDir)));
                fixed spec = pow(NoH, 5);

                fixed3 specColor = spec * _SpecularColor;
                
                fixed3 occlusionColor = tex2D(_Occlusion, i.uv).xyz;
                float occlusion = saturate(dot(occlusionColor, _unity_OcclusionMaskSelector));
                
                fixed3 vec = (0.779084, 0.779084, 0.779084);
                // 压暗
                rampColor.xyz =  rampColor.xyz * nonMetallic * vec;
               
                 // 基础色
                fixed3 lightMapColor = tex2D(_LightMapTex, i.uv2).xyz;
                // _unity_Lightmap_HDR （2，1，0，0）
                lightMapColor *= 2;
                lightMapColor *= rampColor;
                
                // fixed4 color = fixed4(rampColor, _Color.w);
                // color.rgb *= occlusion;
                // color.rgb += i.VertexColor;

                // diffuse 包含 base color  正常的光照模型
                // color = (diffuse + specular + rimColor) * _LightColor0.rgb;
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                return fixed4(specColor, 1);
            }
            ENDCG
        }
    }
}
