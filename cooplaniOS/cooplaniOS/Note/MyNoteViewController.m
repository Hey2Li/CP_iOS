//
//  MyNoteViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyNoteViewController.h"
#import "SentenceTableViewCell.h"

@interface MyNoteViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置
@end

@implementation MyNoteViewController
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SentenceTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SentenceTableViewCell class])];
        _myTableView.rowHeight = 190;
        _myTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    }
    return _myTableView;
}
#pragma mark UITableViewDegate&DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SentenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SentenceTableViewCell class])];
    cell.selectionStyle = NO;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 从数据源中删除
//    [_data removeObjectAtIndex:indexPath.row];
    // 从列表中删除
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的笔记";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
}
//- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//
//    if (self.editingIndexPath)
//    {
//        [self configSwipeButtons];
//    }
//}
//- (void)configSwipeButtons
//{
//    // 获取选项按钮的reference
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
//    {
//        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
//        for (UIView *subview in self.myTableView.subviews)
//        {
//            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 2)
//            {
//                // 和iOS 10的按钮顺序相反
//                UIButton *deleteButton = subsubview.subviews[1];
//                UIButton *readButton = subsubview.subviews[0];
//
//                [self configDeleteButton:deleteButton];
//                [self configReadButton:readButton];
//            }
//        }
//    }
//    else
//    {
//        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
//        SentenceTableViewCell *tableCell = [self.myTableView cellForRowAtIndexPath:self.editingIndexPath];
//        for (UIView *subview in tableCell.subviews)
//        {
//            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 2)
//            {
//                UIButton *deleteButton = subview.subviews[0];
//                UIButton *readButton = subview.subviews[1];
//
//                [self configDeleteButton:deleteButton];
//                [self configReadButton:readButton];
//                [subview setBackgroundColor:[UIColor redColor]];
//            }
//        }
//    }
//
//    [self configDeleteButton:deleteButton];
//    [self configReadButton:readButton];
//}
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.editingIndexPath = indexPath;
//    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
//}
//
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.editingIndexPath = nil;
//}
//- (void)configDeleteButton:(UIButton*)deleteButton
//{
//    if (deleteButton)
//    {
//        [deleteButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:12.0]];
//        [deleteButton setTitleColor:[[ColorUtil instance] colorWithHexString:@"D0021B"] forState:UIControlStateNormal];
//        [deleteButton setImage:[UIImage imageNamed:@"Delete_icon_.png"] forState:UIControlStateNormal];
//        [deleteButton setBackgroundColor:[[ColorUtil instance] colorWithHexString:@"E5E8E8"]];
//        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
//        [self centerImageAndTextOnButton:deleteButton];
//    }
//}
//
//- (void)configReadButton:(UIButton*)readButton
//{
//    if (readButton)
//    {
//        [readButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:12.0]];
//        [readButton setTitleColor:[[ColorUtil instance] colorWithHexString:@"4A90E2"] forState:UIControlStateNormal];
//        // 根据当前状态选择不同图片
//        BOOL isRead = [[NotificationManager instance] read:self.editingIndexPath.row];
//        UIImage *readButtonImage = [UIImage imageNamed: isRead ? @"Mark_as_unread_icon_.png" : @"Mark_as_read_icon_.png"];
//        [readButton setImage:readButtonImage forState:UIControlStateNormal];
//
//        [readButton setBackgroundColor:[[ColorUtil instance] colorWithHexString:@"E5E8E8"]];
//        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
//        [self centerImageAndTextOnButton:readButton];
//    }
//}
//- (void)centerImageAndTextOnButton:(UIButton*)button
//{
//    // this is to center the image and text on button.
//    // the space between the image and text
//    CGFloat spacing = 35.0;
//
//    // lower the text and push it left so it appears centered below the image
//    CGSize imageSize = button.imageView.image.size;
//    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
//
//    // raise the image and push it right so it appears centered above the text
//    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
//    button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
//
//    // increase the content height to avoid clipping
//    CGFloat edgeOffset = (titleSize.height - imageSize.height) / 2.0;
//    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
//
//    // move whole button down, apple placed the button too high in iOS 10
//    if (SYSTEM_VERSION_LESS_THAN(@"11.0"))
//    {
//        CGRect btnFrame = button.frame;
//        btnFrame.origin.y = 18;
//        button.frame = btnFrame;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
