#version 430

smooth in vec4 v_TEXCOORD7;  // mvp顶点
smooth in vec4 v_TEXCOORD0;  // uv
smooth in vec4 v_TEXCOORD1;  // uv2
smooth in vec4 v_TEXCOORD2;
smooth in vec4 v_TEXCOORD3;
smooth in vec4 v_TEXCOORD4;  // position
smooth in vec4 v_TEXCOORD5;  // 顶点色
smooth in vec4 v_TEXCOORD6;

layout(location=0) out vec4 v_SV_TARGET0;

layout(binding=0) uniform $Globals
{
vec3 __WorldSpaceCameraPos;
vec4 __WorldSpaceLightPos0;
vec4 _unity_OcclusionMaskSelector;
vec4 _unity_SpecCube0_BoxMax;
vec4 _unity_SpecCube0_BoxMin;
vec4 _unity_SpecCube0_ProbePosition;
vec4 _unity_SpecCube0_HDR;
vec4 _unity_SpecCube1_BoxMax;
vec4 _unity_SpecCube1_BoxMin;
vec4 _unity_SpecCube1_ProbePosition;
vec4 _unity_SpecCube1_HDR;
vec4 _unity_Lightmap_HDR;
vec4 __LightColor0;
vec4 __Color;
float __Metallic;
float __Glossiness;
vec4 __SpecularColor;
vec4 __EmissionColor;
vec4 __EmissionColorA;
vec4 __EmissionColorB;
vec4 __EmissionColorC;
float __EmissiveSwitch;
vec4 __ColorIntensity;
};

uniform sampler2D textures2D[0]_samplers2D[0];  // ramp
uniform sampler2D textures2D[1]_samplers2D[1];  // 多通道mask
uniform sampler2D textures2D[2]_samplers2D[2];  // 白色
uniform sampler2D textures2D[3]_samplers2D[3];  // seems like base color
uniform sampler2D textures2D[4]_samplers2D[4];  // 红色通道图 感觉像ao

uniform samplerCube texturesCube[0]_samplersCube[0];
uniform samplerCube texturesCube[1]_samplersCube[1];

void main()
{
vec4 i_REGISTER2;
vec4 i_REGISTER3;
vec4 i_REGISTER4;
vec4 i_REGISTER5;
vec4 i_REGISTER6;
vec4 i_REGISTER7;
vec4 i_REGISTER8;
i_REGISTER2.xyzw = v_TEXCOORD0.xyzw;    // uv
i_REGISTER3.xyzw = v_TEXCOORD1.xyzw;     // uv2
i_REGISTER4.xyzw = v_TEXCOORD2.xyzw;
i_REGISTER5.xyz = v_TEXCOORD3.xyz;
i_REGISTER6.xyz = v_TEXCOORD4.xyz;      // position
i_REGISTER7.xyz = v_TEXCOORD5.xyz;      // 顶点色
i_REGISTER8.xy = v_TEXCOORD6.xy;        // __EmissionMap_ST uv

vec4 o_REGISTER0;

vec4 tf0;
ivec4 ti0;
vec4 tf1;
ivec4 ti1;
vec4 tf2;
ivec4 ti2;
vec4 tf3;
ivec4 ti3;
vec4 tf4;
ivec4 ti4;
vec4 tf5;
ivec4 ti5;
vec4 tf6;
ivec4 ti6;
vec4 tf7;
ivec4 ti7;
vec4 tf8;
ivec4 ti8;
vec4 tf9;
ivec4 ti9;
vec4 tf10;
ivec4 ti10;
vec4 tf11;
ivec4 ti11;
vec4 tf12;
ivec4 ti12;
vec4 tf13;
ivec4 ti13;
vec4 tf14;
ivec4 ti14;
ivec4 iTempX[2];
uvec4 uTempX[2];

// normalw
tf0.xyz = vec4(i_REGISTER5.xyzx).xyz;
// position?
tf1.xyz = vec4(i_REGISTER6.xyzx).xyz;

// 感觉是顶点色
tf2.xyz = vec4(i_REGISTER7.xyzx).xyz;

// 这个是mainText ramp
tf3.xyz = vec4(texture(textures2D[0]_samplers2D[0], vec4(i_REGISTER2.xyxx).xy).xyzw).xyz;
tf4.xyz = vec4(tf3.xyzx * __Color.xyzx).xyz;

// 多通道图 // __EmissionMap_ST
tf5.xyz = vec4(texture(textures2D[1]_samplers2D[1], vec4(i_REGISTER8.xyxx).xy).xyzw).xyz;
tf0.w = vec4(tf5.x * __Metallic).w;

// tf1.w = vec4(-tf5.y).w;
// tf1.w = vec4(tf1.w * __Glossiness).w;
// tf1.w = vec4(tf1.w + 1.00000).w;
 tf1.w = 1 - tf5.y * __Glossiness;


// tf2.w = vec4(dot(vec4(tf0.xyzx).xyz, vec4(tf0.xyzx).xyz)).w;
// tf6.xyz = vec4(inversesqrt(tf2.wwww)).xyz;
// tf0.xyz = vec4(tf0.xyzx * tf6.xyzx).xyz;
// normalw
tf0 = normalize(normal)

// tf2.w = vec4(dot(vec4(__WorldSpaceLightPos0.xyzx).xyz, vec4(__WorldSpaceLightPos0.xyzx).xyz)).w;
// tf6.xyz = vec4(inversesqrt(tf2.wwww)).xyz;
// tf7.xyz = vec4(tf6.zzzz).xyz;
// tf7.xyz = vec4(tf7.xyzx).xyz;
// tf7.xyz = vec4(tf7.xyzx * __WorldSpaceLightPos0.xyzx).xyz;
tf7.xyz = normalize(__WorldSpaceLightPos0);

//tf8.xyz = vec4(-tf1.xyzx).xyz;
//tf8.xyz = vec4(tf8.xyzx + __WorldSpaceCameraPos.xyzx).xyz;
//tf2.w = vec4(dot(vec4(tf8.xyzx).xyz, vec4(tf8.xyzx).xyz)).w;
//tf9.xyz = vec4(inversesqrt(tf2.wwww)).xyz;
//tf8.xyz = vec4(tf8.xyzx * tf9.xyzx).xyz;

tf8.xyz = normalize(viewDir);


tf9.xyz = vec4(-tf8.xyzx).xyz;

// 曲面率 dot(view, normal)
tf2.w = vec4(dot(vec4(tf9.xyzx).xyz, vec4(tf0.xyzx).xyz)).w;


tf9.xyz = vec4(tf2.wwww + tf2.wwww).xyz;
tf9.xyz = vec4(-tf9.xyzx).xyz;
tf9.xyz = vec4(tf0.xyzx * tf9.xyzx).xyz;

tf10.xyz = vec4(-tf8.xyzx).xyz;
tf9.xyz = vec4(tf9.xyzx + tf10.xyzx).xyz;

tf10.xyz = vec4(__EmissiveSwitch).xyz;
tf10.xyz = vec4(tf10.xyzx * __EmissionColorA.xyzx).xyz;
tf10.xyz = vec4(tf2.xxxx * tf10.xyzx).xyz;

tf11.xyz = vec4(__EmissiveSwitch).xyz;
tf11.xyz = vec4(tf11.xyzx * __EmissionColorB.xyzx).xyz;

tf12.xyz = vec4(__EmissiveSwitch).xyz;
tf12.xyz = vec4(tf12.xyzx * __EmissionColorC.xyzx).xyz;

// 纯白图
tf13.xyz = vec4(texture(textures2D[2]_samplers2D[2], vec4(i_REGISTER2.zwzz).xy).xyzw).xyz;

tf14.xyz = vec4(__EmissiveSwitch).xyz;
tf14.xyz = vec4(tf14.xyzx * __EmissionColor.xyzx).xyz;

tf13.xyz = vec4(tf13.xyzx * tf14.xyzx).xyz;
tf10.xyz = vec4(tf10.xyzx + tf13.xyzx).xyz;

tf2.xyw = vec4(tf2.yyyy * tf11.xyxz).xyw;
tf2.xyw = vec4(tf10.xyxz + tf2.xyxw).xyw;
tf10.xyz = vec4(tf2.zzzz * tf12.xyzx).xyz;

// tf2 应该为顶点色
tf2.xyz = vec4(tf2.xywx + tf10.xyzx).xyz;

// 红色通道图
tf10.xyzw = vec4(texture(textures2D[4]_samplers2D[4], vec4(i_REGISTER4.xyxx).xy).xyzw).xyzw;

tf2.w = vec4(dot(vec4(tf10.xyzw), vec4(_unity_OcclusionMaskSelector.xyzw))).w;
tf2.w = vec4(max(vec4(tf2.w), vec4(0))).w;
tf10.xyz = vec4(min(vec4(tf2.wwww), vec4(vec4(1.00000, 1.00000, 1.00000, 0)))).xyz;

//tf6.xyz = vec4(tf6.xyzx).xyz;
//tf6.xyz = vec4(tf6.xyzx * __WorldSpaceLightPos0.xyzx).xyz;
//tf6.xyz = vec4(tf8.xyzx + tf6.xyzx).xyz;
tf6.xyz = HalfDir

// tf2.w = vec4(dot(vec4(tf6.xyzx).xyz, vec4(tf6.xyzx).xyz)).w;
// tf11.xyz = vec4(inversesqrt(tf2.wwww)).xyz;
// tf6.xyz = vec4(tf6.xyzx * tf11.xyzx).xyz;
// tf6 HalfDir
tf6 = normalize(tf6);

// tf0 normalw viewDir
// tf2.w = vec4(dot(vec4(tf0.xyzx).xyz, vec4(tf8.xyzx).xyz)).w;
// tf2.w = vec4(max(vec4(tf2.w), vec4(0))).w;
// tf2.w = vec4(min(vec4(tf2.w), vec4(1.00000))).w;
tf2.w = saturate(dot(normal, viewDir));


// tf3.w = vec4(dot(vec4(tf0.xyzx).xyz, vec4(tf7.xyzx).xyz)).w;
// tf3.w = vec4(max(vec4(tf3.w), vec4(0))).w;
// tf8.xyz = vec4(min(vec4(tf3.wwww), vec4(vec4(1.00000, 1.00000, 1.00000, 0)))).xyz;
// NoL
tf8.xyz = saturate(dot(normal, lightDir));

// tf6 HalfDir
//tf0.x = vec4(dot(vec4(tf0.xyzx).xyz, vec4(tf6.xyzx).xyz)).x;
//tf0.x = vec4(max(vec4(tf0.x), vec4(0))).x;
//tf0.x = vec4(min(vec4(tf0.x), vec4(1.00000))).x;
tf0.x = saturate(NoH)

// tf7:lightDir  tf6:HalfDir
// tf0.y = vec4(dot(vec4(tf7.xyzx).xyz, vec4(tf6.xyzx).xyz)).y;
// tf0.y = vec4(max(vec4(tf0.y), vec4(0))).y;
// tf0.y = vec4(min(vec4(tf0.y), vec4(1.00000))).y;
tf0.y = saturate(LoH)


// tf3 ramp
tf3.xyz = vec4(tf3.xyzx * __Color.xyzx).xyz;

//tf3.xyz = vec4(tf3.xyzx + vec4(-0.220916, -0.220916, -0.220916, 0)).xyz;
// tf0.w 金属度
//tf3.xyz = vec4(tf0.wwww * tf3.xyzx).xyz;
//tf3.xyz = vec4(tf3.xyzx + vec4(0.220916, 0.220916, 0.220916, 0)).xyz;
tf3.xyz = lerp(vec4(0.220916, 0.220916, 0.220916, 0), tf3.xyz, tf0.w);

// tf0.z = vec4(-tf5.x).z;
// tf0.z = vec4(tf0.z * __Metallic).z;
// tf0.z = vec4(tf0.z + 1.00000).z;
tf0.z = 1 - tf5.x * __Metallic;

// 类似 lightmap
tf5.xyw = vec4(texture(textures2D[3]_samplers2D[3], vec4(i_REGISTER3.xyxx).xy).xywz).xyw;
tf5.xyw = vec4(tf5.xyxw * _unity_Lightmap_HDR.xxxx).xyw;
ti0.w = (float(0) < float(_unity_SpecCube0_ProbePosition.w)) ? -1 : 0;
if (bool(ti0.w))
{
    tf6.xyz = vec4(-tf1.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx + _unity_SpecCube0_BoxMax.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx / tf9.xyzx).xyz;
    tf7.xyz = vec4(-tf1.xyzx).xyz;
    tf7.xyz = vec4(tf7.xyzx + _unity_SpecCube0_BoxMin.xyzx).xyz;
    tf7.xyz = vec4(tf7.xyzx / tf9.xyzx).xyz;
    ti11.xyz = (ivec4(lessThan(vec4(vec4(0, 0, 0, 0)), vec4(tf9.xyzx))) * ivec4(-1)).xyz;
    if (bool(ti11.x))
    {
    tf7.x = vec4(tf6.x).x;
    }
    else
    {
    tf7.x = vec4(tf7.x).x;
    }
    tf7.x = vec4(tf7.x).x;
    if (bool(ti11.y))
    {
    tf7.y = vec4(tf6.y).y;
    }
    else
    {
    tf7.y = vec4(tf7.y).y;
    }
    tf7.y = vec4(tf7.y).y;
    if (bool(ti11.z))
    {
    tf7.z = vec4(tf6.z).z;
    }
    else
    {
    tf7.z = vec4(tf7.z).z;
    }
    tf7.z = vec4(tf7.z).z;
    tf0.w = vec4(min(vec4(tf7.x), vec4(tf7.y))).w;
    tf6.xyz = vec4(min(vec4(tf0.wwww), vec4(tf7.zzzz))).xyz;
    tf7.xyz = vec4(-_unity_SpecCube0_ProbePosition.xyzx).xyz;
    tf7.xyz = vec4(tf1.xyzx + tf7.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx * tf9.xyzx).xyz;
    tf6.xyz = vec4(tf7.xyzx + tf6.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx).xyz;
}
else
{
    tf6.xyz = vec4(tf9.xyzx).xyz;
}
tf0.w = vec4(-tf1.w).w;
tf0.w = vec4(tf0.w * 0.700000).w;
tf0.w = vec4(tf0.w + 1.70000).w;
tf0.w = vec4(tf1.w * tf0.w).w;
tf0.w = vec4(tf0.w * 6.00000).w;

tf6.xyz = vec4(tf6.xyzx).xyz;
tf0.w = vec4(tf0.w).w;


tf6.xyzw = vec4(textureLod(texturesCube[0]_samplersCube[0], (tf6.xyzx).xyz, tf0.w).xyzw).xyzw;
tf6.xyzw = vec4(tf6.xyzw).xyzw;

tf3.w = vec4(tf6.w + -1.00000).w;
tf3.w = vec4(tf3.w * _unity_SpecCube0_HDR.w).w;
tf3.w = vec4(tf3.w + 1.00000).w;
tf7.xyz = vec4(tf3.wwww * _unity_SpecCube0_HDR.xxxx).xyz;

tf11.xyz = vec4(tf7.zzzz).xyz;
tf11.xyz = vec4(tf11.xyzx).xyz;
tf11.xyz = vec4(tf6.xyzx * tf11.xyzx).xyz;

ti3.w = (float(_unity_SpecCube0_BoxMin.w) < float(0.999990)) ? -1 : 0;
if (bool(ti3.w))
{
    ti3.w = (float(0) < float(_unity_SpecCube1_ProbePosition.w)) ? -1 : 0;
    if (bool(ti3.w))
    {
        tf12.xyz = vec4(-tf1.xyzx).xyz;
        tf12.xyz = vec4(tf12.xyzx + _unity_SpecCube1_BoxMax.xyzx).xyz;
        tf12.xyz = vec4(tf12.xyzx / tf9.xyzx).xyz;
        tf13.xyz = vec4(-tf1.xyzx).xyz;
        tf13.xyz = vec4(tf13.xyzx + _unity_SpecCube1_BoxMin.xyzx).xyz;
        tf13.xyz = vec4(tf13.xyzx / tf9.xyzx).xyz;
        ti14.xyz = (ivec4(lessThan(vec4(vec4(0, 0, 0, 0)), vec4(tf9.xyzx))) * ivec4(-1)).xyz;
        if (bool(ti14.x))
        {
        tf13.x = vec4(tf12.x).x;
        }
        else
        {
        tf13.x = vec4(tf13.x).x;
        }
        tf13.x = vec4(tf13.x).x;
        if (bool(ti14.y))
        {
        tf13.y = vec4(tf12.y).y;
        }
        else
        {
        tf13.y = vec4(tf13.y).y;
        }
        tf13.y = vec4(tf13.y).y;
        if (bool(ti14.z))
        {
        tf13.z = vec4(tf12.z).z;
        }
        else
        {
        tf13.z = vec4(tf13.z).z;
        }
        tf13.z = vec4(tf13.z).z;
        tf3.w = vec4(min(vec4(tf13.x), vec4(tf13.y))).w;
        tf12.xyz = vec4(min(vec4(tf3.wwww), vec4(tf13.zzzz))).xyz;
        tf13.xyz = vec4(-_unity_SpecCube1_ProbePosition.xyzx).xyz;
        tf1.xyz = vec4(tf1.xyzx + tf13.xyzx).xyz;
        tf12.xyz = vec4(tf12.xyzx).xyz;
        tf12.xyz = vec4(tf12.xyzx).xyz;
        tf12.xyz = vec4(tf9.xyzx * tf12.xyzx).xyz;
        tf9.xyz = vec4(tf1.xyzx + tf12.xyzx).xyz;
        tf9.xyz = vec4(tf9.xyzx).xyz;
    }
    else
    {
        tf9.xyz = vec4(tf9.xyzx).xyz;
    }
    tf9.xyz = vec4(tf9.xyzx).xyz;
    tf9.xyzw = vec4(textureLod(texturesCube[1]_samplersCube[1], (tf9.xyzx).xyz, tf0.w).xyzw).xyzw;
    tf9.xyzw = vec4(tf9.xyzw).xyzw;
    tf0.w = vec4(tf9.w + -1.00000).w;
    tf0.w = vec4(tf0.w * _unity_SpecCube1_HDR.w).w;
    tf0.w = vec4(tf0.w + 1.00000).w;
    tf1.xyz = vec4(tf0.wwww * _unity_SpecCube1_HDR.xxxx).xyz;
    tf1.xyz = vec4(tf1.xyzx).xyz;
    tf1.xyz = vec4(tf1.xyzx).xyz;
    tf1.xyz = vec4(tf1.xyzx * tf9.xyzx).xyz;
    tf7.xyz = vec4(tf7.xyzx).xyz;
    tf7.xyz = vec4(tf7.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx * tf7.xyzx).xyz;
    tf7.xyz = vec4(-tf1.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx + tf7.xyzx).xyz;
    tf6.xyz = vec4(tf6.xyzx * _unity_SpecCube0_BoxMin.wwww).xyz;
    tf11.xyz = vec4(tf1.xyzx + tf6.xyzx).xyz;
    tf11.xyz = vec4(tf11.xyzx).xyz;
}

tf0.z = vec4(tf1.w + tf0.z* 0.779084).z;
tf0.z = vec4(-tf0.z).z;

tf0.z = vec4(tf0.z + 2.00000).z;
tf0.z = vec4(max(vec4(tf0.z), vec4(0))).z;
tf0.z = vec4(min(vec4(tf0.z), vec4(1.00000))).z;

// 菲涅尔近似 fresnelSchlick
// tf0.w = vec4(1.00000 - tf2.w).w;
// tf1.x = vec4(tf0.w * tf0.w).x;
// tf1.x = vec4(tf1.x * tf1.x).x;
// tf1.xyz = vec4(tf0.wwww * tf1.xxxx).xyz;
// tf1.xyz = vec4(tf1.xyzx).xyz;
tf1.xyz = pow(1.00000 - tf2.w, 5);

// F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
// tf3 = F0
//tf6.xyz = vec4(-tf3.xyzx).xyz;
//tf6.xyz = vec4(tf0.zzzz + tf6.xyzx).xyz;
//tf6.xyz = vec4(tf6.xyzx * tf1.xyzx).xyz;

tf6.xyz = (tf0.zzzz-tf3.xyzx) * tf1.xyzx;
tf6.xyz = vec4(tf3.xyzx + tf6.xyzx).xyz;


// tf5最后赋值的地方  tf5: light map color   tf4:ramp
tf5.xyw = vec4(tf4.xyxz * tf5.xyxw).xyw;

// roughness
tf0.z = vec4(-tf1.w).z;
tf0.z = vec4(tf0.z + 1.00000).z;

// NoV tf2.w * roughness
tf0.w = vec4(tf0.z * tf2.w).w;

// gloss +  NoV tf2.w * roughness
tf0.w = vec4(tf1.w + tf0.w).w;

// NoL tf8.z  * roughness
tf0.z = vec4(tf0.z * tf8.z).z;

// gloss + NoV tf8.w  * roughness
tf0.z = vec4(tf1.w + tf0.z).z;

// 相乘
tf0.z = vec4(tf0.z * tf2.w).z;

tf0.w = vec4(tf0.w * tf8.z).w;

tf0.z = vec4(tf0.z + tf0.w).z;
tf0.z = vec4(tf0.z + 1.00000e-05).z;
tf0.z = vec4(0.500000 / tf0.z).z;

tf0.w = vec4(tf1.w * tf1.w).w;
tf1.x = vec4(tf0.w * tf0.w).x;
tf0.w = vec4(tf0.w * tf0.w).w;
tf0.w = vec4(tf0.w + -1.00000).w;

tf0.w = 1 - pow(gloss, 4);

// NoH
tf0.x = vec4(tf0.x * tf0.x).x;


tf0.x = vec4(tf0.w * tf0.x).x;
tf0.x = vec4(tf0.x + 1.00000).x;
tf0.x = vec4(tf0.x * tf0.x).x;
tf0.x = vec4(tf0.x + 1.00000e-05).x;
tf0.x = vec4(tf1.x / tf0.x).x;


tf7.xyz = vec4(-tf3.xyzx).xyz;
// tf7 = 1 - ramp
tf7.xyz = vec4(tf7.xyzx + vec4(1.00000, 1.00000, 1.00000, 0)).xyz;

//tf0.w = vec4(-tf0.y).w;
//tf0.w = vec4(tf0.w + 1.00000).w;
// 1 - LoH
tf0.w = 1 - tf0.y;
// tf1.x = vec4(tf0.w * tf0.w).x;
// tf1.x = vec4(tf1.x * tf1.x).x;
// tf0.w = vec4(tf0.w * tf1.x).w;
tf0.w = pow(1 - LoH, 5)

// (1 - LoH)(1 - ramp) = 1 -ramp - LoH + LoH * ramp
tf7.xyz = vec4(tf0.wwww * tf7.xyzx).xyz;

tf3.xyz = vec4(tf3.xyzx + tf7.xyzx).xyz;
tf0.xzw = vec4(tf0.zzzz * tf0.xxxx).xzw;
tf0.xzw = vec4(tf0.xxzw).xzw;
tf0.xzw = vec4(tf0.xxzw * tf3.xxyz).xzw;

tf0.xzw = vec4(tf0.xzw * __SpecularColor.xyz).xzw;
tf0.xzw = vec4(max(vec4(tf0.xxzw), vec4(vec4(0, 0, 0, 0)))).xzw;
tf0.xzw = vec4(min(vec4(tf0.xxzw), vec4(vec4(1.00000, 0, 1.00000, 1.00000)))).xzw;


tf1.x = vec4(tf1.w + tf1.w).x;
tf1.x = vec4(tf0.y * tf1.x).x;
tf0.y = vec4(tf0.y * tf1.x).y;
tf0.y = vec4(tf0.y + 0.500000).y;
tf0.y = vec4(tf0.y + -1.00000).y;


// tf1.x = vec4(-tf8.z).x;
// tf1.x = vec4(tf1.x + 1.00000).x;
//  tf8.z : NoL
tf1.x = 1 - tf8.z;

// tf1.y = vec4(tf1.x * tf1.x).y;
// tf1.y = vec4(tf1.y * tf1.y).y;
// tf1.x = vec4(tf1.y * tf1.x).x;
// tf1.x = vec4(tf0.y * tf1.x).x;
tf1.x = pow(tf1.x, 5)

//tf1.xyw = vec4(tf1.xxxx + vec4(1.00000, 1.00000, 0, 1.00000)).xyw;

tf1.xyw = vec4(tf4.xyxz * tf1.xyxw).xyw;

tf0.y = vec4(tf1.z * tf0.y).y;
tf0.y = vec4(tf0.y + 1.00000).y;

tf1.xyz = vec4(tf0.yyyy * tf1.xywx).xyz;

// 这两步感觉像 (diffuss + specular) * lightColor
// tf0 为高光
tf0.xyz = vec4(tf0.xzwx + tf1.xyzx).xyz;
tf0.xyz = vec4(tf0.xyzx * __LightColor0.xyzx).xyz;

// tf8 = lambert dot(light, normal)
tf0.xyz = vec4(tf0.xyzx * tf8.xyzx).xyz;

// tf10  occlusion
tf0.xyz = vec4(tf0.xyzx * tf10.xyzx).xyz;

// tf5是类似lightMap * ramp
tf0.xyz = vec4(tf5.xywx + tf0.xyzx).xyz;

// tf6.xyz 菲涅尔近似
tf1.xyz = vec4(tf6.xyzx * tf11.xyzx).xyz;
tf0.xyz = vec4(tf0.xyzx + tf1.xyzx).xyz;

// tf5.z是mask z通道 目测是ao
tf0.xyz = vec4(tf5.zzzz * tf0.xyzx).xyz;

// 这个是用顶点色控制，暂时感觉没效果tf2.xy
tf0.xyz = vec4(tf2.xyzx + tf0.xyzx).xyz;

// 当前__ColorIntensity为1
tf0.xyz = vec4(tf0.xyzx * __ColorIntensity.xyzx).xyz;

tf0.w = vec4(__Color.w).w;

o_REGISTER0.xyzw = vec4(tf0.xyzw).xyzw;
v_SV_TARGET0.xyzw = o_REGISTER0.xyzw;
return;

}
