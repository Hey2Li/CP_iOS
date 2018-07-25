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
@property (nonatomic, strong) UIWebView *leftWebView;
@property (nonatomic, strong) UIWebView *rightWebView;

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
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = YES;
        self.scrollView = scrollView;
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
        lable.text = @"1111111";
        lable.textColor = [UIColor blueColor];
        [scrollView addSubview:lable];
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *wkController = [[WKUserContentController alloc] init];
        webConfig.userContentController = wkController;
        // 自适应屏幕宽度js
        NSString *jsStr = @"var meta = document.createEleme n=t('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkScript = [[WKUserScript alloc] initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        // 添加js调用
        [wkController addUserScript:wkScript];
        
//        WKWebView *leftWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 220 - 44) configuration:webConfig];
//        leftWebView.UIDelegate = self;
//        [scrollView addSubview:leftWebView];
//        [leftWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        
        UIWebView *rightWebView = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 220 - 44 - 48)];
        rightWebView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:rightWebView];
        
        UIWebView *leftWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 220 - 44 - 48)];
        rightWebView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:leftWebView];
        rightWebView.backgroundColor = [UIColor whiteColor];
        leftWebView.backgroundColor = [UIColor whiteColor];
        self.rightWebView = rightWebView;
        self.leftWebView = leftWebView;
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
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    WeakSelf
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        
    }];
    
}
- (void)setModel:(OneLessonModel *)model{
    _model = model;
    NSString *html = [NSString stringWithFormat:@"\
                      <html lang=\"en\">\
                      <head>\
                      <meta name=\"viewport\" content=\"user-scalable=no\">\
                      <meta charset=\"UTF-8\">\
                      </head>\
                      <header>\
                      <style>\
                      .hVocabularyTitle{\
                      color:#ccc;\
                      font-size:16px;\
                      font-weight: 550;\
                      }\
                      .hVocabularyContent{\
                      color: #ccc;\
                      font-size: 14px;\
                      }\
                      .indent{\
                      text-indent: 28px;\
                      }\
                      p{\
                      margin-top: 0;\
                      }\
                      .flexFixed{\
                      -webkit-flex: 0 0 42px;\
                      flex: 0 0 42px;\
                      }\
                      </style>\
                      </header>\
                      %@\
                      </div>\
                      </html>",model.handouts];
    NSString *htmls = [NSString stringWithFormat:@"\
                      <html lang=\"en\">\
                      <head>\
                      <meta name=\"viewport\" content=\"user-scalable=no\">\
                      <meta charset=\"UTF-8\">\
                      </head>\
                      <header>\
                      <style>\
                      .hVocabularyTitle{\
                      color:#ccc;\
                      font-size:16px;\
                      font-weight: 550;\
                      }\
                      .hVocabularyContent{\
                      color: #ccc;\
                      font-size: 14px;\
                      }\
                      .indent{\
                      text-indent: 28px;\
                      }\
                      p{\
                      margin-top: 0;\
                      }\
                      .flexFixed{\
                      -webkit-flex: 0 0 42px;\
                      flex: 0 0 42px;\
                      }\
                      </style>\
                      </header>\
                      %@\
                      </div>\
                      </html>",model.vocabulary];
    [self.rightWebView loadHTMLString:html baseURL:nil];
    [self.leftWebView loadHTMLString:htmls baseURL:nil];
}
- (void)setLocalVideoModel:(DownloadVideoModel *)localVideoModel{
    _localVideoModel = localVideoModel;
    NSString *html = [NSString stringWithFormat:@"\
                      <html lang=\"en\">\
                      <head>\
                      <meta name=\"viewport\" content=\"user-scalable=no\">\
                      <meta charset=\"UTF-8\">\
                      </head>\
                      <header>\
                      <style>\
                      .hVocabularyTitle{\
                      color:#ccc;\
                      font-size:16px;\
                      font-weight: 550;\
                      }\
                      .hVocabularyContent{\
                      color: #ccc;\
                      font-size: 14px;\
                      }\
                      .indent{\
                      text-indent: 28px;\
                      }\
                      p{\
                      margin-top: 0;\
                      }\
                      .flexFixed{\
                      -webkit-flex: 0 0 42px;\
                      flex: 0 0 42px;\
                      }\
                      </style>\
                      </header>\
                      %@\
                      </div>\
                      </html>",localVideoModel.testPaperHtml];
    NSString *htmls = [NSString stringWithFormat:@"\
                       <html lang=\"en\">\
                       <head>\
                       <meta name=\"viewport\" content=\"user-scalable=no\">\
                       <meta charset=\"UTF-8\">\
                       </head>\
                       <header>\
                       <style>\
                       .hVocabularyTitle{\
                       color:#ccc;\
                       font-size:16px;\
                       font-weight: 550;\
                       }\
                       .hVocabularyContent{\
                       color: #ccc;\
                       font-size: 14px;\
                       }\
                       .indent{\
                       text-indent: 28px;\
                       }\
                       p{\
                       margin-top: 0;\
                       }\
                       .flexFixed{\
                       -webkit-flex: 0 0 42px;\
                       flex: 0 0 42px;\
                       }\
                       </style>\
                       </header>\
                       %@\
                       </div>\
                       </html>",localVideoModel.wordHtml];
    [self.rightWebView loadHTMLString:html baseURL:nil];
    [self.leftWebView loadHTMLString:htmls baseURL:nil];
    self.rightWebView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 220 - 44);
    self.leftWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 220 - 44);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
