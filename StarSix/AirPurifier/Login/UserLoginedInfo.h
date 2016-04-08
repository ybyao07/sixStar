//
//  UserLoginedInfo.h
//  AirManager
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserLoginedInfo :NSObject

@property (nonatomic, strong) NSString *token;

@property (nonatomic) BOOL noticeFilter;
@property (nonatomic) BOOL noticePM;
@property (nonatomic) int noticePMV;

@property (nonatomic, strong) NSMutableArray *arrUserBindedDevice;//绑定的设备
@property (nonatomic, strong) UserInfo *userInfo;


-(id)initWithDeviceToken:(NSString *)dicToken withUserDic:(NSDictionary *)dicUser;


@end
