//
//  TMBDispatcher.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

void tmbDispatchToMainThreadIfNecessary(dispatch_block_t block);
