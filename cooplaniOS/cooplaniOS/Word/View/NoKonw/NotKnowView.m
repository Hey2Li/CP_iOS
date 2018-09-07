//
//  NotKnowView.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "NotKnowView.h"
#import "NoKnowFirstPageCell.h"
#import "NoKnowSecondPageCell.h"

@interface NotKnowView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@implementation NotKnowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NotKnowView class]) owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.backgroundImg.userInteractionEnabled = YES;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.exampleCollection.collectionViewLayout = flowLayout;
        self.exampleCollection.delegate = self;
        self.exampleCollection.dataSource = self;
        self.exampleCollection.pagingEnabled = YES;
        self.exampleCollection.showsHorizontalScrollIndicator = NO;
        [self.exampleCollection registerNib:[UINib nibWithNibName:NSStringFromClass([NoKnowFirstPageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([NoKnowFirstPageCell class])];
        [self.exampleCollection registerNib:[UINib nibWithNibName:NSStringFromClass([NoKnowSecondPageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([NoKnowSecondPageCell class])];

    }
    return self;
}
- (void)setModel:(ReciteWordModel *)model{
    _model = model;
    [self.exampleCollection reloadData];
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(SCREEN_WIDTH, 250);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoKnowFirstPageCell *cell  =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NoKnowFirstPageCell class]) forIndexPath:indexPath];
        cell.wordExLb.text = [NSString stringWithFormat:@"%@",self.model.ex];
        cell.wordCountLb.text = [NSString stringWithFormat:@"[出现%ld次]",self.model.count];
        cell.enAndZhExLb.text = [NSString stringWithFormat:@"%@\n%@", self.model.eg_en, self.model.eg_cn];
        return cell;
    }else{
        NoKnowSecondPageCell *cell  =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NoKnowSecondPageCell class]) forIndexPath:indexPath];
        cell.helpMemoryLb.text = [NSString stringWithFormat:@"%@",self.model.mnemonic];
        cell.tipsLb.text = [NSString stringWithFormat:@"%@", self.model.mnemonic];
        return cell;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.exampleCollection) {
        self.examplePageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    }
}
@end
