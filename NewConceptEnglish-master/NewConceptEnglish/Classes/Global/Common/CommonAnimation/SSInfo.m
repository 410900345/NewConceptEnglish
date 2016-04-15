/**
 * PPInfo.m
 * PPKit
 *
 * @author Created by 闫鹏 on 16/3/9.
 * @copyright  Copyright © 2016年 pp. All rights reserved.
 *
 * @email top_yp@126.com
 * @qq    724198635
 */

#import "SSInfo.h"
#import "CommonDate.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <net/ethernet.h>

#include <ifaddrs.h>
#include <dlfcn.h>

#define BUFFERSIZE   4000
#define MAXADDRS     32
char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
char *hw_addrs[MAXADDRS];

unsigned long ip_addrs[MAXADDRS];
static   int  nextAddr = 0;

@implementation SSInfo

+(void)debugLogAppInformation {
#ifdef DEBUG
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    fprintf(stderr, "****************************************************************************************\n\n");
    fprintf(stderr, "    	copyright (c) %s, {%s}\n", [CommonDate getCurrentDayStr].UTF8String,[self appName].UTF8String);
    fprintf(stderr, "    	%s\n\n", [self appBundleIdentifier].UTF8String);
    fprintf(stderr, "    	device: %s %s\n", [self deviceModel].UTF8String, [self deviceOSVersion].UTF8String);
    fprintf(stderr, "    	ip:     %s\n", [self deviceIP].UTF8String);
    fprintf(stderr, "    	path:   %s\n", [self appHomeDirectory].UTF8String);
    fprintf(stderr, "    	date:   %s\n\n", [CommonDate getCurrentDayStr].UTF8String);
    fprintf(stderr, "****************************************************************************************\n");
#endif
#endif
}
+(NSString *)deviceOSVersion {return [[UIDevice currentDevice] systemVersion];}
+(NSString *)deviceUUID {return [[[UIDevice currentDevice] identifierForVendor] UUIDString];}
#pragma mark - 获取硬件设备型号
+(NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+(NSString *)deviceModel {
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) {
        if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
        if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
        if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
        if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s/1";
        if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s/2";
        if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5/1";
        if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5/2";
        if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c/1";
        if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c/2";
        if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
        if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4/1";
        if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4/2";
        if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4/3";
        if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
        if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    }else if ([platform hasPrefix:@"iPod"]) {
        if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
        if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
        if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
        if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
        if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    }else if ([platform hasPrefix:@"iPad"]) {
        if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G/3";
        if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G/2";
        if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G/1";
        if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air/3";
        if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air/2";
        if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air/1";
        if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4/3";
        if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4/2";
        if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4/1";
        if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3/3";
        if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3/2";
        if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3/1";
        if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G/3";
        if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G/2";
        if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G/1";
        if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2/4";
        if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2/3";
        if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2/2";
        if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2/1";
        if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    }else{
        if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
        if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    }
    return platform;
}
#pragma mark - 获取本机ip
+(NSString *)deviceIP {
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"]) {
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return @"";
}

#pragma mark - 获取本地ip
static void _InitAddresses(void) {
    for (int i = 0; i < MAXADDRS; i++) {
        if_names[i] = NULL;
        ip_names[i] = NULL;
        hw_addrs[i] = NULL;
        ip_addrs[i] = 0;
    }
}

static void _FreeAddresses(void) {
    for (int i = 0; i < MAXADDRS; i++) {
        if (if_names[i] != 0) {free(if_names[i]);}
        if (ip_names[i] != 0) {free(ip_names[i]);}
        if (hw_addrs[i] != 0) {free(hw_addrs[i]);}
        ip_addrs[i] = 0;
    }
    _InitAddresses();
}

static void _GetIPAddresses(void) {
    int                 i,len,flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in  *sin;
    char                temp[80];
    int                 sockfd;
    for (i = 0; i < MAXADDRS; i++) {
        if_names[i] = NULL;
        ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket failed");
        return;
    }
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0) {
        perror("ioct1 error");
        return;
    }
    lastname[0] = 0;
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; ) {
        ifr = (struct ifreq *)ptr;
        len = MAX(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;
        if (ifr->ifr_addr.sa_family != AF_INET) {continue;}
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) {*cptr = 0;}
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) {continue;}
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0) {continue;}
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL) {return;}
        strcpy(if_names[nextAddr], ifr->ifr_name);
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL) {return;}
        strcpy(ip_names[nextAddr], temp);
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        ++nextAddr;
    }
    close(sockfd);
}

static void _GetHWAddresses(void) {
    struct ifconf ifc;
    struct ifreq *ifr;
    int i, sockfd;
    char buffer[BUFFERSIZE], *cp, *cplim;
    char temp[80];
    for (i=0; i<MAXADDRS; ++i) {
        hw_addrs[i] = NULL;
    }
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket failed");
        return;
    }
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, (char *)&ifc) < 0) {
        perror("ioctl error");
        close(sockfd);
        return;
    }
    cplim = buffer + ifc.ifc_len;
    for (cp=buffer; cp < cplim; ) {
        ifr = (struct ifreq *)cp;
        if (ifr->ifr_addr.sa_family == AF_LINK) {
            struct sockaddr_dl *sdl = (struct sockaddr_dl *)&ifr->ifr_addr;
            int a,b,c,d,e,f;
            int i;
            strcpy(temp, (char *)ether_ntoa((const struct ether_addr *)LLADDR(sdl)));
            
            sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
            sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
            for (i=0; i<MAXADDRS; ++i) {
                if ((if_names[i] != NULL) && (strcmp(ifr->ifr_name, if_names[i]) == 0)) {
                    if (hw_addrs[i] == NULL) {
                        hw_addrs[i] = (char *)malloc(strlen(temp)+1);
                        strcpy(hw_addrs[i], temp);
                        break;
                    }
                }
            }
        }
        cp += sizeof(ifr->ifr_name) + MAX(sizeof(ifr->ifr_addr), ifr->ifr_addr.sa_len);
    }
    close(sockfd);
}

+(NSString *)localIP {
    _FreeAddresses();
    _InitAddresses();
    _GetIPAddresses();
    _GetHWAddresses();
    return [NSString stringWithFormat:@"%s",ip_names[1]];
}

+(NSString *)appName {return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];}
+(NSString *)appVersion {return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];}
+(NSString *)appBuildVersion {return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];}
+(NSString *)appBundleIdentifier {return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];}
+(NSString *)appHomeDirectory {return NSHomeDirectory();}

@end
