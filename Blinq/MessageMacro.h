//
//  MessageMacro.h
//  cjj
//
//  Created by 聂晶 on 15/11/6.
//  Copyright © 2015年 cjj. All rights reserved.
//

#ifndef MessageMacro_h
#define MessageMacro_h

#define VERSON          0x1c
#define SERVICE_TYPE    0
#define HEADLENGTH      12
#define Flag_AND_OFFSET 0

#define DATA_MIN_LENGTH  0x02
#define PLAY_DATA_MIN_LENGTH  0x02


/**
 *  智能提醒 0x02
 */
#pragma mark - 智能提醒
#define ModID_Remind 0x02

//配置设置不需要反馈结果
#define COMMAND_ID_CONFIG_SET_NACK        0x00
//配置设置请求，需要反馈
#define COMMAND_ID_CONFIG_SET_REQ         0x01
//配置设置请求的响应
#define COMMAND_ID_CONFIG_SET_ACK         0x02
//获取配置请求，需要反馈
#define COMMAND_ID_CONFIG_GET_REQ         0x03
//获取配置请求的响应
#define COMMAND_ID_CONFIG_GET_ACK         0x04
//通知增加
#define COMMAND_ID_NTF_ADDED              0x10
//通知修改
#define COMMAND_ID_NTF_MODIFIED           0x11
//通知移除
#define COMMAND_ID_NTF_REMOVED            0x12
//事件增加
#define COMMAND_ID_EVENT_ADDED            0x20
//事件修改
#define COMMAND_ID_EVENT_MODIFIED         0x21
//事件移除
#define COMMAND_ID_EVENT_REMOVED          0x22
//增加设置
#define COMMAND_ID_NTF_SETTING_ADD        0x80
//增加设置的响应
#define COMMAND_ID_NTF_SETTING_ADD_ACK    0x81
//删除设置
#define COMMAND_ID_NTF_SETTING_REMOVE     0x82
//删除设置的响应
#define COMMAND_ID_NTF_SETTING_REMOVE_ACK 0x83
//增加特定联系人
#define COMMAND_ID_NTF_SPEC_ADD           0x84
#define COMMAND_ID_NTF_SPEC_ADD_ACK       0x85


#pragma mark-tag智能提醒(基本，久坐提醒，紧急报警，设备远离，智能通知)
//智能提醒基本模块
#define MOD_TAG_SMARTREMIND       0x00
//久坐提醒
#define MOD_TAG_SEDENTARY         0x00
//紧急报警
#define MOD_TAG_EMERGENCY	      0x02
//设备远离
#define MOD_TAG_ANTILOST          0x03
//智能通知
#define MOD_TAG_NOTIFICATIONS     0x04
//指令
#define MOD_TAG_INDICATIONS       0x05


/**
 *  固件信息模块 0x03
 */
#pragma mark - 固件信息模块
#define ModID_deviceInfo     0x03
//绑定请求
#define COMMAND_ID_BOND_REQ               0x00

//绑定请求的响应
#define COMMAND_ID_BOND_ACK               0x01

//解绑请求
#define COMMAND_ID_UNBOND_REQ             0x02

//解绑请求的响应
#define COMMAND_ID_UNBOND_ACK             0x03

//绑定状态确认
#define COMMAND_ID_BOND_STATUS_ACK        0x0F

//鉴权认证请求
#define COMMAND_ID_AUTH_REQ               0x10

//鉴权认证请求的响应
#define COMMAND_ID_AUTH_ACK               0x11

//获取系统时间
#define COMMAND_ID_GET_SYS_TIME_REQ       0x20

//获取系统时间的响应
#define COMMAND_ID_GET_SYS_TIME_ACK       0x21

//设置系统时间
#define COMMAND_ID_SET_SYS_TIME_REQ       0x22

//设置系统时间的响应
#define COMMAND_ID_SET_SYS_TIME_ACK       0x23

//超级绑定请求
#define COMMAND_ID_SUPER_BOND_REQ         0x80

//超级绑定请求的响应
#define COMMAND_ID_SUPER_BOND_ACK         0x81

//用户点击动作事件
#define EVENT_ID_USER_CLICK_ACTION        0xE0

/**
 *  防丢模块 0x05
 */
#pragma mark - 固件信息模块
#define ModID_AntiLost      0x05
//开启捕捉动作
#define COMMAND_ID_start_action              0x01
//关闭捕捉动作
#define COMMAND_ID_stop_action               0x02
//获取防丢距离(超过距离就报警)
#define COMMAND_ID_GET_AntiLost_Distance     0x03
//设置防丢距离(超过距离就报警)
#define COMMAND_ID_SET_AntiLost_Distance     0x04
//设置震动状态
#define COMMAND_ID_SET_ShakeStatus           0x05
//获取LED状态
#define COMMAND_ID_GET_LEDStatus             0x06
//设置LED状态
#define COMMAND_ID_SET_LEDStatus             0x07



//防丢距离1米
#define AntiLost_Distance_1   0x01
//防丢距离2米
#define AntiLost_Distance_2   0x02
//防丢距离3米
#define AntiLost_Distance_3   0x03
//防丢距离4米
#define AntiLost_Distance_4   0x04
//防丢距离5米
#define AntiLost_Distance_5   0x05
//防丢距离6米
#define AntiLost_Distance_6   0x06
//防丢距离7米
#define AntiLost_Distance_7   0x07
//防丢距离8米
#define AntiLost_Distance_8   0x08
//防丢距离9米
#define AntiLost_Distance_9   0x09
//防丢距离10米
#define AntiLost_Distance_10   0x0A

//防丢颜色-无色
#define AntiLost_Color_C 0x00
//防丢颜色-红色
#define AntiLost_Color_R 0x01
//防丢颜色-蓝色
#define AntiLost_Color_B 0x02
//防丢颜色-品红
#define AntiLost_Color_RB 0x03
//防丢颜色-绿色
#define AntiLost_Color_G 0x04
//防丢颜色-黄色
#define AntiLost_Color_RG 0x05
//防丢颜色-青色
#define AntiLost_Color_GB 0x06
//防丢颜色-橙色
#define AntiLost_Color_RGB 0x07

//防丢Timer--0s
#define AntiLost_Timer_0 0x00
//防丢Timer--1s
#define AntiLost_Timer_1 0x01
//防丢Timer--2s
#define AntiLost_Timer_2 0x02
//防丢Timer--3s
#define AntiLost_Timer_3 0x03
//防丢Timer--4s
#define AntiLost_Timer_4 0x04
//防丢Timer--5s
#define AntiLost_Timer_5 0x05
//防丢Timer--6s
#define AntiLost_Timer_6 0x06
//防丢Timer--7s
#define AntiLost_Timer_7 0x07


/**
 *   玩一玩 0x06
 */
#pragma mark - 玩一玩
#define ModID_Play 0x06
//配置闪灯颜色，无需反馈结果
#define COMMAND_ID_COLOR_SET_NACK 0x00
//配置闪灯颜色请求，需要反馈
#define COMMAND_ID_COLOR_SET_REQ 0x01
//配置闪灯颜色请求的响应
#define COMMAND_ID_COLOR_SET_ACK 0x02
//获取闪灯颜色请求，需要反馈
#define COMMAND_ID_COLOR_GET_REQ 0x03
//获取闪灯颜色请求的响应
#define COMMAND_ID_COLOR_GET_ACK 0x04
//配置震动请求，无需反馈结果
#define COMMAND_ID_VIB_SET_NACK 0x10
//配置震动请求，需要反馈
#define COMMAND_ID_VIB_SET_REQ 0x11
//配置震动请求的响应
#define COMMAND_ID_VIB_SET_ACK 0x12


/**
 *  ERRCODE定义
 */
#pragma mark - ERRCODE定义
#define ERR_CODE_OK                            0x00
#define ERR_CODE_INVALID_DATA_LENGTH           0x01
#define ERR_CODE_READ_MEM_FAILED               0x02
#define ERR_CODE_WRITE_MEM_FAILED              0x03
#define ERR_CODE_MALLOC_MEM_FAILED             0x04
#define ERR_CODE_NO_NTF_SETTINGS               0x05
#define ERR_CODE_INVALID_MOD_TAG               0x06
#define ERR_CODE_INVALID_MOD_DATA              0x07
#define ERR_CODE_INVALID_CMD                   0x08
#define ERR_CODE_NO_SPACE_AVAILABLE		       0x09
#define ERR_CODE_NTF_SETTINGS_ALREADY_EXIST    0x10
#define ERR_CODE_COMMAND_DISALLOWED            0x43
#define ERR_CODE_DEVICE_NOT_BONDED             0x80
#define ERR_CODE_CURR_STATE_DISALLOWED         0xA0

/**
 ** color
 **/
#define Color_CLOSE            0x00
#define Color_RED              0x01
#define Color_GREEN            0x02
#define Color_BLUE             0x04
#define Color_YELLOW           0x03
#define Color_PURPLE           0x05
#define Color_INDIGO           0x06
#define Color_WHITE            0x07
/**
 ** 震动
 **/
#define VIB_LEVEL_OFF          0x00
#define VIB_LEVEL_1            0x01
#define VIB_LEVEL_2            0x02
#define VIB_LEVEL_3            0x03
#define VIB_LEVEL_4            0x05
#define VIB_LEVEL_5            0x06
#define VIB_LEVEL_6            0x07


#define TYPE_TAG_SMARTREMIND  0x00
#define TYPE_TAG_SEDENTARY  0x01
#define TYPE_TAG_EMERGENCY  0x02
#define TYPE_TAG_ANTILOST  0x03
#define TYPE_TAG_NOTIFICATIONS  0x04


#define CONFIG_ERR_CODE_OK  0x00
#define CONFIG_ERR_CODE_INVALID_DATA_LENGTH  0x01
#define CONFIG_ERR_CODE_READ_MEM_FAILED  0x02
#define CONFIG_ERR_CODE_WRITE_MEM_FAILE 0x03
#define CONFIG_ERR_CODE_MALLOC_MEM_FAILED 0x04
#define CONFIG_ERR_CODE_NO_NTF_SETTINGS 0x05
#define CONFIG_ERR_CODE_INVALID_MOD_TAG 0x06
#define CONFIG_ERR_CODE_INVALID_MOD_DAT 0x07





#endif /* MessageMacro_h */
