#version 430

layout(location=0) in vec4 TEXCOORD0;
layout(location=1) in vec4 TEXCOORD1;
layout(location=2) in vec4 TEXCOORD2;
layout(location=3) in vec4 TEXCOORD3;

smooth out vec4 v_TEXCOORD4In;
smooth out vec4 v_TEXCOORD0In;
smooth out vec4 v_TEXCOORD1In;
smooth out vec4 v_TEXCOORD2In;
smooth out vec4 v_TEXCOORD3In;

layout(binding=0) uniform $Globals
{
vec4 _hlslcc_mtx4x4unity_ObjectToWorld[4];
vec4 _hlslcc_mtx4x4unity_WorldToObject[4];
vec4 _hlslcc_mtx4x4unity_MatrixVP[4];
};


void main()
{
vec4 i_REGISTER0;
vec4 i_REGISTER1;
vec4 i_REGISTER2;
vec4 i_REGISTER3;
i_REGISTER0.xyzw = TEXCOORD0.xyzw;
i_REGISTER1.xy = TEXCOORD1.xy;
i_REGISTER2.xyz = TEXCOORD2.xyz;
i_REGISTER3.xyz = TEXCOORD3.xyz;

vec4 o_REGISTER0;
vec4 o_REGISTER1;
vec4 o_REGISTER2;
vec4 o_REGISTER3;
vec4 o_REGISTER4;
vec4 o_REGISTER5;

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
ivec4 iTempX[2];
uvec4 uTempX[2];

tf0.xyzw = vec4(i_REGISTER0.xyzw).xyzw;
tf1.xyz = vec4(i_REGISTER2.xyzx).xyz;
tf2.xyz = vec4(i_REGISTER3.xyzx).xyz;
tf3.xy = vec4(i_REGISTER1.xyxx).xy;
tf0.xyzw = vec4(tf0.xyzw).xyzw;
tf3.xy = vec4(tf3.xyxx).xy;
tf1.xyz = vec4(tf1.xyzx).xyz;
tf2.xyz = vec4(tf2.xyzx).xyz;
tf3.xy = vec4(tf3.xyxx).xy;
tf4.x = vec4(dot(vec4(tf1.xyzx).xyz, vec4(_hlslcc_mtx4x4unity_WorldToObject[0].xyzx).xyz)).x;
tf4.y = vec4(dot(vec4(tf1.xyzx).xyz, vec4(_hlslcc_mtx4x4unity_WorldToObject[1].xyzx).xyz)).y;
tf4.z = vec4(dot(vec4(tf1.xyzx).xyz, vec4(_hlslcc_mtx4x4unity_WorldToObject[2].xyzx).xyz)).z;
tf1.x = vec4(dot(vec4(tf4.xyzx).xyz, vec4(tf4.xyzx).xyz)).x;
tf1.xyz = vec4(inversesqrt(tf1.xxxx)).xyz;
tf1.xyz = vec4(tf1.xyzx).xyz;
tf1.xyz = vec4(tf1.xyzx).xyz;
tf1.xyz = vec4(tf4.xyzx * tf1.xyzx).xyz;
tf4.xyzw = vec4(tf0.yyyy * _hlslcc_mtx4x4unity_ObjectToWorld[1].xyzw).xyzw;
tf5.xyzw = vec4(tf0.xxxx * _hlslcc_mtx4x4unity_ObjectToWorld[0].xyzw).xyzw;
tf4.xyzw = vec4(tf4.xyzw + tf5.xyzw).xyzw;
tf5.xyzw = vec4(tf0.zzzz * _hlslcc_mtx4x4unity_ObjectToWorld[2].xyzw).xyzw;
tf4.xyzw = vec4(tf4.xyzw + tf5.xyzw).xyzw;
tf0.xyz = vec4(tf0.wwww * _hlslcc_mtx4x4unity_ObjectToWorld[3].xyzx).xyz;
tf0.xyz = vec4(tf4.xyzx + tf0.xyzx).xyz;
tf4.xyzw = vec4(tf4.xyzw + _hlslcc_mtx4x4unity_ObjectToWorld[3].xyzw).xyzw;
tf2.xyz = vec4(tf2.xyzx).xyz;
tf5.xyzw = vec4(tf4.yyyy * _hlslcc_mtx4x4unity_MatrixVP[1].xyzw).xyzw;
tf6.xyzw = vec4(tf4.xxxx * _hlslcc_mtx4x4unity_MatrixVP[0].xyzw).xyzw;
tf5.xyzw = vec4(tf5.xyzw + tf6.xyzw).xyzw;
tf6.xyzw = vec4(tf4.zzzz * _hlslcc_mtx4x4unity_MatrixVP[2].xyzw).xyzw;
tf5.xyzw = vec4(tf5.xyzw + tf6.xyzw).xyzw;
tf4.xyzw = vec4(tf4.wwww * _hlslcc_mtx4x4unity_MatrixVP[3].xyzw).xyzw;
tf4.xyzw = vec4(tf5.xyzw + tf4.xyzw).xyzw;
tf4.xyzw = vec4(tf4.xyzw).xyzw;
tf5.x = vec4(tf4.x).x;
tf5.y = vec4(-tf4.y).y;
tf0.w = vec4(tf4.w + tf4.z).w;
tf5.z = vec4(tf0.w * 0.500000).z;
tf5.w = vec4(tf4.w).w;
tf1.xyz = vec4(tf1.xyzx).xyz;
tf0.xyz = vec4(tf0.xyzx).xyz;
tf2.xyz = vec4(tf2.xyzx).xyz;
tf3.xy = vec4(tf3.xyxx).xy;
tf5.x = vec4(tf5.x).x;
tf5.y = vec4(tf5.y).y;
tf5.z = vec4(tf5.z).z;
tf5.w = vec4(tf5.w).w;
tf4.xyzw = vec4(tf4.xyzw).xyzw;
tf1.xyz = vec4(tf1.xyzx).xyz;
tf0.xyz = vec4(tf0.xyzx).xyz;
tf2.xyz = vec4(tf2.xyzx).xyz;
tf3.xy = vec4(tf3.xyxx).xy;
o_REGISTER0.xyzw = vec4(tf5.xyzw).xyzw;
o_REGISTER1.xyzw = vec4(tf4.xyzw).xyzw;
o_REGISTER2.xyz = vec4(tf1.xyzx).xyz;
o_REGISTER3.xyz = vec4(tf0.xyzx).xyz;
o_REGISTER4.xyz = vec4(tf2.xyzx).xyz;
o_REGISTER5.xy = vec4(tf3.xyxx).xy;
gl_Position.xyzw = o_REGISTER0.xyzw;
v_TEXCOORD4In.xyzw = o_REGISTER1.xyzw;
v_TEXCOORD0In.xyz = o_REGISTER2.xyz;
v_TEXCOORD1In.xyz = o_REGISTER3.xyz;
v_TEXCOORD2In.xyz = o_REGISTER4.xyz;
v_TEXCOORD3In.xy = o_REGISTER5.xy;
return;

}
