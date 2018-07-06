//
//  WordWebViewTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordWebViewTableViewCell.h"
#import <WebKit/WebKit.h>

@interface WordWebViewTableViewCell ()<WKUIDelegate, UIScrollViewDelegate>
@end

@implementation WordWebViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, 0)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor redColor];
        scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView = scrollView;
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
        lable.text = @"1111111";
        lable.textColor = [UIColor blueColor];
        [scrollView addSubview:lable];
        
        WKWebView *leftWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [scrollView addSubview:leftWebView];
        
        WKWebView *rightWebView = [[WKWebView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [scrollView addSubview:rightWebView];
        leftWebView.UIDelegate = self;
        rightWebView.UIDelegate = self;
        [leftWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        NSString *body = @"<p class='hVocabularyTitle'><span>刷题课8</span></p ><p class='hVocabularyContent'><span>题型：听力篇章</span></p ><p class='hVocabularyContent'>专题：健康</p ><p class='hVocabularyContent'>真题出处：2017.12.01.22-25</p ><br><p class='hVocabularyContent'><span>词汇（229w）：</span></p ><p class='hVocabularyContent'><span style='color:rgb(77,172,125)'>基础词汇</span><span style='color:transparent;'>11</span><span style='color:#ccc;'>基础词汇  12</span></p ><p class='hVocabularyContent'><span style='color:rgb(255,206,67)'>重点词汇</span><span style='color:transparent;'>11</span><span style='color:#ccc;'>重点词汇  04</span></p ><p class='hVocabularyContent'><span style='color:rgb(215,111,103)'>核心词汇</span><span style='color:transparent;'>11</span><span style='color:#ccc;'>核心词汇  32</span></p ><p class='hVocabularyContent'><span style='color:rgb(104,143,210)'>难点词汇</span><span style='color:transparent;'>11</span><span style='color:#ccc;'>难点词汇  03</span></p ><br><p class='hVocabularyContent'>解题方法：视听一致</p ><br><p class='hVocabularyContent'></p ><p class='hVocabularyContent'>22. What does the speaker advise you to do first if you are lost in the woods?</p ><p class='hVocabularyContent'><span style='color:transparent;'>11</span><span>A) Use a map to identify your location.</span></p ><p class='hVocabularyContent'><span style='color:transparent;'>11</span><span>B) Call your family or friends for help.</span></p ><p class='hVocabularyContent'><span style='color:transparent;'>11</span><span>C) Sit down and try to calm yourself.</span></p ><p class='hVocabularyContent'><span style='color:transparent;'>11</span><span>D) Try to follow your footprints back.</span></p ><p class='hVocabularyContent'>23. What will happen if you follow an unknown stream in the woods?</p ><p class='hVocabularyContent'><span style='color:transparent;'>11</span><span>A) You may find a way out without your knowing it.</span></p ><p class='hVocabularyContent'><span style='color:transparent;'>11</span><span>B) You may expose yourself to unexpected dangers.</span></p ><p class='hVocabularyContent'><span style='color:";
        NSString *html = [NSString stringWithFormat:@"\
                          <html lang=\"en\">\
                          <head>\
                          <meta name=\"viewport\" content=\"user-scalable=no\">\
                          <meta charset=\"UTF-8\">\
                          </head>\
                          <body id=\"mainBody\">\
                          <header>\
                          <div>%@</div>\
                          </div>\
                          </header>\
                          </body>\
                          </html>",body];
        [rightWebView loadHTMLString:html baseURL:nil];
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrollView]) {
        if (self.scrollSize) {
            CGFloat offsetX = self.scrollView.contentOffset.x;
            self.scrollSize(offsetX);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
