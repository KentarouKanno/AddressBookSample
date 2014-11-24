//
//  ViewController.m
//  Address_Sample
//
//  Created by KentarOu on 2014/11/24.
//  Copyright (c) 2014年 KentarOu. All rights reserved.
//

#import "ViewController.h"
#import "PersonData.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()<ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    // Person Data Array
    NSMutableArray *persons;
    BOOL isEditing;
}

@property (strong, nonatomic) IBOutlet UITableView *addressTable;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    persons = [NSMutableArray array];
    isEditing = NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [_addressTable reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    PersonData *data = persons[indexPath.row];
    cell.textLabel.text = data.fullName;
    cell.imageView.image = data.image;
    
    return cell;
}

// 編集モード
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //削除時の操作 選択された行に対応するデータをpersonsから消去
        [persons removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (persons.count<1) {
            [_addressTable setEditing:NO animated:YES];
        }
    }
}

// テーブルビューの項目を選択したとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//Editボタンを押した時に編集モードのON, OFFを行う
- (IBAction)editAddress:(id)sender {
    if(isEditing){
        [_addressTable setEditing:NO animated:YES];
        isEditing = NO;
    }
    else{
        [_addressTable setEditing:YES animated:YES];
        isEditing = YES;
    }
}


// peoplePickerを開く
- (IBAction)openPeoplePicker:(id)sender
{
    if(isEditing){
        [_addressTable setEditing:NO animated:YES];
        isEditing = NO;
    }
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

// peoplePicker キャンセル押下
- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//peoplePickerで選択した時に呼ばれる(アドレス帳一覧から選択させたい時に使用する)
- (void) peoplePickerNavigationController:(ABPeoplePickerNavigationController*) peoplePicker didSelectPerson:(ABRecordRef)person
{
    
    PersonData *personData = [[PersonData alloc]init];
    [personData setPersonData:person];
    [persons addObject:personData];
}


/*
// アドレス帳の詳細画面を開き選択したItemを取得する(詳細から選択させたい時に使用する)
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    
     [self setPersonData:person];
    
    
    CFTypeRef multi = ABRecordCopyValue(person, property);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    
    //選択されたItemを取得
    NSString *selectItem = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, index);
    NSLog(@"select Item = %@",selectItem);
}
*/


@end
