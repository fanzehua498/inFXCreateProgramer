//
//  Books.h
//  test
//
//  Created by rrjj on 2019/5/16.
//Copyright © 2019 rrjj. All rights reserved.
//

#import <Realm/Realm.h>

@interface Books : RLMObject
@property  NSInteger BOOKID;
@property  NSInteger Price;
@property  NSString *name;
@property  NSString *author;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Books *><Books>
RLM_ARRAY_TYPE(Books)
