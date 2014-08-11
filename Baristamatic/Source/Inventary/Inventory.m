//
//  Inventory.m
//  Baristamatic
//
//  Created by Vadlapudi Nagaseshu on 8/7/14.
//  Copyright (c) 2014 Nagaseshu Vadlapudi. All rights reserved.
//

#import "Inventory.h"
#import "DrinkTypes.h"

static Inventory *instance = nil;

@interface Inventory()

@property (nonatomic, strong) NSMutableDictionary *inventoryDict;
@property (nonatomic, strong) NSArray *menuArrayWithIngredients;

@end

@implementation Inventory

    //Returns singleton instance for class
+ (Inventory *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Inventory alloc]init];
    });
    return instance;
}

    //This method resets the inventory when the application lauches and when user chooses to reset
- (void)resetInventory
{
    //Fill up invetory dictionary with keys and values
    self.inventoryDict = [[NSMutableDictionary alloc] initWithObjects:@[[NSNumber numberWithLong:10], [NSNumber numberWithLong:10], [NSNumber numberWithLong:10], [NSNumber numberWithLong:10], [NSNumber numberWithLong:10], [NSNumber numberWithLong:10], [NSNumber numberWithLong:10], [NSNumber numberWithLong:10], [NSNumber numberWithLong:10]] forKeys:@[WHIPPED_CREAM,  SUGAR, COCOA, DECAF_COFFEE, COFFEE, CREAM, ESPRESSO, FOAMED_MILK, STEAMED_MILK]];
    
    //Intializing menu with different coffee's
    NSArray *menu = @[CAFFEE_AMERICANO, CAPPUCCINO, COFFEE, DECAF_COFFEE, CAFFE_LATTE, CAFFEE_MOCHA];
    //Sorts menu in alphabetical order
    self.menuArray = [menu sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    //Defines menu with necessary ingredients for reference
    self.menuArrayWithIngredients = @[
                                      @{
                                          CAFFEE_AMERICANO:
                                              @{
                                                ESPRESSO:@3
                                                            }
                                          },
                                      @{
                                          CAPPUCCINO:
                                              @{
                                                  ESPRESSO:@2,
                                                  STEAMED_MILK:@1,
                                                  FOAMED_MILK:@1
                                                  }
                                          },
                                      @{
                                          COFFEE:
                                              @{
                                                  COFFEE:@3,
                                                  SUGAR:@1,
                                                  CREAM:@1
                                                  }
                                          },
                                      @{
                                          DECAF_COFFEE:
                                              @{
                                                  DECAF_COFFEE:@3,
                                                  SUGAR:@1,
                                                  CREAM:@1
                                                  }
                                          },
                                      @{
                                          CAFFE_LATTE:
                                              @{
                                                  ESPRESSO:@2,
                                                  STEAMED_MILK:@1,
                                                  }
                                          },
                                      @{
                                          CAFFEE_MOCHA:
                                              @{
                                                  ESPRESSO:@1,
                                                  COCOA:@1,
                                                  STEAMED_MILK:@1,
                                                  WHIPPED_CREAM:@1
                                                  }
                                          },
                                      ];
}

    //Prints all ingredients and remaining count of particular ingredient
- (void)printIngredients
{
    //Get ingredient types from invetory
    NSArray* ingredientTypes = [self.inventoryDict allKeys];
    //Sorts in alphabetical order
    ingredientTypes = [ingredientTypes sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    printf("\n\nInventory:\n\n");
    //Loops through each ingredient and prints available invetory
    for (NSString *ingredient in ingredientTypes)
    {
        printf("%s,%ld\n", [ingredient UTF8String], [[self.inventoryDict valueForKey:ingredient] integerValue]);
    }
}

    //Prints menu already sorted in alphabetical order
- (void)printMenu
{
    printf("\n\nMenu:\n\n");
    //Loops through each item in menuArray and prints with associated ID
    for (int i=0;i<[self.menuArray count];i++)
    {
        printf("%d,%s,%s\n", i+1, [[self.menuArray objectAtIndex:i] UTF8String], [self checkIfInventoryExists:i+1 removeItemsFromInventory:NO]?"true":"false");
    }
}

    //Checks if selected menu item is availabe for dispense and updates invetory based on boolean removeItems
    /*Accepts: menuNumber as int to find selected item
               removeItems as boolean if Invetory needs to be updated
     Returns: YES, if necessary ingredients are available for selected menu item
              NO, if necessary ingredients are not available for selected menu item
     */
- (BOOL)checkIfInventoryExists:(int)menuNumber removeItemsFromInventory:(BOOL)removeItems
{
    NSString *menuItem = [self.menuArray objectAtIndex:menuNumber-1];
    NSDictionary *particularMenuItem;
    //Loops through menuArrayWithIngredients
    for (NSDictionary *dict in self.menuArrayWithIngredients)
    {
        if ([dict valueForKey:menuItem] != nil)
        {
            //Reading selected menu item
           particularMenuItem  = [dict valueForKey:menuItem];
        }
    }
    //Get ingredients for selected menu item
    NSArray *allIngredientsForADrink = [particularMenuItem allKeys];
    //Get each ingredient count for selected menu item
    NSArray *ingredientsCountForADrink = [particularMenuItem allValues];
    
    BOOL returnValue = YES;
    for (int i=0; i<[allIngredientsForADrink count]; i++)
    {
        long count = [[self.inventoryDict valueForKey:[allIngredientsForADrink objectAtIndex:i]] longValue];
        if (count < [[ingredientsCountForADrink objectAtIndex:i] longValue])
        {
            //Makes return value NO if any ingredient is not available for selected menu item
            returnValue = NO;
        }
    }
    
    if (removeItems && returnValue)
    {
        //Update inventory based on ingredients used for selected menu item
        for (int i=0; i<[allIngredientsForADrink count]; i++)
        {
            long count = [[self.inventoryDict valueForKey:[allIngredientsForADrink objectAtIndex:i]] longValue];
            long actualvalue = count - [[ingredientsCountForADrink objectAtIndex:i] longValue];
            [self.inventoryDict setObject:[NSNumber numberWithLong:actualvalue] forKey:[allIngredientsForADrink objectAtIndex:i]];
        }
    }
    return returnValue;
}

@end
