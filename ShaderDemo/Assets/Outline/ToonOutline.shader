Shader "Unlit/ToonOutline"
{
    Properties
    {
         _Color ("Color", Color) = (1,1,1,1)
        _OutlineColor("OutlineColor", Color) = (1,0,0,1)
        _OutlineWidth ("OutlineWidth", Float) = 0.2
    }
    SubShader
    {
        Tags {  "LightMode" = "Always"  }
        LOD 100
        
        Pass
        {
            Name "Default"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex           : SV_POSITION;
                fixed4 color            : COLOR;
                float2 texcoord         : TEXCOORD0;
                float4 worldPosition    : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                OUT.worldPosition = v.vertex;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

                OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                OUT.color = _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                return IN.color;
            }
            ENDCG
        }

        Pass
        {
            Cull Front
            ZWrite On
		    ColorMask RGB
		    Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : TEXCOORD1;
                 float4 normal : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD1;
            };

            sampler2D _MainTex;
            fixed4  _MainTex_ST, _OutlineColor;
            half _OutlineWidth;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                fixed2 viewNormal = mul(UNITY_MATRIX_IT_MV, v.normal);
                fixed2 extend = normalize(TransformViewToProjection(viewNormal)) * _OutlineWidth * o.vertex.w;

                o.vertex.xy += extend;
                o.color = _OutlineColor;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}
