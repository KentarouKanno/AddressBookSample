//
//  PersonData.h
//  Address_Sample
//
//  Created by KentarOu on 2014/11/24.
//  Copyright (c) 2014年 KentarOu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PersonData : NSObject

// 名前
@property (strong ,nonatomic) NSString *lastName;
@property (strong ,nonatomic) NSString *firstName;
@property (strong ,nonatomic) NSString *fullName;

// 電話番号
@property (strong ,nonatomic) NSMutableArray *phoneNumberArray;
@property (strong ,nonatomic) NSMutableArray *phoneNumberLabelArray;

// メールアドレス
@property (strong ,nonatomic) NSMutableArray *mailAddressArray;
@property (strong ,nonatomic) NSMutableArray *mailAddressLabelArray;

// URL
@property (strong ,nonatomic) NSMutableArray *URLArray;
@property (strong ,nonatomic) NSMutableArray *URLLabelArray;

// 住所
@property (strong ,nonatomic) NSMutableArray *addressArray;

// 画像
@property (strong ,nonatomic) UIImage *image;



// setPersonData
- (void)setPersonData:(ABRecordRef)person;

@end


@interface AddressData : NSObject

// 住所
@property (strong ,nonatomic) NSString *country;
@property (strong ,nonatomic) NSString *countryCode;
@property (strong ,nonatomic) NSString *zip;
@property (strong ,nonatomic) NSString *state;
@property (strong ,nonatomic) NSString *city;
@property (strong ,nonatomic) NSString *street;

// setAddressData
- (void)setAddressData:(CFDictionaryRef)addressData;

@end
