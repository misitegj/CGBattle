//
//  CGAction.m
//  CGBattle
//
//  Created by Mac mini 2012 on 15/9/25.
//  Copyright (c) 2015年 Samuel. All rights reserved.
//

#import "CGAction.h"

@interface CGAction()
@property (nonatomic, strong) CGWorld *world;

@end

@implementation CGAction

- (instancetype)initWithUnit:(CGBattleUnit *)src
                       world:(CGWorld *)world
{
    self = [super init];
    if (self) {
        _src = src;
        _world = world;
        _srcLoc = src.location;
        
        [self AI_calcNextAction];
    }
    return self;
}

- (BOOL)AI_calcNextAction
{
    return randomSkillAndTarget(_src, _world.aliveSet, self);
}


- (NSArray *)doAction
{
    
    return nil;
}


@end
