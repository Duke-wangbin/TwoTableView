//
//  ViewController.m
//  TwotableViewDemo
//
//  Created by enway_liang on 16/8/4.
//  Copyright © 2016年 wangbin. All rights reserved.
//
#define SCREENWIDTH                         [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT                        [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
}
@property (nonatomic,strong) NSMutableArray *leftArray;
@property (nonatomic,strong) NSMutableArray *rightArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"仿饿了么选餐";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREENWIDTH/4, SCREENHEIGHT-64) style:(UITableViewStylePlain)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.bounces = NO;
    _leftTableView.backgroundColor = [UIColor whiteColor];
    //    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.view addSubview:_leftTableView];
    
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4, 64, SCREENWIDTH-SCREENWIDTH/4, SCREENHEIGHT-64) style:(UITableViewStyleGrouped)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.bounces = NO;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    //    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightTableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _rightTableView) {
        return self.rightArray.count;
    }else if(tableView == _leftTableView){
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _rightTableView) {
        NSArray *arr = self.rightArray[section];
        return arr.count;
    }else if(tableView == _leftTableView){
        return self.leftArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _rightTableView) {
        return 50;
    }else if(tableView == _leftTableView){
        return 40;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _rightTableView) {
        return 35;
    }else if (tableView == _leftTableView){
        return 0.00001;
    }
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _rightTableView) {
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
        headView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        UILabel *alabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headView.frame.size.width-20, 35)];
        alabel.backgroundColor = [UIColor clearColor];
        alabel.text = [NSString stringWithFormat:@"第 %ld 个类型",section+1];
        alabel.font = [UIFont systemFontOfSize:14];
        alabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:alabel];
        return headView;
    }else if(tableView == _leftTableView){
        return nil;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        
        static NSString * cellID = @"leftCell";
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, tableView.frame.size.width, 39)];
        left.font = [UIFont systemFontOfSize:13];
        left.backgroundColor = [UIColor clearColor];
        left.text = self.leftArray[indexPath.row];
        left.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:left];
        
        
        return cell;
    }else if(tableView == _rightTableView){
        static NSString * cellID = @"rightCell";
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, tableView.frame.size.width, 49)];
        right.backgroundColor = [UIColor clearColor];
        right.font = [UIFont systemFontOfSize:13];
        right.text = [NSString stringWithFormat:@"第%ld区域的%@",indexPath.section+1,self.rightArray[indexPath.section][indexPath.row]];
        [cell.contentView addSubview:right];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _leftTableView) {
        [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((UITableView *)scrollView == _leftTableView) return;
    // 滚动右边tableView，设置选中左边的tableView某一行。indexPathsForVisibleRows属性返回屏幕上可见的cell的indexPath数组，利用这个属性就可以找到目前所在的分区
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_rightTableView.indexPathsForVisibleRows.firstObject.section+1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}
-(NSMutableArray *)leftArray{
    if (_leftArray == nil) {
        _leftArray = [NSMutableArray new];
        for (int i = 0; i < 13; i ++) {
            NSString *title = [NSString stringWithFormat:@"第 %d 个类型",i+1];
            [_leftArray addObject:title];
        }
    }
    return _leftArray;
}
-(NSMutableArray *)rightArray{
    if (_rightArray == nil) {
        _rightArray = [NSMutableArray new];
        for (int i = 0; i < 13; i ++) {
            int a = [self getRandomNumber:2 to:8];
            NSMutableArray *aa = [NSMutableArray new];
            [_rightArray addObject:aa];
            for (int j = 0; j < a; j++) {
                NSString *title = [NSString stringWithFormat:@"第 %d 个好吃的",j+1];
                
                [_rightArray[i] addObject:title];
            }
        }
    }
    return _rightArray;
}
-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
