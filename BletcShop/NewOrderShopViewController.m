//
//  NewOrderShopViewController.m
//  BletcShop
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewOrderShopViewController.h"
#import "LZDButton.h"
#import "PickReasonView.h"
#import "NewOrderCell.h"

@interface NewOrderShopViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@end

@implementation NewOrderShopViewController
{
    UIView *topBackView;
    UIView *noticeLine;
}
-(NSMutableArray *)sure_A{
    if (!_sure_A) {
        _sure_A = [NSMutableArray array];
    }
    return _sure_A;
}
-(NSMutableArray *)confuse_A{
    if (!_confuse_A) {
        _confuse_A = [NSMutableArray array];
    }
    return _confuse_A;
}
-(NSMutableArray *)wait_A{
    if (!_wait_A) {
        _wait_A = [NSMutableArray array];
    }
    return _wait_A;
}
-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"预约处理";
    LEFTBACK
    self.selectTag=0;
    [self initCatergray];
}
//卡分类
-(void)initCatergray{
    NSArray *kindArray=@[@"待确认(0)",@"已确认(0)",@"已拒绝(0)"];
    topBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 49)];
    topBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topBackView];
    
    for (int i=0; i<kindArray.count; i++) {
        UIButton *Catergray=[UIButton buttonWithType:UIButtonTypeCustom];
        Catergray.frame=CGRectMake(1+i%kindArray.count*((SCREENWIDTH-5)/kindArray.count+1), 0, (SCREENWIDTH-5)/kindArray.count, 49);
        Catergray.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [Catergray setTitle:kindArray[i] forState:UIControlStateNormal];
        [Catergray setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
        Catergray.tag=666+i;
        [topBackView addSubview:Catergray];
        [Catergray addTarget:self action:@selector(changeTitleColorAndRefreshCard:) forControlEvents:UIControlEventTouchUpInside];
        if (i!=kindArray.count-1) {
            if (i==0) {
                [Catergray setTitleColor:RGB(241,122,18) forState:UIControlStateNormal];
                noticeLine=[[UIView alloc]init];
                noticeLine.bounds=CGRectMake(0, 0, (SCREENWIDTH-105)/kindArray.count, 1);
                noticeLine.center=CGPointMake(Catergray.center.x, Catergray.center.y+24);
                noticeLine.backgroundColor=RGB(241,122,18);
                [topBackView addSubview:noticeLine];
            }
            UIView *catergrayView=[[UIView alloc]initWithFrame:CGRectMake(Catergray.frame.origin.x+(SCREENWIDTH-5)/kindArray.count,0,1,49)];
            catergrayView.backgroundColor=RGB(234, 234, 234);
            [topBackView addSubview:catergrayView];
        }
        
    }
    
    
    
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, SCREENHEIGHT-49-64) style:UITableViewStyleGrouped];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];
    [self postRequestDelay];
    
}

-(void)postRequestDelay
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/appoint/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"]  forKey:@"muid"];
    [params setObject:@"null" forKey:@"state"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@", result);
        NSArray *resuArr = result;
        
        [self.wait_A removeAllObjects];
        
        
        for (NSDictionary *dic in resuArr) {
            
            if ([dic[@"state"] isEqualToString:@"null"]) {
                [self.wait_A addObject:dic];
            }
        }
         [self getfirstData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, );
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    switch (self.selectTag) {
        case 0:
        {
            self.data_A=self.wait_A;
        }
            break;
        case 1:
        {
            self.data_A=self.sure_A;
        }
            break;
        case 2:
        {
            self.data_A=self.confuse_A;
        }
            break;
            
        default:
            break;
    }

    return self.data_A.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.selectTag ==0) {
        return 47;
        
    }else
        return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 41+10)];
    view.backgroundColor = [UIColor whiteColor];
    for (UIView*subview in view.subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    line0.backgroundColor = RGB(239,238,244);
    [view addSubview:line0];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, line0.bottom, 75, 40)];
    lab.text = @"会员名称:";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = RGB(153,153,153);
    lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab];
    
    
    UILabel *card_code_lab = [[UILabel alloc]initWithFrame:CGRectMake(102, line0.bottom, SCREENWIDTH-100, 40)];
    card_code_lab.text = @"";
    card_code_lab.font = [UIFont systemFontOfSize:15];
    card_code_lab.textColor = RGB(51,51,51);
    card_code_lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:card_code_lab];
    
    UILabel *state_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, line0.bottom, SCREENWIDTH-43, 40)];
    state_lab.font = [UIFont systemFontOfSize:12];
    state_lab.textColor = RGB(153,153,153);
    state_lab.textAlignment = NSTextAlignmentRight;
    [view addSubview:state_lab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, state_lab.bottom, SCREENWIDTH, 1)];
    line.backgroundColor = RGB(246,246,246);
    [view addSubview:line];
    
    if (self.data_A.count!=0) {
        card_code_lab.text = self.data_A[section][@"name"];
        NSString *state_S =self.data_A[section][@"state"];
        
        if ([state_S isEqualToString:@"access"]) {
            state_lab.text = @"已同意";
        }
        if ([state_S isEqualToString:@"fail"]) {
            state_lab.text = @"已拒绝";
        }
        
    }
    
    
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.selectTag==0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 47)];
        view.backgroundColor = [UIColor whiteColor];
        for (UIView*subview in view.subviews) {
            [subview removeFromSuperview];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(246,246,246);
        [view addSubview:line];
        
        
        for (int i = 0; i <2; i ++) {
            
            LZDButton *btn = [LZDButton creatLZDButton];
            btn.frame = CGRectMake(SCREENWIDTH-180 +i*(30+68), 9, 68, 27);
            btn.layer.cornerRadius = 3;
            btn.layer.borderColor = RGB(153,153,153).CGColor;
            btn.layer.borderWidth = 1;
            btn.layer.masksToBounds = YES;
            [view addSubview:btn];
            btn.section = section;
            btn.row = i;
            
            
            if (i==0) {
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitle:@"拒绝" forState:0];
                [btn setTitleColor:RGB(102,102,102) forState:0];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                
                btn.block = ^(LZDButton *sender) {
                    
                    PickReasonView *pickReasonView = [[PickReasonView alloc]init];
                    pickReasonView.title = @"拒绝原因";
                    
                    pickReasonView.dataSource = @[@"商家休息中",@"商家暂停歇业",@"预约已满",@"店铺装修/硬件维修中",@"消费时需出示本人证件",@"需要至少提前两小时预约",@"其它(详情请咨询商家)"];
                    [self.view addSubview:pickReasonView];
                    
                    [pickReasonView show];
                    
                    pickReasonView.sureBtnClick = ^(NSArray *value) {
                        
                        NSLog(@"0-----0=%@",value);
                        
                        [self setStateBtn:sender andReason:value[0]];
                    };
                    
                };

            }
            if (i==1) {
                btn.backgroundColor = RGB(241,122,18);
                [btn setTitle:@"通过" forState:0];
                [btn setTitleColor:RGB(255,255,255) forState:0];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                
                 [btn addTarget:self action:@selector(disposeClick:) forControlEvents:UIControlEventTouchUpInside];

            }
            
            
        }
        
        
        return view;
        
    }else{
        return nil;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewOrderCellID"];
    
   
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewOrderCell" owner:self options:nil] firstObject];
      
    }
    
    if (self.selectTag==2) {
        cell.rightView.hidden = NO;
    }else{
        cell.rightView.hidden = YES;

    }
    
    if (self.data_A.count!=0) {
        NSDictionary *dic = self.data_A[indexPath.section];
       
        
        
        cell.phoneLab.text = dic[@"phone"];
        
        cell.timeLab.text = dic[@"time"];
        
        cell.contentLab.text = dic[@"content"];
        cell.dateLab.text = [NSString stringWithFormat:@"%@",dic[@"date"]];
        cell.reasonLab.text = [NSString getTheNoNullStr:dic[@"reason"] andRepalceStr:@""];
        
    }

    return cell;
}
-(void)getfirstData
{
    
    //获取已处理的
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/appoint/get",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    [params setObject:@"access" forKey:@"state"];
    
    
    NSLog(@"----%@===url==%@",params,url);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *resuArr = result;
        
        [self.sure_A removeAllObjects];
        [self.confuse_A removeAllObjects];
        
        
        for (NSDictionary *dic in resuArr) {
            
            
            if ([dic[@"state"] isEqualToString:@"access"]) {
                [self.sure_A addObject:dic];
            }
            
            if ([dic[@"state"] isEqualToString:@"fail"]) {
                [self.confuse_A addObject:dic];
                
            }
            
            
        }
        
        for (int i=0; i<3; i++) {
            UIButton*button=(UIButton *)[topBackView viewWithTag:666+i];
            NSString *title_S;
            if (i==0) {
                title_S = [NSString stringWithFormat:@"待确认(%lu)",(unsigned long)self.wait_A.count];
            }
            if (i==1) {
                title_S = [NSString stringWithFormat:@"已确认(%lu)",(unsigned long)self.sure_A.count];
            }
            
            if (i==2) {
                title_S = [NSString stringWithFormat:@"已拒绝(%lu)",(unsigned long)self.confuse_A.count];
            }
            
            
            [button setTitle:title_S forState:UIControlStateNormal];
            
            
            
        }
        
        
        
        [self.myTableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 64, 375, 667);
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];
    
}

-(void)changeTitleColorAndRefreshCard:(UIButton *)sender{
    
    
    self.selectTag = sender.tag - 666;
    noticeLine.center=CGPointMake(sender.center.x, sender.center.y+24);
    for (int i=0; i<3; i++) {
        UIButton*button=(UIButton *)[topBackView viewWithTag:666+i];
        if (button.tag==sender.tag) {
            [button setTitleColor:RGB(241,122,18) forState:UIControlStateNormal];
        }else{
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
    }
    
    [self postRequestDelay];
    
}
//处理延期业务

-(void)disposeClick:(LZDButton*)sender{
    
    [self setStateBtn:sender andReason:@""];
}


-(void)setStateBtn:(LZDButton*)sender andReason:(NSString*)reason{
    
        
        NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/appoint/stateSet",BASEURL];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
        
        [params setObject:[[self.data_A objectAtIndex:sender.section] objectForKey:@"user"] forKey:@"uuid"];
        [params setObject:[[self.data_A objectAtIndex:sender.section] objectForKey:@"date"] forKey:@"date"];
        [params setObject:[[self.data_A objectAtIndex:sender.section] objectForKey:@"time"] forKey:@"time"];

    
        if (sender.row == 1) {
            [params setObject:@"access" forKey:@"state"];
        }else if (sender.row == 0) {
            [params setObject:@"fail" forKey:@"state"];
            [params setObject:reason forKey:@"reason"];

        }
    
        NSLog(@"----%@",params);
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
            
            if ([result[@"result_code"] intValue]==1)
            {
                
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"设置成功", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:1.f];
                [self postRequestDelay];
                
            }
            else
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.frame = CGRectMake(0, 64, 375, 667);
                // Set the annular determinate mode to show task progress.
                hud.mode = MBProgressHUDModeText;
                
                hud.label.text = NSLocalizedString(@"设置失败,请重试", @"HUD message title");
                hud.label.font = [UIFont systemFontOfSize:13];
                // Move to bottm center.
                //    hud.offset = CGPointMake(0.f, );
                hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                [hud hideAnimated:YES afterDelay:1.f];
            }
        } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(0, 64, 375, 667);
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"请求出错,请重新请求", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            // Move to bottm center.
            //    hud.offset = CGPointMake(0.f, );
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
            
        }];
        
    
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

@end
