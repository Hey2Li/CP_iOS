//
//  ReadSBQuestionCardCCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSBQuestionCardCCell.h"
#import "SAQuestionCollectionViewCell.h"
#import "ReadSBOptionsCCell.h"

@interface ReadSBQuestionCardCCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ReadSBQuestionCardCCell
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAQuestionCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class])];
        [_collectionView registerClass:[ReadSBOptionsCCell class] forCellWithReuseIdentifier:NSStringFromClass([ReadSBOptionsCCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadSBOptionsCCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ReadSBOptionsCCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        [self.collectionView.layer setCornerRadius:12];
        [self.collectionView.layer setShadowOpacity:0.2];
        [self.collectionView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.collectionView.layer setShadowOffset:CGSizeMake(2, 2)];
        [self.collectionView.layer setMasksToBounds:NO];
    }
    return self;
}
#pragma mark UICollectionDelagete&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 4) {
        return self.questionsArray.count;
    }else{
        return 1;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(self.collectionView.width - 20, 35);
    }else if (indexPath.section == 1){
        return CGSizeMake(self.collectionView.width - 20, 25);
    }else if (indexPath.section == 2){
        return CGSizeMake(self.collectionView.width - 20, 1);
    }else if (indexPath.section == 3){
        return CGSizeMake(self.collectionView.width - 20, 95);
    }else{
        return CGSizeMake(40, 40);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 4) {
        return UIEdgeInsetsMake(10, 30, 10, 30);
    }else{
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 4) {
        return 20;
    }else{
        return 10;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        [cell.layer setCornerRadius:12.0f];
        [cell.layer setMasksToBounds:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"上下拉动"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        [cell addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(30);
            make.right.equalTo(cell.mas_right).offset(-30);
            make.height.equalTo(@35);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        return cell;
    }else if (indexPath.section == 1){
        SAQuestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class]) forIndexPath:indexPath];
        cell.questionLb.text = [NSString stringWithFormat:@"%@", self.optionsModel.No];
        cell.questionLb.font = [UIFont boldSystemFontOfSize:14];
        return cell;
    }else if (indexPath.section == 2){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 3){
        SAQuestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class]) forIndexPath:indexPath];
        cell.questionLb.numberOfLines = 0;
        cell.questionLb.font = [UIFont systemFontOfSize:14];
        cell.questionLb.text = [NSString stringWithFormat:@"%@", self.optionsModel.Text];
        return cell;
    }else{
        ReadSBOptionsCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ReadSBOptionsCCell class]) forIndexPath:indexPath];
        ReadSBPassageModel *model = self.questionsArray[indexPath.row];
        if ([self.optionsModel.yourAnswer isEqualToString:model.Alphabet]) {
            [cell setBackgroundColor:DRGBCOLOR];
        }else{
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        cell.optionLb.text = [NSString stringWithFormat:@"%@", model.Alphabet];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        //设置(Highlight)高亮下的颜色
        [cell setBackgroundColor:DRGBCOLOR];
        if (self.collectionScroll) {
            self.collectionScroll(self.superIndexPath);
            ReadSBPassageModel *model = self.questionsArray[indexPath.row];
            if ([self.optionsModel.Answer isEqualToString:model.Alphabet]) {
                self.optionsModel.isCorrect = YES;
            }else{
                self.optionsModel.isCorrect = NO;
            }
            self.optionsModel.yourAnswer = model.Alphabet;
            NSLog(@"%@", self.optionsModel.yourAnswer);
            [collectionView reloadData];
        }
    }
}
//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 4) {
        return NO;
    }else{
        return YES;
    }
}

- (void)setOptionsModel:(ReadSBOptionsModel *)optionsModel{
    _optionsModel = optionsModel;
    [self.collectionView reloadData];
}
@end
