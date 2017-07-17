//
//  BranchesModel.h
//  BehsaClinic-Patient
//
//  Created by Yarima on 3/28/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BranchModel : NSObject
@property (nonatomic)NSInteger idx;
@property (copy, nonatomic) NSString *nameString;
@property (copy, nonatomic) NSString *phoneString;
@property (nonatomic)double latitude;
@property (nonatomic)double longitude;
@end
