//
//  CG.h
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//
#import <Foundation/Foundation.h>

unsigned long CGRandom(unsigned long n); // 返回一个0~n-1的随机数
unsigned long CGRandom1to100(); // CGRandom(101)
BOOL CGJudgeRandom1to100(int n); // 返回是判定随机100内是否小于等于n
BOOL CGJudgeRandomFloat(float f); // 返回是判定随机, 0.0001  意思是10000分之1的概率, 最多小数点后面9位


