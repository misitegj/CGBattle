//
//  CG.c
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CG.h"
#include "stdlib.h"

// 返回一个0~n-1的随机数
unsigned long CGRandom(unsigned long n)
{
    return arc4random() % n;
}

unsigned long CGRandom1to100()
{
    return arc4random() % 100+1;
}

// 输入1-100 返回是判定随机100内是否小于等于n
BOOL CGJudgeRandom1to100(int n)
{
    if (n >= 100) {
        return YES;
    }
    if (n<=0) {
        return NO;
    }
    
    return CGRandom1to100() < n;
}

// 返回是判定随机, 0.0001  意思是10000分之1的概率
BOOL CGJudgeRandomFloat(float f)
{
    int h = 100000000;
    assert(f<=1.f && f<(h));
    return CGRandom(1.f*(h)) < (f*(h));
}