//
//  YK_WatchOSLayout.m
//  YKLayout
//
//  Created by doup0580 on 15/11/5.
//  Copyright © 2015年 doup0580. All rights reserved.
//

#import "YK_WatchOSLayout.h"

//也喜欢研究动画效果方面的朋友 加我q 1425121517
@interface YK_WatchOSLayout()
//宽距
@property(nonatomic,assign)CGFloat itemWidthPading;
//高距
@property(nonatomic,assign)CGFloat itemHeightPading;
@property(nonatomic,assign)NSUInteger itemsCount;
@property(nonatomic,assign)CGFloat collectionViewWidth;
@property(nonatomic,assign)CGFloat collectionViewHeight;

@property(nonatomic,assign)CGSize itemSize;
//设置初始位置
@property(nonatomic,assign)BOOL InitalContentOffset;


//存储attributes
@property(nonatomic,strong)NSMutableArray *itemsAttributes;


@end
@implementation YK_WatchOSLayout

-(NSUInteger)itemsCount{
    if (!_itemsCount) {
        _itemsCount=[self.collectionView numberOfItemsInSection:0];
    }
    return _itemsCount;
}
-(CGFloat)collectionViewWidth{
    if (!_collectionViewWidth) {
        _collectionViewWidth=self.collectionView.bounds.size.width;
    }
    return _collectionViewWidth;
}
-(CGFloat)collectionViewHeight{
    if (!_collectionViewHeight) {
        _collectionViewHeight=self.collectionView.bounds.size.height;
    }
    return _collectionViewHeight;
}
// 限制显示行数和列数

#define INCLOUD_ROW_ITEM 8
#define INCLOUD_LINE_ITEM 3

-(CGFloat)itemWidthPading{
    if (!_itemWidthPading) {
        _itemWidthPading=(self.collectionViewWidth-self.itemSize.width*INCLOUD_LINE_ITEM)/(INCLOUD_LINE_ITEM-1);
    }

    return _itemWidthPading;
}
-(CGFloat)itemHeightPading{
    if (!_itemHeightPading) {
        _itemHeightPading=(self.collectionViewHeight-self.itemSize.height*INCLOUD_ROW_ITEM)/(INCLOUD_ROW_ITEM-1);
    }
    return _itemHeightPading;
    
}
#define MAX_ROW_NUMBER 15
#define MAX_LINE_NUMBER 10
//布局位置 限制行数和列数
-(NSMutableArray *)itemsAttributes{
    if (!_itemsAttributes) {
        _itemsAttributes=[NSMutableArray arrayWithCapacity:self.itemsCount];
        
        NSUInteger row=self.itemsCount/MAX_LINE_NUMBER;
                   for (int i=0; i<=row; i++) {
            NSUInteger line=MAX_LINE_NUMBER;

            if (i==row) {
                line=self.itemsCount%MAX_LINE_NUMBER;
                         }
            for (int j=0; j<line; j++) {
     //设置初始位置 让每个点都能到达屏幕中点
        
               CGPoint originalPoint=CGPointMake(self.collectionViewWidth/2.0, self.collectionViewHeight/2.0);
             originalPoint.x+=(i%2==0)? 0:(self.itemSize.width+self.itemWidthPading)/2;

                CGPoint itemCenter=CGPointMake(originalPoint.x+j*(self.itemSize.width+self.itemWidthPading),originalPoint.y+i*(self.itemSize.height+self.itemHeightPading));
                NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i*MAX_LINE_NUMBER+j inSection:0];
                UICollectionViewLayoutAttributes *att=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                 [att setBounds:CGRectMake(0, 0, self.itemSize.width, self.itemSize.height)];
                [att setCenter:itemCenter];
                [self.itemsAttributes addObject:att];

            }
        }
        
    }
    return _itemsAttributes;
    
}
//设定初始位置
-(void)setInitalContentOffset:(BOOL)InitalContentOffset{
    if (!_InitalContentOffset) {
        [self.collectionView setContentOffset:CGPointMake((self.collectionViewWidth-self.itemSize.width)/2, (self.collectionViewHeight-self.itemSize.height)/2)];
    }
    
    _InitalContentOffset=InitalContentOffset;
    

}
-(CGFloat )collectionViewContentWidth{
    CGFloat width;
    UICollectionViewLayoutAttributes *att=[self.itemsAttributes lastObject];

    if (self. itemsCount<MAX_LINE_NUMBER) {
        width=att.center.x+self.collectionViewWidth/2.0;
    }
    else if (self.itemsCount<MAX_LINE_NUMBER*2){
        width=self.collectionViewWidth+(MAX_LINE_NUMBER-1)*(self.itemSize.width+self.itemWidthPading);
    }
    else{
        width=self.collectionViewWidth+(MAX_LINE_NUMBER-1)*(self.itemSize.width+self.itemWidthPading)+(self.itemSize.width+self.itemWidthPading)/2;;
    }
    return width;

}
-(CGFloat )collectionViewContentHeight{
    CGFloat height;
    UICollectionViewLayoutAttributes *att=[self.itemsAttributes lastObject];
    
     height=att.center.y+self.collectionViewHeight/2.0;
      return height;
    
}
-(CGSize)collectionViewContentSize{

    return CGSizeMake([self collectionViewContentWidth], [self collectionViewContentHeight]);
}
-(void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize=CGSizeMake(60, 60);
    self.InitalContentOffset=YES;
    
}
//缩放大小 和 离中心距离的 1/4 椭圆 函数
-(CGFloat)distanceFlactor:(CGFloat)distanceX isHorizontal:(BOOL)horizontal{
    CGFloat raduis =(horizontal)?self.collectionViewWidth/2:self.itemSize.height*3/2.0+self.itemHeightPading;
    CGFloat raduisSquare=ceilf( powf(raduis, 2));
    CGFloat distanceXSquare=ceilf( powf(distanceX, 2));
    CGFloat decideResult=(distanceXSquare/raduisSquare);
    CGFloat flactor=sqrtl(1-MIN(decideResult, 1));

    return flactor;
   }

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *resultArray=[NSMutableArray array];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;

    for (UICollectionViewLayoutAttributes *attributes in self.itemsAttributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distanceX=CGRectGetMidX(visibleRect)-attributes.center.x;
            CGFloat distanceY=CGRectGetMidY(visibleRect)-attributes.center.y;
            CGFloat distanceXFlactor=[self distanceFlactor:ABS(distanceX) isHorizontal:YES];
            CGFloat limitHeight=(self.collectionViewHeight/2.0-self.itemSize.height*3/2.0-self.itemHeightPading);
            CGAffineTransform scale;
            if (ABS(distanceY)>limitHeight) {
                 CGFloat distanceYFlactor=[self distanceFlactor:ABS(distanceY)-limitHeight isHorizontal:NO];

                scale=CGAffineTransformMakeScale(distanceYFlactor*distanceXFlactor, distanceYFlactor*distanceXFlactor);
            }
            else{
                scale=CGAffineTransformMakeScale(distanceXFlactor  ,distanceXFlactor ) ;
          }
      
            [attributes setTransform:scale];
            [resultArray addObject:attributes];
        }
    }
    return resultArray;
}
-(NSArray *)getSuperElementsInRect:(CGRect)rect{
    NSMutableArray *resultArray=[NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.itemsAttributes) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [resultArray addObject:attributes];
        }
    }
    return resultArray;
}
//修正位置
/*
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGFloat fixOffsetX=0;
    CGFloat fixOffsetY=0;
    CGFloat fixOffsetDistance=MAXFLOAT;

    CGPoint visibleCenter = CGPointMake(proposedContentOffset.x + self.collectionViewWidth / 2.0, proposedContentOffset.y + self.collectionViewHeight / 2.0);
    CGRect visibleRect=CGRectMake(proposedContentOffset.x , proposedContentOffset.y , self.collectionViewWidth , self.collectionViewHeight);
    NSArray *visibleArray = [self getSuperElementsInRect:visibleRect];

    for (UICollectionViewLayoutAttributes *attributes in visibleArray) {
        CGFloat distanceX = attributes.center.x - visibleCenter.x  ;
        CGFloat distanceY =  attributes.center.y - visibleCenter.y ;
        CGFloat distanceCenter = sqrtf(powf(distanceX , 2) + powf(distanceY , 2));
        if (distanceCenter < fixOffsetDistance) {
            fixOffsetDistance=distanceCenter;
            fixOffsetX = distanceX;
            fixOffsetY = distanceY;
        }
        
         }
    
    self.collectionView.decelerationRate=1;
    return CGPointMake(proposedContentOffset.x+fixOffsetX, proposedContentOffset.y+fixOffsetY);
}*/
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemsAttributes[indexPath.row];
}
//-(UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition{
//
//}
//-(UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled{
//
//
//}


@end
