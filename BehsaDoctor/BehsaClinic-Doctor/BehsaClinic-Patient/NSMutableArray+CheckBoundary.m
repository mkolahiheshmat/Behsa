//
//  NSMutableArray+CheckBoundary.m
//  AvoidCrash
//
//  Created by Yarima on 5/23/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "NSMutableArray+CheckBoundary.h"

@implementation NSMutableArray (CheckBoundary)
- (id)myObjectAtIndex:(NSInteger)idx{
    if (idx >= [self count] || idx < 0) return @"No Value";
    return [self objectAtIndex:idx];
}

-(id)objectAtIndexedSubscript:(NSUInteger)idx{
    if (idx >= [self count]) return @"No Value";
    return [self objectAtIndex:idx];
}
@end
