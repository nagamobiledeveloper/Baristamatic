//
//  Inventory.h
//  Baristamatic
//
//  Created by Vadlapudi Nagaseshu on 8/7/14.
//  Copyright (c) 2014 Nagaseshu Vadlapudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inventory : NSObject

@property (nonatomic, strong) NSArray *menuArray;

+ (Inventory *)getInstance;
- (void)resetInventory;
- (void)printIngredients;
- (void)printMenu;
- (BOOL)checkIfInventoryExists:(int)menuNumber removeItemsFromInventory:(BOOL)removeItems;

@end
