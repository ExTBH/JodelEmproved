#import "Tweak.h"


%hook UserSectionViewController

-(void)setTableView:(id)arg1{
    NSLog(@"JodelTheos tableView : %@", arg1);
    %orig;
}

%end

%hook UserSectionTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger orig = %orig;
    NSLog(@"JodelTheos Section ; %ld : Rows : %ld ",section, orig);
    if(section == 1) {
        
        NSLog(@"JodelTheos Section ; %ld : Rows + 1 : ",section);
        return 6;
        
    }
    return orig;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"JodelTheos IndexPath : %@",indexPath);
    if(indexPath.section == 1 && indexPath.row == 6){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idkFFS"];
        cell.textLabel.text = @"Hellow World!";
        NSLog(@"JodelTheos IndexPath6 : %@",indexPath);
        return cell;
    }

    UITableViewCell *cell = %orig;
    NSLog(@"JodelTheos IndexPath : %@ : Cell : %@ ",indexPath,  cell);
    return cell;
}



%end



%ctor {
    %init(UserSectionTableDataSource=objc_getClass("Jodel.UserSectionTableDataSource"),
    UserSectionViewController=objc_getClass("Jodel.UserSectionViewController"));
}