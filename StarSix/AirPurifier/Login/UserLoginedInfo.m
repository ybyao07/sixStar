//
//  UserLoginedInfo.m
//  AirManager
//

#import "UserLoginedInfo.h"

@implementation UserLoginedInfo

- (id)init{
    self = [super init];
    if(self)
    {
        self.token = @"";
    }
    return self;
}

-(id)initWithDeviceToken:(NSString *)dicToken withUserDic:(NSDictionary *)dicUser
{
    self = [super init];
    if (self) {
        self.token = dicToken;
        self.userInfo = [[UserInfo alloc] initWithDic:dicUser];
    }
    return self;
}
@end
