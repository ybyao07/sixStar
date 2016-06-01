//
//  CommandSave.m
//  WebAirpal
//
//  Created by ybyao07 on 16/3/23.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import "CommandSave.h"

@implementation CommandSave

+(void)writeCommandSave:(CommandSave *)cmd
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:@"cmdSave.archiver"];//拓展名可以自己随便取
    [NSKeyedArchiver archiveRootObject:cmd toFile:path];
}
//读取 缓存指令
+(CommandSave *)readCommandSave{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:@"cmdSave.archiver"];
    CommandSave *cmd = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (cmd == nil) {
        cmd = [[CommandSave alloc] init];
        cmd.cmdCode = @" ";
    }
    return cmd;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mac forKey:@"Device_mac"];
    [aCoder encodeObject:self.cmdCode forKey:@"Device_cmd"];
    [aCoder encodeObject:self.time forKey:@"Device_time"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    _mac = [aDecoder decodeObjectForKey:@"Device_mac"];
    _cmdCode = [aDecoder decodeObjectForKey:@"Device_cmd"];
    _time = [aDecoder decodeObjectForKey:@"Device_time"];
    return self;
}
@end
