//
//  CGAction.h
//  CGBattle
//
//  Created by Mac mini 2012 on 15/9/25.
//  Copyright (c) 2015年 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGUnit.h"
#import "CGWorld.h"


// 行动 用作存储
@interface CGAction : NSObject

@property (nonatomic, assign) int order;

@property (nonatomic, strong) CGUnit *src; // 行动者
@property (nonatomic, assign) int srcLoc; // 行动者位置

@property (nonatomic, strong) CGUnit *des;
@property (nonatomic, assign) int desLoc; // 下一步行动的对象位置

@property (nonatomic, assign) int skillID; // 下一步行动的技能ID

@property (nonatomic, strong) NSArray *logs; // 行动日志
@end
