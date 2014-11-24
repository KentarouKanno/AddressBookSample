//
//  PersonData.m
//  Address_Sample
//
//  Created by KentarOu on 2014/11/24.
//  Copyright (c) 2014年 KentarOu. All rights reserved.
//

#import "PersonData.h"

@implementation PersonData

- (id)init
{
    self = [super init];
    if (self) {
        
        self.lastName = [NSString string];
        self.firstName = [NSString string];
        self.fullName = [NSString string];
        
        self.phoneNumberArray = [NSMutableArray array];
        self.phoneNumberArray = [NSMutableArray array];
        
        self.mailAddressArray = [NSMutableArray array];
        self.mailAddressLabelArray = [NSMutableArray array];
        
        self.URLArray = [NSMutableArray array];
        self.URLLabelArray = [NSMutableArray array];
        
        self.addressArray = [NSMutableArray array];
    }
    return self;
}


- (void)setPersonData:(ABRecordRef)person
{
    
    // 苗字を取得
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    self.lastName = lastName;
    NSLog(@"last Name = %@",lastName);
    
    // 名前を取得
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    self.firstName = firstName;
    NSLog(@"first Name = %@",firstName);
    
    // 氏名を取得
    NSString *fullName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    self.fullName = fullName;
    NSLog(@"full Name = %@",fullName);
    
    
    // 電話番号を取得
    ABMultiValueRef phoneRecord = ABRecordCopyValue(person, kABPersonPhoneProperty);
    int phoneNumberCount =  (int)ABMultiValueGetCount(phoneRecord);
    if (phoneNumberCount > 0) {
        for (int i = 0; i < phoneNumberCount; i++) {
            
            // 電話のラベルを取得
            NSString *phoneLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneRecord, i);
            phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            
            CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phoneRecord, i);
            [self.phoneNumberArray addObject:(__bridge NSString*)phoneNumber];
            [self.phoneNumberLabelArray addObject:phoneLabel];
            NSLog(@"phone%d:%@ = %@",i + 1,phoneLabel,phoneNumber);
        }
    }
    
    
    
    // メールアドレスを取得
    ABMultiValueRef mailRecord = (ABMultiValueRef)ABRecordCopyValue(person,kABPersonEmailProperty);
    int mailCount = (int)ABMultiValueGetCount(mailRecord);
    
    if (mailCount > 0) {
        for (int i = 0; i < mailCount; i++) {
            
            // メールアドレスのラベルを取得
            NSString *mailLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(mailRecord, i);
            mailLabel = [mailLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            mailLabel = [mailLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            
            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(mailRecord, i);
            [self.mailAddressArray addObject:email];
            [self.mailAddressLabelArray addObject:mailLabel];
            NSLog(@"mail%d:%@ = %@",i + 1,mailLabel,email);
        }
    }
    
    
    // URLを取得
    ABMultiValueRef urlRecord = ABRecordCopyValue(person, kABPersonURLProperty);
    int URLCount = (int)ABMultiValueGetCount(urlRecord);
    
    if (URLCount > 0) {
        for (int i = 0; i < URLCount; i++) {
            
            // URLのラベルを取得
            NSString *URLLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(urlRecord, i);
            URLLabel = [URLLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            URLLabel = [URLLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            
            NSString *urlString = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(urlRecord, i);
            [self.URLArray addObject:urlString];
            [self.URLLabelArray addObject:URLLabel];
            NSLog(@"URL%d:%@ = %@",i + 1,URLLabel,urlString);
        }
    }
    
    // 住所を取得
    ABMultiValueRef addressRecord = ABRecordCopyValue(person, kABPersonAddressProperty);
    int addressCount = (int)ABMultiValueGetCount(addressRecord);
    
    if (addressCount > 0) {
        for (int i = 0; i < URLCount; i++) {
            
            CFDictionaryRef addressData = ABMultiValueCopyValueAtIndex(addressRecord, i);
            
            AddressData *address = [[AddressData alloc]init];
            [address setAddressData:addressData];
            [self.addressArray addObject:address];
            
            NSLog(@"address = %@ %@ %@ %@ %@" ,address.zip,address.country,address.state,address.city,address.street);
        }
    }
    
    
    // 画像を取得
    CFDataRef  photo = ABPersonCopyImageData(person);
    if (photo) {
        UIImage* image = [UIImage imageWithData:(__bridge NSData*)photo];
        self.image = image;
        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
    }
}


@end



@implementation AddressData

- (id)init
{
    self = [super init];
    if (self) {
        
        self.country = [NSString string];
        self.countryCode = [NSString string];
        self.zip = [NSString string];
        self.state = [NSString string];
        self.city = [NSString string];
        self.street = [NSString string];
    
    }
    return self;
}

- (void)setAddressData:(CFDictionaryRef)addressData
{
    self.street = (__bridge NSString*)CFDictionaryGetValue(addressData, kABPersonAddressStreetKey);
    self.city = (__bridge NSString*)CFDictionaryGetValue(addressData, kABPersonAddressCityKey);
    self.state = (__bridge NSString*)CFDictionaryGetValue(addressData, kABPersonAddressStateKey);
    self.zip = (__bridge NSString*)CFDictionaryGetValue(addressData, kABPersonAddressZIPKey);
    self.country = (__bridge NSString*)CFDictionaryGetValue(addressData, kABPersonAddressCountryKey);
    self.countryCode = (__bridge NSString*)CFDictionaryGetValue(addressData, kABPersonAddressCountryCodeKey);
}


@end