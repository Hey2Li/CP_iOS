//
//  MyCollectionPaperTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyCollectionPaperTableViewCell.h"
#import "NSString+FileSize.h"

@interface MyCollectionPaperTableViewCell ()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) DownloadFileModel *collectionDownloadModel;
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
    _paperName.text = model.name;
    DownloadFileModel *downloadModel = [DownloadFileModel jr_findByPrimaryKey:[NSString stringWithFormat:@"%ld",(long)_model.testPaperId]];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *urlString = [downloadModel.paperVoiceName stringByRemovingPercentEncoding];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        _dowloadBtn.enabled = NO;
        [_dowloadBtn setImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
        _fileSizeLb.text = fullPath.fileSize;
    }else{
        _fileSizeLb.text = @"0.0M";
    }
}
- (void)setDownloadModel:(DownloadFileModel *)downloadModel{
    _downloadModel = downloadModel;
    _paperName.text = downloadModel.name;
}
#pragma mark 下载
- (IBAction)downloadPaper:(UIButton *)sender {
    sender.enabled = NO;
    //下载试卷音频JSON lrc 并且存到数据库
    self.collectionDownloadModel = [DownloadFileModel jr_findByPrimaryKey:[NSString stringWithFormat:@"%ld",(long)_model.testPaperId]];
    if (self.collectionDownloadModel == nil) {
        self.collectionDownloadModel = [[DownloadFileModel alloc]init];
        self.collectionDownloadModel.testPaperId = [NSString stringWithFormat:@"%ld",(long)_model.testPaperId];
        self.collectionDownloadModel.name = _model.name;
        self.collectionDownloadModel.info = _model.info;
        self.collectionDownloadModel.number = _model.number;
    }
    NSLog(@"Model:%@",self.collectionDownloadModel);
    SVProgressShowText(@"请稍后...");
    //下载音频
    [LTHttpManager downloadURL:_model.voiceUrl progress:^(NSProgress *downloadProgress) {
        [SVProgressHUD showProgress:downloadProgress.fractionCompleted];
        if (downloadProgress.completedUnitCount/downloadProgress.totalUnitCount == 1.0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                SVProgressShowStuteText(@"下载成功", YES);
                [sender setImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
                sender.enabled = NO;
            });
        }
    } destination:^(NSURL *targetPath) {
        NSString *url = [NSString stringWithFormat:@"%@",targetPath];
        NSString *fileName = [url lastPathComponent];
        _fileSizeLb.text = url.fileSize;
        if (self.reloadData) {
            self.reloadData();
        };
        self.collectionDownloadModel.paperVoiceName = fileName;
        NSLog(@"%@",self.collectionDownloadModel.paperVoiceName);
        NSLog(@"paperVoiceName");
        if (J_Update(self.collectionDownloadModel).Columns(@[@"paperVoiceName"]).updateResult) {
            SVProgressShowStuteText(@"下载成功", YES);
        }
    } failure:^(NSError *error) {
        SVProgressShowStuteText(@"下载失败请重新下载", NO);
        sender.enabled = YES;
    }];
    //下载试卷JSON
    [LTHttpManager downloadURL:_model.testPaperUrl progress:^(NSProgress *downloadProgress) {
        
    } destination:^(NSURL *targetPath) {
        NSString *url = [NSString stringWithFormat:@"%@",targetPath];
        NSString *fileName = [url lastPathComponent];
        self.collectionDownloadModel.paperJsonName = fileName;
        J_Update(self.collectionDownloadModel).Columns(@[@"paperJsonName"]).updateResult;
        NSLog(@"jsonName");
    } failure:^(NSError *error) {
        
    }];
    //下载lrc
    [LTHttpManager downloadURL:_model.lic progress:^(NSProgress *downloadProgress) {
        
    } destination:^(NSURL *targetPath) {
        NSString *url = [NSString stringWithFormat:@"%@",targetPath];
        NSString *fileName = [url lastPathComponent];
        self.collectionDownloadModel.paperLrcName = fileName;
        J_Update(self.collectionDownloadModel).Columns(@[@"paperLrcName"]).updateResult;
        NSLog(@"paperLrcName");
    } failure:^(NSError *error) {
        
    }];
    BOOL result = J_Insert(self.collectionDownloadModel).updateResult;
    if (!result) {
        SVProgressShowStuteText(@"下载失败", NO);
    }
}
@end
