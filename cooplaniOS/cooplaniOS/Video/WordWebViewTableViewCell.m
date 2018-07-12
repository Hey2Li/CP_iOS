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
        
        WKWebView *leftWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 220 - 44) configuration:webConfig];
        leftWebView.UIDelegate = self;
        [scrollView addSubview:leftWebView];
        [leftWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        
        UIWebView *rightWebView = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 220 - 44)];
        rightWebView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:rightWebView];
        NSString *body = @"<p class='hVocabularyTitle'><span>信息匹配</span></p><p class='hVocabularyContent'><span>本课知识框架</span></p><p class='hVocabularyContent indent'>信息匹配就是将原文交错的信息与选项一一匹配，这个过程中最重要的就是记笔记。为了防止遗忘原文细节，一定要记得在选项旁边记下与该选项关键词相匹配的信息，以方便选出正确答案。下面是用来联系巩固信息匹配题做法的四级真题。</p><p class='hVocabularyContent'><span>本课例题+译文</span><br></p><p class='hVocabularyContent'>（2017年12月）</p><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>原文：</p></div><div style='flex: 1'><p>1.raised more than $500 for her little brother who needs heart surgery in Houston</p><p>为她需要在德克萨斯州休斯顿接受心脏手术的弟弟筹集了500多美元</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>&nbsp;&nbsp;&nbsp;</p></div><div style='flex: 1'><p>2.grandmother Kim Allred said Addison probably overheard the conversation</p><p>祖母Kim Allred说，Addison可能无意中听到了谈话</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>&nbsp;&nbsp;&nbsp;</p></div><div style='flex: 1'><p>3.'I guess she overheard her grandfather and me talking about how we're worried about how we're going to get to Houston, for my grandson's heart surgery,' said Allred.</p><p>Allred说:“当时她爷爷和我正在犯愁要怎么去休斯顿为我孙子做心脏手术，我想她听到了我们的对话。”</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>选项：</p></div><div style='flex: 1'><p>Question: Who did Addison raise money for?    Addison为谁筹钱？</p><p>A) Her grandfather.         她祖父</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>&nbsp;&nbsp;&nbsp;</p></div><div style='flex: 1'><p>B) Her grandmother.         她祖母</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>&nbsp;&nbsp;&nbsp;</p></div><div style='flex: 1'><p>C) Her friend Erika.         她的朋友Erika</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>&nbsp;&nbsp;&nbsp;</p></div><div style='flex: 1'><p>D) Her little brother.        她的弟弟</p></div></div><p class='hVocabularyContent'>（2016年6月）</p><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>原文：</p></div><div style='flex: 1'><p>M: And you know, one thing that i want to ask you. It's great that you have had this experience of teaching in Indoesia and following up on what you just mentioned, what would you recommend for students who do not live in an English-speaking country?</p><p>你知道，我想问你一件事，就是你刚才所说的你在印尼的教学经历非常愉快。对于不在英语国家生活的学生，你有什么建议？</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>&nbsp;&nbsp;&nbsp;</p></div><div style='flex: 1'><p>Woman: Yeah, it is really hard. That is the real struggle because right now I do live in Holland but I really don't socialize with those people.</p><p>是的，真的很难。这是真正的斗争，因为现在我确实住在荷兰，但我真的不和那些人交往。</p></div></div><div class='hVocabularyContent' style='display:-webkit-flex;display: flex; '><div class='flexFixed'><p>选项：</p></div><div style='flex: 1'><p>Where does the woman live right now?        女人现在住在哪里？</p><p>A) Holland        荷兰</p><p>B) Indonesia        印度尼西亚</p><p>C) England        英格兰</p><p>D) Sweden        瑞典</p></div>";
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
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    WeakSelf
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
