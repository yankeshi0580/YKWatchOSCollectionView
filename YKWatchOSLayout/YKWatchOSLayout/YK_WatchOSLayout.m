//
//  YK_WatchOSLayout.m
//  YKLayout
//
//  Created by doup0580 on 15/11/5.
//  Copyright © 2015年 doup0580. All rights reserved.
//


#import "YK_WatchOSLayout.h"
@interface YK_WatchOSLayout()
//也喜欢研究动画效果方面的朋友 加我q 1425121517

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

@property(nonatomic,strong)  NSIndexPath *lastIndexPath;

@property(nonatomic,assign)CGPoint lastPosition;

@property(nonatomic,assign)int circleRow;

//存储attributes
@property(nonatomic,strong)NSMutableArray *itemsAttributes;


@end
@implementation YK_WatchOSLayout{
}
-(NSIndexPath *)lastIndexPath{
    if (!_lastIndexPath) {
        _lastIndexPath=[NSIndexPath indexPathForItem:0 inSection:0 ];
    }
    return _lastIndexPath;
}
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

#define INCLOUD_ROW_ITEM 6
#define INCLOUD_LINE_ITEM 4

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
//布局内容
-(void)circleStartItemPosition:(CGPoint)position cirleEndRow:(int)row endItem:(int)item{
    self.InitalContentOffset=YES;
    NSIndexPath *indexPath;
    UICollectionViewLayoutAttributes *attributes;
    self.lastPosition=position;
     for (int i=0; i<=row; i++) {
        
        int cirleItem=4*i;
         if (i==0&&cirleItem==0){
            indexPath=[NSIndexPath indexPathForItem:i inSection:0];
            attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            [attributes setBounds:CGRectMake(0, 0, self.itemSize.width, self.itemSize.height)];
            [attributes setCenter:position];
            [self.itemsAttributes addObject:attributes];
            
            cirleItem=0;;
        }
        else if (i==row) {
            cirleItem=item+1;
        }
            for (int j=0; j<cirleItem; j++) {
            CGPoint processPoint=CGPointZero;
            if (j==0) {
                
                processPoint=CGPointMake((-self.itemWidthPading-self.itemSize.width)/2.0, -self.itemSize.height-self.itemHeightPading);
              }
            //           负向纵向的操作
            else if(j<i*1){
                
                processPoint=CGPointMake(0,2*(-self.itemHeightPading-self.itemSize.height));
               }
            //            正向横向的操作
            else if (j<i*2){
                processPoint=CGPointMake(self.itemWidthPading+self.itemSize.width,0);
                   }
            //            正向纵向的操作
            else if (j<i*3){
                
                processPoint=CGPointMake(0,1*2*(self.itemHeightPading+self.itemSize.height));
                
                
            }
            //            负向横向的操作
            else if (j<i*4){
                
                processPoint=CGPointMake(-self.itemWidthPading-self.itemSize.width,0);
                
            }
            //            添加attrubites
            self.lastPosition=CGPointMake(self.lastPosition.x+processPoint.x, self.lastPosition.y+processPoint.y);
            indexPath=[NSIndexPath indexPathForItem:[self findItemCircleRow:i item:j] inSection:0];
            attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            [attributes setBounds:CGRectMake(0, 0, self.itemSize.width, self.itemSize.height)];
            [attributes setCenter:self.lastPosition];
            [self.itemsAttributes addObject:attributes];
            
        }
    }
    
}
//进这个方法排除了第一圈的item
-(int)findItemCircleRow:(int)row item:(int)item{
    int itemsNumber=1;
    for (int index=0; index<row; index++) {
        itemsNumber+=4*index;
    }
    itemsNumber+=item;
    return itemsNumber;
    
}
//开始布局
-(void)startCountLayout{
    int item=(int)self.itemsCount-1;
    int row=0;
    while (1) {
        if (item>=4*row) {
            if (row==0) {
                item-=1;
            }
            else{
                item-=4*row;
            }
            row++;
           }
        else{
            break;
           }
    }
    self.circleRow=row;
    CGPoint startPosition=CGPointMake([self collectionViewContentWidth]/2, [self collectionViewContentHeight]/2);
    [self circleStartItemPosition:startPosition cirleEndRow:row endItem:item];
}

-(NSMutableArray *)itemsAttributes{
    if (!_itemsAttributes) {
        _itemsAttributes=[NSMutableArray arrayWithCapacity:self.itemsCount];
        if (self.itemsCount!=0) {
            [self startCountLayout];
        }
        
    }
    return _itemsAttributes;
    
}
//设定初始位置
-(void)setInitalContentOffset:(BOOL)InitalContentOffset{
    if (!_InitalContentOffset) {
         float time=(self.circleRow%2==0)?1:1/2;
        CGPoint initalPoint=  CGPointMake(([self collectionViewContentWidth]-self.collectionViewWidth)/2+self.circleRow*time*(self.itemSize.width+self.itemWidthPading),( [self collectionViewContentHeight]-self.collectionViewHeight)/2+(self.itemSize.height+self.itemHeightPading)*time*2*self.circleRow);
        [self.collectionView setContentOffset:initalPoint];
        
    }
    
    _InitalContentOffset=InitalContentOffset;
    
    
}
-(CGFloat )collectionViewContentWidth{
     return self.circleRow*(self.itemWidthPading+self.itemSize.width)+self.collectionViewWidth;
}
-(CGFloat )collectionViewContentHeight{
    return 2*self.circleRow*(self.itemHeightPading+self.itemSize.height)+self.collectionViewHeight;

    
}
-(CGSize)collectionViewContentSize{
       return CGSizeMake([self collectionViewContentWidth], [self collectionViewContentHeight]);
}
-(void)prepareLayout
{
    [super prepareLayout];
    self.itemSize=CGSizeMake(60, 60);
    
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
//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
//    CGFloat fixOffsetX=0;
//    CGFloat fixOffsetY=0;
//    CGFloat fixOffsetDistance=MAXFLOAT;
//
//    CGPoint visibleCenter = CGPointMake(proposedContentOffset.x + self.collectionViewWidth / 2.0, proposedContentOffset.y + self.collectionViewHeight / 2.0);
//    CGRect visibleRect=CGRectMake(proposedContentOffset.x , proposedContentOffset.y , self.collectionViewWidth , self.collectionViewHeight);
//    NSArray *visibleArray = [self getSuperElementsInRect:visibleRect];
//
//    for (UICollectionViewLayoutAttributes *attributes in visibleArray) {
//        CGFloat distanceX = attributes.center.x - visibleCenter.x  ;
//        CGFloat distanceY =  attributes.center.y - visibleCenter.y ;
//        CGFloat distanceCenter = sqrtf(powf(distanceX , 2) + powf(distanceY , 2));
//        if (distanceCenter < fixOffsetDistance) {
//            fixOffsetDistance=distanceCenter;
//            fixOffsetX = distanceX;
//            fixOffsetY = distanceY;
//        }
//
//         }
//
//    self.collectionView.decelerationRate=1;
//    return CGPointMake(proposedContentOffset.x+fixOffsetX, proposedContentOffset.y+fixOffsetY);
//}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemsAttributes[indexPath.row];
}

//-(UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition{
//    UICollectionViewLayoutInvalidationContext *context=[super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
//      return context;
//    
//    
//}


@end
