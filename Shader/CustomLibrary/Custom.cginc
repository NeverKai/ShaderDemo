#ifndef CUSTOM_INCLUDED
#define CUSTOM_INCLUDED

    //自定义渐变颜色测试函数  RampColorTry (渐变过程)  ramp -> lambert[-1, 1]
    fixed4 RampColorTry(float ramp)
    {
        //获取0~1。
        fixed rampMax = saturate(ramp);
        //翻转渐变，然后取0~1。
        fixed rampMin = saturate(-ramp);
        //0~1作为红色输出，0~-1作为蓝色输出
        return fixed4(rampMax, 0, rampMin, 1);
    }

    // 分段渐变 
    //  ramp -> lambert[-1, 1]
    // level 分几段 三种颜色
    fixed4 CartoonGradientColor(float ramp, int level, float4 colorLow, float4 colorMid, float4 colorHigh)
    {
        level = floor(level);
        ramp = ceil(ramp * level) / level;
        fixed4 maxColor = lerp(colorMid, colorHigh, saturate(ramp));

        // [-1, 0] => [0, 1]
        fixed4 minColor = lerp(colorLow, colorMid, saturate(ramp + 1));
        return saturate(maxColor + minColor);
    }


#endif //CUSTOM_INCLUDED