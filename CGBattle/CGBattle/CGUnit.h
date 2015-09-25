//
//  CGObject.h
//  CGBattle
//
//  Created by Samuel on 9/19/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGUnit : NSObject

@property (nonatomic, assign) int UID;
@property (nonatomic, strong) NSString *originName; // 初始名
@property (nonatomic, strong) NSString *name; // 名字
@property (nonatomic, assign) int charm; // 魅力

@property (nonatomic, assign) BOOL canControl; // 是否能控制, 即是否自己的
@property (nonatomic, assign) int belong; // 我方0, 敌方1
@property (nonatomic, assign) int kind; // 种类 人形系

@property (nonatomic, assign) int hurt; // 受伤状态
@property (nonatomic, assign) int soul; // 掉魂 0~-5

@property (nonatomic, assign) int Lv; // 等级
@property (nonatomic, assign) int hp; // 生命
@property (nonatomic, assign) int mp; // 魔法
@property (nonatomic, assign) int atk; // 攻击
@property (nonatomic, assign) int def; // 防御
@property (nonatomic, assign) int agi; // 敏捷
@property (nonatomic, assign) int rep; // 回复
@property (nonatomic, assign) int spr; // 精神

@property (nonatomic, assign) int crystal; // 水晶

@property (nonatomic, strong) NSArray *skills; // 技能
@property (nonatomic, assign) int skillColumnCount; // 技能栏个数


// 5bp
@property (nonatomic, assign) int bpRemain;
@property (nonatomic, assign) int bpHp;
@property (nonatomic, assign) int bpStr;
@property (nonatomic, assign) int bpDef;
@property (nonatomic, assign) int bpAgi;
@property (nonatomic, assign) int bpMp;

// 6抗性
@property (nonatomic, assign) int rstPosion;
@property (nonatomic, assign) int rstRock;
@property (nonatomic, assign) int rstDrunk;
@property (nonatomic, assign) int rstSleepy;
@property (nonatomic, assign) int rstConfuse;
@property (nonatomic, assign) int rstForget;

// 4修正
@property (nonatomic, assign) int crtCritical;
@property (nonatomic, assign) int crtAccurate;
@property (nonatomic, assign) int crtHitBack;
@property (nonatomic, assign) int crtDodge;

// 3生产数值
@property (nonatomic, assign) int pdDex; // 灵巧
@property (nonatomic, assign) int pdSta; // 耐力
@property (nonatomic, assign) int pdWis; // 智力

// 装备
@property (nonatomic, strong) id equipAcc0; // 饰品0
@property (nonatomic, strong) id equipAcc1; // 饰品1
@property (nonatomic, strong) id equipWeapon; // 武器主手
@property (nonatomic, strong) id equipWeaponAss; // 副手
@property (nonatomic, strong) id equipClothes; // 衣服
@property (nonatomic, strong) id equipShoes; // 鞋子
@property (nonatomic, strong) id equipCrystal; // 水晶

@end



// 宠物
@interface CGPet : CGUnit
@property (nonatomic, assign) int loyalty; // 忠诚度


@end


@interface CGEnemy : CGUnit
@property (nonatomic, strong) NSArray *rootItems; // 掉落物品, 敌方only
@end


// 玩家
@interface CGPlayer : NSObject

@property (nonatomic, strong) id bagManager; // 物品栏
@property (nonatomic, strong) id cardManager; // 鉴定卡

@property (nonatomic, strong) NSMutableArray *heros; // 英雄
@property (nonatomic, strong) NSMutableArray *pets;  // 宠物

@end




