//
//  CGAction.h
//  CGBattle
//
//  Created by Mac mini 2012 on 15/9/25.
//  Copyright (c) 2015年 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGBattleUnit.h"
#import "CGWorld.h"


@interface CGAction : NSObject
@property (nonatomic, assign) int order;

@property (nonatomic, strong, readonly) CGBattleUnit *src; // 行动者
@property (nonatomic, assign, readonly) int srcLoc; // 行动者位置

@property (nonatomic, strong) CGBattleUnit *des;
@property (nonatomic, assign) int desLoc; // 下一步行动的对象位置

@property (nonatomic, assign) int skillID; // 下一步行动的技能ID

@property (nonatomic, strong) NSArray *logs; // action logs

- (instancetype)initWithUnit:(CGBattleUnit *)src
                       world:(CGWorld *)world;


- (BOOL)AI_calcNextAction; // set desLoc & skillID

- (NSArray *)doAction;

@end
