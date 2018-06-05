//
//  DictionaryViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DictionaryViewController.h"
#import "DictionaryTableViewCell.h"

@interface DictionaryViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *wordArray;
@property (nonatomic, strong) NSDictionary *dictWord;
@end

@implementation DictionaryViewController
- (NSMutableArray *)wordArray{
    if (!_wordArray) {
        _wordArray = [NSMutableArray array];
    }
    return _wordArray;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DictionaryTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DictionaryTableViewCell class])];
        _myTableView.estimatedRowHeight = 70.0f;
        _myTableView.rowHeight = UITableViewAutomaticDimension;
        _myTableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"词典";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myTableView];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    searchBar.placeholder = @"请输入查询的单词";
    searchBar.text = self.word;
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    //输入框背景颜色
    searchTextField.backgroundColor = UIColorFromRGB(0xeeeeee);
    searchBar.barTintColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:searchBar];
    searchBar.layer.borderWidth = 0;
    searchBar.delegate = self;
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    for (UIView *subview in [[searchBar.subviews firstObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
    }
}
- (void)setWord:(NSString *)word{
    _word = word;
    [LTHttpManager searchWordWithWord:word Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.dictWord = data[@"responseData"];
            [self.myTableView reloadData];
        }else{
            //
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DictionaryTableViewCell class])];
    cell.selectionStyle = NO;
    if ([self.dictWord allKeys].count) {
        cell.model = self.dictWord;
    }
    return cell;
}


#pragma mark - UISearchBarDelegate 协议
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [LTHttpManager searchWordWithWord:searchBar.text Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.dictWord = data[@"responseData"];
            [self.myTableView reloadData];
        }else{
            
        }
    }];
}

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
