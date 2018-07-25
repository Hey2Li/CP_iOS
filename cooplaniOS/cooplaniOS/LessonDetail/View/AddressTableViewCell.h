//
//  AddressTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TFClick)(NSString *text);
typedef void(^changeAddressClick)(UILabel *lb);
@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *addresseeTF;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *changeAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *changeAddressLb;
@property (nonatomic, copy) TFClick addresseeClick;
@property (nonatomic, copy) TFClick telephoneClick;
@property (nonatomic, copy) TFClick addressClick;
@property (nonatomic, copy) changeAddressClick changeAddressClick;
@end
