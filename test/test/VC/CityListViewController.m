//
//  CityListViewController.m
//  test
//
//  Created by rrjj on 2019/4/11.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "CityListViewController.h"
#import "AreaModel.h"
#import <MJExtension.h>
#import "ReadOnlyModel.h"

@interface CityListViewController ()<NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,strong) NSMutableArray *titleArray;


@property (copy, nonatomic) NSString *cityName;
@property (nonatomic,strong) NSDictionary *cityDict;

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"MTcityList" ofType:@"xml"];

    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.delegate = self;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL result = [parser parse];
        if (result) {
            NSLog(@"成功parse");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ReadOnlyModel *mo = [[ReadOnlyModel alloc] initWithStr:@"init"];
    NSLog(@"befor:%@",mo.readOnlyStr);
    [mo setValue:@"change" forKey:@"readOnlyStr"];
    NSLog(@"after:%@",mo.readOnlyStr);
}
/** tableView滚动的时候,不要去做动画(微信的聊天界面做的就很好,在滚动的时候,动态图就不让他动,滚动停止的时候才动,不然可能会有点影响流畅度)。在滚动的时候加载图片，停止拖拽后在减速过程中不加载图片，减速停止后加载可见范围内图片
 
 */
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AreaModel *model = self.dataSource[section];
    return model.area.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AreaModel *model = self.dataSource[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 375, 30)];
    label.text = model.city.name;
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

/** cell做数据绑定的时候，最好在willDisPlayCell里面进行 因为第一页有多少条就执行多少次*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaModel *model = self.dataSource[indexPath.section];
    areaCityModel *city = model.area[indexPath.row];
    cell.textLabel.text = city.name;
    
    [city setValue:@(10) forKey:@"readOnlyHeight"];
    NSLog(@"readOnlyHeight:%lf",city.readOnlyHeight);
}

//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    tableView.sectionIndexColor = [UIColor grayColor];
//    AreaModel *model = self.dataSource[section];
    return self.titleArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSLog(@"%@ - %ld - %@",title,index,self.titleArray[index]);
    return index ;
}

/** 第一次加载有多少个cell就执行多少次，而且调用的时候cell还没显示 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    
    return cell;
}


#pragma mark - NSXMLParserDelegate
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"start");
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"end");
    NSLog(@"%@",self.dataSource);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
//    NSLog(@"%@ %@ %@ %@",elementName,namespaceURI,qName,attributeDict);
    if ([elementName isEqualToString:@"city"]) {
        
        if (self.resultArray.count > 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.cityDict forKey:self.cityName];
            [dict setObject:self.resultArray forKey:@"area"];
             AreaModel *model = [AreaModel mj_objectWithKeyValues:dict];
            
            [self.dataSource addObject:model];
            [self.titleArray addObject:model.city.name];
        }
        [self.resultArray removeAllObjects];
        
        self.cityName = elementName;
        self.cityDict = attributeDict;
    }
    if ([elementName isEqualToString:@"district"]) {
        [self.resultArray addObject:attributeDict];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"%s %@ %@ %@ ",__func__,elementName,namespaceURI,qName);
//    if ([elementName isEqualToString:@"name" ]||[elementName isEqualToString:@"latitude"]||[elementName isEqualToString:@"longitude"]) {
//        [self.dic setObject:self.str forKey:elementName];
//    }else if ([elementName isEqualToString:@"division"]){
//        [self.arr addObject:self.dic];
//    }
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    self.str=string;
    NSLog(@"%s %@",__func__,string);
}

#pragma mark - lazy
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
-(NSDictionary *)cityDict
{
    if (!_cityDict) {
        _cityDict = [NSMutableDictionary dictionary];
    }
    return _cityDict;
}
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
@end
