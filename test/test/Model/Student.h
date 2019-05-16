//
//  Student.h
//  test
//
//  Created by rrjj on 2019/5/15.
//Copyright © 2019 rrjj. All rights reserved.
//

#import <Realm/Realm.h>

@interface Student : RLMObject
//@property (copy, nonatomic) NSString *ID;


@property  NSInteger ID;
@property  NSInteger num;
@property  NSString *name;
@property  NSString *age;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Student *><Student>
RLM_ARRAY_TYPE(Student)
