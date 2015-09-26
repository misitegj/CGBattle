//
//  CGPlayer.h
//  CGBattle
//
//  Created by Samuel on 9/26/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>


// 玩家
@interface CGPlayer : NSObject

@property (nonatomic, strong) id bagManager; // 物品栏
@property (nonatomic, strong) id cardManager; // 鉴定卡

@property (nonatomic, strong) NSMutableArray *heros; // 英雄
@property (nonatomic, strong) NSMutableArray *pets;  // 宠物

@end