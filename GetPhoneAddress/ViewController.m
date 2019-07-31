//
//  ViewController.m
//  GetPhoneAddress
//
//  Created by Peyton on 2019/7/19.
//  Copyright © 2019 Peyton. All rights reserved.
//

#import "ViewController.h"
#import "NetworkTools.h"
#import "ResultVC.h"


#define Request_URL @"http://mobsec-dianhua.baidu.com/dianhua_api/open/location?tel="

@interface ViewController ()
//address
@property (nonatomic, strong)NSMutableArray *address;
//计数
@property (nonatomic, assign)int finishedCount;
//phoneNumbers
@property (nonatomic, strong)NSMutableArray *phoneNumbers;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//开始网络请求，查询号码归属地
- (IBAction)begin:(UIButton *)sender {

    self.totalLabel.text = [NSString stringWithFormat:@"总数：%lu", (self.textView.text.length + 1) / 12];
    if (self.phoneNumbers.count > 0) {
        [self.phoneNumbers removeAllObjects];
    }
    NSString *phoneString = self.textView.text;
    int i = 0;
    if (phoneString.length > 0) {
        do {
            NSRange range = NSMakeRange(i, 11);
            NSString *phoneNumber = [phoneString substringWithRange:range];
            [self.phoneNumbers addObject:phoneNumber];
            i += 12;
        } while (i < phoneString.length);
    }
    [self requestForLocationInfo];
}

//跳转到结果页
- (IBAction)showAddress:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ResultVC *vc= [sb instantiateViewControllerWithIdentifier:@"resultVC"];
    vc.address = self.address;
    [self presentViewController:vc animated:YES completion:nil];
}

//清空输入框等的数据
- (IBAction)clearPhoneNumbers:(UIButton *)sender {
    self.textView.text = @"";
    [self.phoneNumbers removeAllObjects];
    [self.address removeAllObjects];
    self.finishedCount = 0;
    self.totalLabel.text = @"总数：0";
    self.finishedLabel.text = [NSString stringWithFormat:@"已完成: %d", self.finishedCount];
}

//查询号码归属地的网络请求方法
- (void)requestForLocationInfo {
    self.finishedCount = 0;
    if (self.address.count > 0) {
        [self.address removeAllObjects];
    }
    _address = [NSMutableArray arrayWithArray:self.phoneNumbers];
    [self.phoneNumbers enumerateObjectsUsingBlock:^(NSString*  _Nonnull phoneNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", Request_URL, phoneNumber];
        [NetworkTools getDataWithURLString:urlString parameters:nil success:^(NSDictionary *dic) {
            NSDictionary *response = [dic objectForKey:@"response"];
            NSDictionary *phoneNumberDic = [response objectForKey:phoneNumber];
            NSDictionary *detailDic = [phoneNumberDic objectForKey:@"detail"];
            //省份
            NSString *province = [detailDic objectForKey:@"province"];
            //城市
            NSArray *areaArray = [detailDic objectForKey:@"area"];
            NSDictionary *cityDic = areaArray[0];
            NSString *cityString = [cityDic valueForKey:@"city"];
            NSString *addressInfo = [NSString stringWithFormat:@"%@ %@", province, cityString];
            [self.address replaceObjectAtIndex:idx withObject:addressInfo];
            self.finishedCount ++;
            self.finishedLabel.text = [NSString stringWithFormat:@"已完成: %d", self.finishedCount];
        } failed:^(NSError *error) {
    
        }];
    }];
}

#pragma mark lazy
- (NSMutableArray *)phoneNumbers {
    if (!_phoneNumbers) {
        _phoneNumbers = [NSMutableArray array];
    }
    return _phoneNumbers;
}
@end
