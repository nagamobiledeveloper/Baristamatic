//
//  main.m
//  Baristamatic
//
//  Created by Vadlapudi Nagaseshu on 8/7/14.
//  Copyright (c) 2014 Nagaseshu Vadlapudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Inventory.h"
#import "DrinkTypes.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        Inventory *inventory = [Inventory getInstance];
        [inventory resetInventory];
        [inventory printIngredients];
        [inventory printMenu];
        
        char inputcharacter[100];
        printf("\n\n");
        scanf("%s", inputcharacter);
        NSString *characterString = [[NSString stringWithUTF8String:inputcharacter] lowercaseString];
        while (![characterString  isEqual: QUIT])
        {
            BOOL isInbetween = NSLocationInRange([characterString intValue], NSMakeRange(1, (([[inventory menuArray] count] + 1) - 1)));
            if([characterString  isEqual: RESET_INVENTORY] || isInbetween)
            {
                if ([characterString  isEqual: RESET_INVENTORY])
                {
                    [inventory resetInventory];
                    printf("\n\n");
                    [inventory printIngredients];
                    [inventory printMenu];
                }else
                {
                    BOOL coffeeTypeAvailable = NO;
                    coffeeTypeAvailable = [inventory checkIfInventoryExists:[characterString intValue] removeItemsFromInventory:YES];
                    if (coffeeTypeAvailable)
                    {
                        printf("\n");
                        printf("Dispensing: %s", [[[inventory menuArray] objectAtIndex:[characterString intValue]-1] UTF8String]);
                        printf("\n\n");
                        [inventory printIngredients];
                        [inventory printMenu];
                    }else
                    {
                        printf("Out of stock: %s", [[[inventory menuArray] objectAtIndex:[characterString intValue]-1] UTF8String]);
                    }
                }
            }else
            {
                printf("Invalid Selection: %s\n", inputcharacter);
            }
            printf("\n");
            scanf("%s", inputcharacter);
            characterString = [[NSString stringWithUTF8String:inputcharacter] lowercaseString];
        }

        printf("\n\n");
        [inventory printIngredients];
        [inventory printMenu];
    }
    return 0;
}

