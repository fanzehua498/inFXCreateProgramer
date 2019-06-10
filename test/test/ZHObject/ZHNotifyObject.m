//
//  ZHNotifyObject.m
//  test
//
//  Created by rrjj on 2019/6/10.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHNotifyObject.h"

@implementation ZHNotifyObject
-(void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
}


//-(void)willChangeValueForKey:(NSString *)key
//{
//    NSLog(@"will:%@",key);
//}
//
//- (void)didChangeValueForKey:(NSString *)key
//{
//     NSLog(@"did%@",key);
//}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@",change);
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"name"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

@end
