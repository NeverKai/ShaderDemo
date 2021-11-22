#version 430

smooth in vec4 v_TEXCOORD4;
smooth in vec4 v_TEXCOORD0;
smooth in vec4 v_TEXCOORD1;
smooth in vec4 v_TEXCOORD2;
smooth in vec4 v_TEXCOORD3;

layout(location=0) out vec4 v_SV_TARGET0;

layout(binding=0) uniform $Globals
{
    vec3 __WorldSpaceCameraPos;
    vec4 __WorldSpaceLightPos0;
    vec4 __LightColor0;
    vec4 __GlobalCharColor;
    vec4 __Color;
    float __FirstShadow;
    float __SecondShadow;
    vec4 __FirstShadowMultColor;
    vec4 __SecondShadowMultColor;
    float __ShadowSmooth;
    float __Shininess;
    vec4 __LightSpecColor;
    float __SpecMulti;
    float __SpecSmooth;
    float __SmoothMin;
    vec4 __LightVector;
    vec4 __Contourlight;
    vec4 __CustomLightDir;
    float __LightColorInf;
    float __LightColorInt;
    vec4 __EmissiveColorA;
    vec4 __EmissiveColorB;
    float __FresnelRange;
    float __MainTexInvisible;
};

uniform sampler2D textures2D[0]_samplers2D[0];
uniform sampler2D textures2D[1]_samplers2D[1];

void main()
{
vec4 i_REGISTER2;
vec4 i_REGISTER3;
vec4 i_REGISTER4;
vec4 i_REGISTER5;
i_REGISTER2.xyz = v_TEXCOORD0.xyz;
i_REGISTER3.xyz = v_TEXCOORD1.xyz;
i_REGISTER4.xyz = v_TEXCOORD2.xyz;
i_REGISTER5.xy = v_TEXCOORD3.xy;

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
ivec4 iTempX[2];
uvec4 uTempX[2];

// worldNormal
tf0.xyz = vec4(i_REGISTER2.xyzx).xyz;
// worldPosition
tf1.xyz = vec4(i_REGISTER3.xyzx).xyz;

// 应该是顶点色，目前值都是0， 0， 0， 1
tf2.xyz = vec4(i_REGISTER4.xyzx).xyz;

//tf0.w = vec4(dot(vec4(tf0.xyzx).xyz, vec4(tf0.xyzx).xyz)).w;
//tf0.w = vec4(inversesqrt(tf0.w)).w;
//tf0.xyz = vec4(tf0.xyzx * tf0.wwww).xyz;

tf0.xyz = normalize(tf0);

ti0.w = (float(0.500000) < float(__CustomLightDir.w)) ? -1 : 0;
if (bool(ti0.w))
{
    // tf0.w = vec4(dot(vec4(__CustomLightDir.xyzx).xyz, vec4(__CustomLightDir.xyzx).xyz)).w;
    // tf0.w = vec4(inversesqrt(tf0.w)).w;
    // tf3.xyz = vec4(tf0.wwww * __CustomLightDir.xyzx).xyz;
    tf3.xyz = normalize(__CustomLightDir);
    tf3.xyz = vec4(tf3.xyzx).xyz;

    tf4.xyz = vec4(__GlobalCharColor.xyzx * __Color.xyzx).xyz;
}
else
{
    // tf5.xyz = vec4(-tf1.xyzx).xyz;
    // tf5.xyz = vec4(tf5.xyzx * __WorldSpaceLightPos0.wwww).xyz;
    // tf5.xyz = vec4(tf5.xyzx + __WorldSpaceLightPos0.xyzx).xyz;
    // tf0.w = vec4(dot(vec4(tf5.xyzx).xyz, vec4(tf5.xyzx).xyz)).w;
    // tf6.xyz = vec4(inversesqrt(tf0.wwww)).xyz;
    // tf6.xyz = vec4(tf6.xyzx).xyz;
    // tf3.xyz = vec4(tf5.xyzx * tf6.xyzx).xyz;
    tf3.xyz = normalize(lightWorldDir);
    tf4.xyz = vec4(__Color.xyzx).xyz;
}

//tf0.w = vec4(dot(vec4(tf0.xyzx).xyz, vec4(tf3.xyzx).xyz)).w;
//tf0.w = vec4(tf0.w * 0.500000).w;
//tf0.w = vec4(tf0.w + 0.500000).w;
float NoL = dot(i.normal, lightWorldir);
float halfLambert = NoL * 0.5 + 0.5;
tf0.w = halfLambert;

tf5.xyzw = vec4(texture(textures2D[0]_samplers2D[0], vec4(i_REGISTER5.xyxx).xy).xyzw).xyzw;

tf6.xyz = vec4(texture(textures2D[1]_samplers2D[1], vec4(i_REGISTER5.xyxx).xy).xyzw).xyz;


ti1.w = (float(tf6.y) < float(0.100000)) ? -1 : 0;
tf2.w = vec4(tf0.w + tf6.y).w;


// tf7.xyz = vec4(-__FirstShadowMultColor.xyzx).xyz;
// tf7.xyz = vec4(tf7.xyzx + __SecondShadowMultColor.xyzx).xyz;
// tf7.xyz = vec4(tf2.zzzz * tf7.xyzx).xyz;
// tf7.xyz = vec4(tf7.xyzx + __FirstShadowMultColor.xyzx).xyz;
tf7.xyz = lerp(__FirstShadowMultColor, __SecondShadowMultColor, tf2.z);

tf8.xyz = vec4(tf5.xyzx * tf7.xyzx).xyz;

// tf2.z = vec4(-tf2.w).z;
// tf2.z = vec4(tf2.z * 0.500000).z;
// tf2.z = vec4(tf2.z + __SecondShadow).z;
tf2.z = __SecondShadow - tf2.w * 0.5;

tf2.w = vec4(__ShadowSmooth + __ShadowSmooth).w;
tf2.z = vec4(tf2.z + __ShadowSmooth).z;
tf2.w = vec4(1.00000 / tf2.w).w;
tf2.z = vec4(tf2.z * tf2.w).z;
tf2.z = vec4(max(vec4(tf2.z), vec4(0))).z;
tf2.z = vec4(min(vec4(tf2.z), vec4(1.00000))).z;
tf2.w = vec4(tf2.z * -2.00000).w;
tf2.w = vec4(tf2.w + 3.00000).w;
tf2.z = vec4(tf2.z * tf2.z).z;
tf2.z = vec4(tf2.w * tf2.z).z;

tf9.xyz = vec4(tf5.xyzx * __SecondShadowMultColor.xyzx).xyz;
tf10.xyz = vec4(-tf8.xyzx).xyz;
tf9.xyz = vec4(tf9.xyzx + tf10.xyzx).xyz;
tf9.xyz = vec4(tf2.zzzz * tf9.xyzx).xyz;
tf8.xyz = vec4(tf8.xyzx + tf9.xyzx).xyz;


ti2.z = (float(tf6.y) >= float(0.500000)) ? -1 : 0;
tf6.yw = vec4(tf6.yyyy * vec4(0, 1.20000, 0, 1.25000)).yw;
tf6.yw = vec4(tf6.wwwy + vec4(0, -0.125000, 0, -0.100000)).yw;
if (bool(ti2.z))
{
    tf6.y = vec4(tf6.w).y;
}
else
{
    tf6.y = vec4(tf6.y).y;
}
tf6.y = vec4(tf6.y).y;
tf0.w = vec4(tf0.w + tf6.y).w;
tf2.z = vec4(tf0.w * 0.500000).z;
ti2.z = (float(tf2.z) < float(__FirstShadow)) ? -1 : 0;

tf0.w = vec4(-tf0.w).w;
tf0.w = vec4(tf0.w * 0.500000).w;
tf0.w = vec4(tf0.w + __FirstShadow).w;
tf2.w = vec4(1.00000 / __ShadowSmooth).w;
tf0.w = vec4(tf0.w * tf2.w).w;
tf0.w = vec4(max(vec4(tf0.w), vec4(0))).w;
tf0.w = vec4(min(vec4(tf0.w), vec4(1.00000))).w;
tf2.w = vec4(tf0.w * -2.00000).w;
tf2.w = vec4(tf2.w + 3.00000).w;
tf0.w = vec4(tf0.w * tf0.w).w;
tf9.xyz = vec4(tf2.wwww * tf0.wwww).xyz;

tf7.xyz = vec4(tf5.xyzx * tf7.xyzx).xyz;
tf10.xyz = vec4(-tf5.xyzx).xyz;
tf7.xyz = vec4(tf7.xyzx + tf10.xyzx).xyz;
tf9.xyz = vec4(tf9.xyzx).xyz;

tf7.xyz = vec4(tf7.xyzx * tf9.xyzx).xyz;
tf7.xyz = vec4(tf5.xyzx + tf7.xyzx).xyz;
if (bool(ti2.z))
{
    tf5.xyz = vec4(tf7.xyzx).xyz;
}
else
{
    tf5.xyz = vec4(tf5.xyzx).xyz;
}

tf5.xyz = vec4(tf5.xyzx).xyz;
if (bool(ti1.w))
{
    tf5.xyz = vec4(tf8.xyzx).xyz;
}
else
{
    tf5.xyz = vec4(tf5.xyzx).xyz;
}

tf5.xyz = vec4(tf5.xyzx).xyz;


// tf1.xyz = vec4(-tf1.xyzx).xyz;
// tf1.xyz = vec4(tf1.xyzx + __WorldSpaceCameraPos.xyzx).xyz;
tf1.xyz = ViewDir;

// tf0.w = vec4(dot(vec4(tf1.xyzx).xyz, vec4(tf1.xyzx).xyz)).w;
// tf7.xyz = vec4(inversesqrt(tf0.wwww)).xyz;
// tf8.xyz = vec4(tf7.zzzz).xyz;
// tf8.xyz = vec4(tf8.xyzx).xyz;
// tf8.xyz = vec4(tf1.xyzx * tf8.xyzx).xyz;
tf8.xyz= normalize(ViewDir);

tf7.xyz = vec4(tf7.xyzx).xyz;
tf7.xyz = vec4(tf7.xyzx).xyz;
tf1.xyz = vec4(tf1.xyzx * tf7.xyzx).xyz;
tf1.xyz = vec4(tf3.xyzx + tf1.xyzx).xyz;


tf0.w = vec4(dot(vec4(tf1.xyzx).xyz, vec4(tf1.xyzx).xyz)).w;
tf3.xyz = vec4(inversesqrt(tf0.wwww)).xyz;
tf3.xyz = vec4(tf3.xyzx).xyz;


tf1.xyz = vec4(tf1.xyzx * tf3.xyzx).xyz;
tf0.w = vec4(dot(vec4(tf0.xyzx).xyz, vec4(tf1.xyzx).xyz)).w;
tf0.w = vec4(max(vec4(tf0.w), vec4(0))).w;
tf1.x = vec4(tf6.x * __Shininess).x;
tf0.w = vec4(log2(tf0.w)).w;
tf0.w = vec4(tf1.x * tf0.w).w;
tf0.w = vec4(exp2(tf0.w)).w;
tf0.w = vec4(tf0.w + tf6.z).w;
ti1.x = (float(tf0.w) >= float(1.00000)) ? -1 : 0;
tf1.yzw = vec4(__SpecMulti).yzw;
tf1.yzw = vec4(tf1.yyzw).yzw;
tf1.yzw = vec4(tf1.yyzw * __LightSpecColor.xxyz).yzw;
tf1.yzw = vec4(tf1.yyzw * tf6.xxxx).yzw;
tf0.w = vec4(tf0.w + -1.00000).w;
tf2.z = vec4(1.00000 / __SpecSmooth).z;
tf0.w = vec4(tf0.w * tf2.z).w;
tf0.w = vec4(max(vec4(tf0.w), vec4(0))).w;
tf0.w = vec4(min(vec4(tf0.w), vec4(1.00000))).w;
tf2.z = vec4(tf0.w * -2.00000).z;
tf2.z = vec4(tf2.z + 3.00000).z;
tf0.w = vec4(tf0.w * tf0.w).w;
tf3.xyz = vec4(tf2.zzzz * tf0.wwww).xyz;
tf3.xyz = vec4(tf3.xyzx).xyz;
tf3.xyz = vec4(tf3.xyzx).xyz;
tf1.yzw = vec4(tf1.yyzw * tf3.xxyz).yzw;
if (bool(ti1.x))
{
    tf1.yzw = vec4(tf1.yyzw).yzw;
}
else
{
    ti1.yzw = ivec4(ivec4(0, 0, 0, 0)).yzw;
}
ti1.yzw = ivec4(ti1.yyzw).yzw;

// tf0.w = vec4(dot(vec4(__LightVector.xyzw), vec4(__LightVector.xyzw))).w;
// tf3.xyz = vec4(inversesqrt(tf0.wwww)).xyz;
// tf3.xyz = vec4(tf3.xyzx).xyz;
// tf3.xyz = vec4(tf3.xyzx).xyz;
// tf3.xyz = vec4(tf3.xyzx * __LightVector.xyzx).xyz;
tf3.xyz = normalize(__LightVector);


tf0.w = vec4(dot(vec4(tf3.xyzx).xyz, vec4(tf8.xyzx).xyz)).w;
tf1.x = vec4(dot(vec4(tf3.xyzx).xyz, vec4(tf0.xyzx).xyz)).x;
tf1.x = vec4(max(vec4(tf1.x), vec4(0))).x;
tf1.x = vec4(min(vec4(tf1.x), vec4(1.00000))).x;

tf0.x = vec4(dot(vec4(tf8.xyzx).xyz, vec4(tf0.xyzx).xyz)).x;
tf0.x = vec4(-tf0.x).x;
tf0.x = vec4(tf0.x + 1.00000).x;
tf0.x = vec4(max(vec4(tf0.x), vec4(0))).x;
tf0.x = vec4(min(vec4(tf0.x), vec4(1.00000))).x;

tf0.y = vec4(-tf0.w).y;
tf0.yzw = vec4(tf0.yyyy + vec4(0, 1.00000, 1.00000, 1.00000)).yzw;
tf2.z = vec4(-__SmoothMin).z;
tf1.x = vec4(tf1.x + tf2.z).x;
tf2.z = vec4(-__SmoothMin).z;
tf2.z = vec4(tf2.z + 1.00000).z;
tf1.x = vec4(tf1.x / tf2.z).x;
tf1.x = vec4(max(vec4(tf1.x), vec4(0))).x;
tf1.x = vec4(min(vec4(tf1.x), vec4(1.00000))).x;

tf2.z = vec4(tf0.x * tf0.x).z;
tf2.z = vec4(tf0.x * tf2.z).z;
tf3.xyz = vec4(tf1.xxxx * tf2.zzzz).xyz;
tf3.xyz = vec4(tf3.xyzx).xyz;
tf3.xyz = vec4(tf3.xyzx).xyz;
tf3.xyz = vec4(tf3.xyzx * __Contourlight.xyzx).xyz;
tf0.yzw = vec4(tf0.yyzw).yzw;
tf0.yzw = vec4(tf0.yyzw).yzw;
tf0.yzw = vec4(tf0.yyzw * tf3.xxyz).yzw;
tf1.xyz = vec4(ti1.yzwy + tf5.xyzx).xyz;


tf3.xyz = vec4(vec4(2.00000, 2.00000, 2.00000, 0) * __LightColor0.xyzx).xyz;
tf5.xyz =  vec4(-__LightColorInt).xyz;
tf3.xyz = vec4(tf3.xyzx + tf5.xyzx).xyz;

tf5.xyz = vec4(__LightColorInf).xyz;
tf3.xyz = vec4(tf3.xyzx * tf5.xyzx).xyz;

tf5.xyz = vec4(__LightColorInt).xyz;
tf3.xyz = vec4(tf3.xyzx + tf5.xyzx).xyz;

tf1.xyz = vec4(tf1.xyzx * tf3.xyzx).xyz;
tf1.xyz = vec4(tf1.xyzx * tf4.xyzx).xyz;

tf1.xyz = vec4(tf1.xyzx * __GlobalCharColor.xyzx).xyz;
tf0.yzw = vec4(tf0.yyzw + tf1.xxyz).yzw;
tf1.xyz = vec4(tf2.xxxx * __EmissiveColorA.xyzx).xyz;
tf0.yzw = vec4(tf0.yyzw + tf1.xxyz).yzw;
tf1.xyz = vec4(tf2.yyyy * __EmissiveColorB.xyzx).xyz;


tf0.yzw = vec4(tf0.yyzw + tf1.xxyz).yzw;
tf0.x = vec4(log2(tf0.x)).x;
tf0.x = vec4(tf0.x * __FresnelRange).x;
tf1.xyz = vec4(exp2(tf0.xxxx)).xyz;

tf2.xyz = vec4(__MainTexInvisible).xyz;

tf1.xyz = vec4(tf1.xyzx).xyz;

tf1.xyz = vec4(tf1.xyzx * tf2.xyzx).xyz;
tf0.xyz = vec4(tf0.yzwy + tf1.xyzx).xyz;


// tf1.x = vec4(-tf5.w).x;
// tf1.x = vec4(tf1.x + 0.400000).x;
// tf1.x = vec4(tf1.x * __MainTexInvisible).x;
// tf0.w = vec4(tf5.w + tf1.x).w;
tf0.w  = lerp(tf5.w, 0.4, __MainTexInvisible)

tf0.xyzw = vec4(tf0.xyzw).xyzw;

o_REGISTER0.xyzw = vec4(tf0.xyzw).xyzw;
v_SV_TARGET0.xyzw = o_REGISTER0.xyzw;
return;

}
