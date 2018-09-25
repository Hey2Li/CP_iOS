//
//  MyCollectionPaperTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyCollectionPaperTableViewCell.h"
#import "NSString+FileSize.h"
#import "LTDownloadView.h"


@interface MyCollectionPaperTableViewCell ()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) MyCollectionModel *collectionDownloadModel;
@property (nonatomic, copy) NSString *downloadVoiceUrl;
@property (nonatomic, copy) NSString *downloadlrcUrl;
@property (nonatomic, copy) NSString *downloadJsonUrl;
@property (nonatomic, strong) LTDownloadView *downloadView;
@property (nonatomic, copy) NSString *voiceSize;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) DownloadFileModel *downloadModel;

@end

@implementation MyCollectionPaperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(MyCollectionModel *)model{
    _model = model;
    self.downloadModel = [[DownloadFileModel alloc]init];
    self.collectionDownloadModel = model;
    _paperName.text = model.name;
    [_paperImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl]];
    _fileSizeLb.text = [NSString stringWithFormat:@"%@", model.size];
    self.voiceSize = [NSString stringWithFormat:@"%@", model.size];
    self.downloadModel.testPaperId = [NSString stringWithFormat:@"%ld", (long)model.ID];
    DownloadFileModel *Dmodel = [DownloadFileModel jr_findByPrimaryKey:self.downloadModel.testPaperId];
    if (Dmodel.paperVoiceName == nil || [Dmodel.paperVoiceName isEqualToString:@""]) {
        self.downloadModel.paperVoiceName = model.voiceUrl;
    }else{
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *urlString = [Dmodel.paperVoiceName stringByRemovingPercentEncoding];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fullPath]) {
            [self.dowloadBtn setImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
            self.dowloadBtn.enabled = NO;
        }
    }
    if (Dmodel.paperJsonName == nil || [Dmodel.paperJsonName isEqualToString:@""]){
        self.downloadModel.paperLrcName = model.lic;
        self.downloadModel.paperJsonName = model.testPaperUrl;
    }
    J_Insert(self.downloadModel).updateResult;
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%ld", (long)model.ID] forKey:@"testPaperId"];
}

- (void)setDownloadViewModel:(DownloadFileModel *)downloadViewModel{
    _downloadModel = downloadViewModel;
    _paperName.text = _downloadModel.name;
}
#pragma mark 下载
- (IBAction)downloadPaper:(UIButton *)sender {
    NSString *GPRSDownload = [USERDEFAULTS objectForKey:@"GPRSDownload"];
    if ([kNetworkState isEqualToString:@"GPRS"] && [GPRSDownload isEqualToString:@"0"]) {
        LTAlertView *alert = [[LTAlertView alloc]initWithTitle:@"移动网络确定下载吗" sureBtn:@"确定" cancleBtn:@"取消"];
        [alert show];
        alert.resultIndex = ^(NSInteger index) {
            
        };
    }
    self.downloadView = [[LTDownloadView alloc]initWithTitle:@"是否下载此资源" sureBtn:@"立即下载" fileSize:self.voiceSize];
    [self.downloadView show];
    __block MyCollectionPaperTableViewCell *blockSelf = self;
    self.downloadView.resultIndex = ^(NSInteger index) {
        if (index == 2000) {
            sender.enabled = NO;
            DownloadFileModel *dModel = [DownloadFileModel jr_findByPrimaryKey:[NSString stringWithFormat:@"%ld",blockSelf.collectionDownloadModel.ID]];
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *urlString = [dModel.paperVoiceName stringByRemovingPercentEncoding];
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:fullPath]) {
                [blockSelf.dowloadBtn setImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
                sender.enabled = NO;
                SVProgressShowStuteText(@"您已经下载过了", NO);
                [blockSelf.downloadView dismiss];
                [blockSelf.downloadTask cancel];;
                return;
            }else{
                NSString* encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [LTHttpManager downloadURL:blockSelf.downloadModel.paperJsonName progress:^(NSProgress *downloadProgress) {
                    
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    blockSelf.downloadModel.paperJsonName = fileName;
                    J_Update(blockSelf.downloadModel).Columns(@[@"paperJsonName"]).updateResult;
                } failure:^(NSError *error) {
                    
                }];
                [LTHttpManager downloadURL:blockSelf.downloadModel.paperLrcName progress:^(NSProgress *downloadProgress) {
                    
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    blockSelf.downloadModel.paperLrcName = fileName;
                    J_Update(blockSelf.downloadModel).Columns(@[@"paperLrcName"]).updateResult;
                } failure:^(NSError *error) {
                    
                }];
                blockSelf.downloadTask = [LTHttpManager downloadURL:encodedString progress:^(NSProgress *downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [blockSelf.downloadView.progressView setProgress:downloadProgress.fractionCompleted];
                        blockSelf.downloadView.progressLb.text = [NSString stringWithFormat:@"%.1f%%",downloadProgress.fractionCompleted * 100];
                    });
                    if (downloadProgress.completedUnitCount/downloadProgress.totalUnitCount == 1.0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [blockSelf.downloadView dismiss];
                            SVProgressShowStuteText(@"下载成功", YES);
                            [blockSelf.dowloadBtn setImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
                            sender.enabled = NO;
                        });
                    }
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    blockSelf.downloadModel.paperVoiceName = fileName;
                    J_Update(blockSelf.downloadModel).Columns(@[@"paperVoiceName"]).updateResult;
                    NSLog(@"%@",fileName);
                } failure:^(NSError *error) {
                    sender.enabled = YES;
                }];
            }
        }else{
            [blockSelf.downloadTask cancel];;
        }
    };
}
@end
