//
//  collectionVC.m
//  YKWatchOSLayout
//
//  Created by doup0580 on 15/11/9.
//  Copyright © 2015年 doup0580. All rights reserved.
//

#import "collectionVC.h"
#import "UIImageView+WebCache.h"
@interface collectionVC ()
@property(nonatomic,strong)NSMutableArray *logos;

@end

@implementation collectionVC
static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}
-(void)awakeFromNib{
    self.logos=[NSMutableArray array];
    [self.logos addObject:@"http://pic.58pic.com/58pic/11/45/14/58PIC6q58PICxHG.jpg"];
    [self.logos addObject:@"http://pic003.cnblogs.com/2011/66372/201106/2011063010354822.jpg"];
    [self.logos addObject:@"http://a.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=0fc9b8c7261f95cab2f89ae4a87e145b/1c950a7b02087bf49212ea50f1d3572c10dfcf89.jpg"];
    [self.logos addObject:@"http://www.famouslogos.org/wp-content/uploads/2008/10/apple-rainbow-logo.jpg"];
    [self.logos addObject:@"http://news.cnr.cn/kjxw/sjcs/20150902/W020150902324331570922.jpg"];
    [self.logos addObject:@"http://img.sj33.cn/uploads/allimg/201401/7-14012523563R08.jpg"];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius=cell.bounds.size.width/2.0;
    cell.layer.masksToBounds=YES;
    UIImageView *imageV=(UIImageView *)[cell viewWithTag:101];
    NSString *str=[NSString stringWithString:self.logos[indexPath.row%6]];
    [imageV sd_setImageWithURL:[NSURL URLWithString:str]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{}

@end
