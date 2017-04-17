//
//  AppConstant.h
//
//

//主菜单枚举
typedef NS_ENUM(NSInteger, MenuCategory)
{
    PARKING = 10001,
    GASSTATION = 10002,
    CLEANCAREN = 10003,
    CARMAINTENANCE = 10004,
    BILL = 10005,
    MINE = 10006,
    MORE = 10007,
};

typedef NS_ENUM(NSInteger, AlertViewTag)
{
    AlertViewTag_CustomerServicePhone = 10001,
    AlertViewTag_Logout = 10002,
    AlertViewTag_UpdateNewApp = 10003,
};

#define TAG_TEXTFIELD_TEL 100001
#define TAG_TEXTFIELD_NAME 100002

#define TRANSFER_CHARACTERISTIC_UUID_FFE5    @"FFE5"
//
#define TRANSFER_CHARACTERISTIC_UUID_2A06    @"2A06"
//hardware Revision
#define TRANSFER_CHARACTERISTIC_UUID_2A27    @"2A27"
//software Revision
#define TRANSFER_CHARACTERISTIC_UUID_2A28    @"2A28"

//写
static NSString* SMDATAWRITE = @"0783b03e-8535-b5a0-7140-a304d2495cba";
//读
static NSString* SMDATAREAD = @"0783b03e-8535-b5a0-7140-a304d2495cb8";

///电池电量多少
static NSString* SMBATTERYLEVEL = @"2A19";

//jiezi固件的固件版本
static NSString* SMBATTERY_SMARTDEVICE_HW_REVISION_UUID = @"00002a27-0000-1000-8000-00805f9b34fb";

//jiezi固件的软件版本
static NSString* SMBATTERY_SMARTDEVICE_SW_REVISION_UUID = @"00002a28-0000-1000-8000-00805f9b34fb";

///电池电量状态 1表示在正在充电
static NSString* SMBATTERYSTATUS = @"0783B03E-8535-B5A0-7140-A304D2495CBB";

static NSString* kCBAdvDataLocalName = @"SHAREMORE RING";

//CBUUID
static NSString* kCBAdvDataServceUUID= @"0783B03E-8535-B5A0-7140-A304D2495CB7";



//断开通知
#define NOTIFICATION_DIDDISCONNECTPERIPHERAL @"NOTIFICATION_DIDDISCONNECTPERIPHERAL"
//紧急求救通知
#define NOTIFICATION_SOS                     @"NOTIFICATION_SOS"
//验证通知
#define NOTIFICATION_AUTH                    @"NOTIFICATION_AUTH"
//敲击动作的通知
#define NOTIFICATION_USER_CLICK              @"NOTIFICATION_USER_CLICK"
//经纬度
#define NOTIFICATION_CLGEOCODER              @"NOTIFICATION_CLGEOCODER"
//地址
#define NOTIFICATION_LOCATION                @"NOTIFICATION_LOCATION"
//蓝牙关闭
#define NOTIFICATION_BLUETOOTH_OFF           @"NOTIFICATION_BLUETOOTH_OFF"
//蓝牙打开
#define NOTIFICATION_BLUETOOTH_ON            @"NOTIFICATION_BLUETOOTH_ON"
//电量
#define NOTIFICATION_BATTERY                 @"NOTIFICATION_BATTERY"

//固件的硬件版本
#define NOTIFICATION_SMARTDEVICE_HW_REVISION_UUID            @"NOTIFICATION_SMARTDEVICE_HW_REVISION_UUID"
//固件的软件版本
#define NOTIFICATION_SMARTDEVICE_SW_REVISION_UUID    @"NOTIFICATION_SMARTDEVICE_SW_REVISION_UUID"


#define RemindNotification @"RemindNotification"

#define NOTIFICATION_EVENT_ADDED  @"NOTIFICATION_EVENT_ADDED"

#define NOTIFICATION_REMIND_ERROR            @"NOTIFICATION_REMIND_ERROR"

#define NOTIFICATION_SETTING_ADD_ACK  @"NOTIFICATION_SETTING_ADD_ACK"

#define STATUS_RM @"STATUS_RM"
#define STATUS_SOS @"STATUS_SOS"

//保存

#define NSUserDefaults_CONNECT_NSUUID               @"NSUserDefaults_CONNECT_NSUUID"
#define NSUserDefaults_SOS_MSG                      @"NSUserDefaults_SOS_MSG"
#define NSUserDefaults_SOS_NAME                     @"NSUserDefaults_SOS_NAME"
#define NSUserDefaults_SOS_MYTEL                    @"NSUserDefaults_SOS_MYTEL"
#define NSUserDefaults_SOS_TEL                      @"NSUserDefaults_SOS_TEL"
//#define NSUserDefaults_Notice_POWER                 @"NSUserDefaults_Notice_POWER"
//#define NSUserDefaults_Antilost                     @"NSUserDefaults_Antilost"


#define NSUserDefaults_VIPCONTACT_NAME_TEL                   @"NSUserDefaults_VIPCONTACT_NAME_TEL"
#define NSUserDefaults_VIPCONTACT_POWER                   @"NSUserDefaults_VIPCONTACT_POWER"
//验证标识
#define AUTH_ERRCODESUCCESS    @"成功"
#define AUTH_ERRCODEFAILED     @"失败"

//电量状态
//正在充电
#define BATTERY_STATUS_CHARGING      1
#define BATTERY_STATUS_ELECTRICITY   0

//Indicate that a notification of the Notification Source characteristic has been received。
#define INDICATE_ID_6  6
//Indicate that the value of a notification attribute is available。
#define INDICATE_ID_8  8


//ANCS CATID
#define CategoryIDOther                     0
#define CategoryIDIncomingCall              1
#define CategoryIDMissedCall                2
#define CategoryIDVoicemail                 3
#define CategoryIDSocial                    4
#define CategoryIDSchedule                  5
#define CategoryIDEmail                     6
#define CategoryIDNews                      7
#define CategoryIDHealthAndFitness          8
#define CategoryIDBusinessAndFitnance       9
#define CategoryIDLocation                  10
#define CategoryIDEntertainment             11

//ANCS EventID Values
#define EventIDNotificationAdded            0
#define EventIDNotificationModified         1
#define EventIDNotificationRemoved          2





