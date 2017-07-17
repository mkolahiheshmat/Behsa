//
// Created by Arash on 15/12/5.
// Copyright (c) 2015 Arash Z. Jahangiri. All rights reserved.
//

#import "SeconViewNameEntity.h"

@implementation SeconViewNameEntity
- (id)initwith:(id)my{
    _nameString = [NSString stringWithFormat:@"%@", (NSDictionary *)my[@"name"]];
    return [super init];
}
@end
