#import "FYComboBox.h"

@interface FYComboBox ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FYComboBox

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setTitle:@"" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(comboTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.button];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.button.frame), CGRectGetWidth(self.frame), 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.tableView];
    
    [self setDefaultValues];
}

- (void)setDefaultValues
{
    self.maxRows = 3;
    self.cellHeight = 50.f;
    self.cellBackgroundColor = [UIColor whiteColor];
    self.cellTextColor = [UIColor blackColor];
    self.cellLineColor = [UIColor clearColor];
    self.minimumWidth = CGFLOAT_MAX;
    self.showsScrollIndicator = YES;
    self.animationShowDuration = .25;
    self.animationHideDuration = .25;
}

- (void)layoutSubviews
{
    
}

- (CGFloat)heightWithMaxRows:(NSInteger)maxRows
{
    NSInteger rows = [self.delegate comboBoxNumberOfRows:self];
    
    CGFloat total = 0.0f;
    
    for (int i = 0; i < maxRows && i < rows; i++) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:heightForRow:)]) {
            total += [self.delegate comboBox:self heightForRow:i];
        } else {
            total += self.cellHeight;
        }
    }
    
    return total;
}

#pragma mark - Interface Builder

- (void)prepareForInterfaceBuilder
{
}

#pragma mark - Events

- (void)comboTouch:(id)sender
{
    if (self.tableView.frame.size.height == 0) {
        
        [self.tableView reloadData];
        
        if ([self.delegate comboBoxNumberOfRows:self] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        CGFloat height = [self heightWithMaxRows:self.maxRows];
        
        CGRect buttonFrame = self.button.frame;
        
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = height;
        tableFrame.size.width = self.minimumWidth != CGFLOAT_MAX ? MAX(self.minimumWidth, CGRectGetWidth(buttonFrame)) : CGRectGetWidth(buttonFrame);
        
        CGRect newFrame = self.frame;
        newFrame.size.height = self.button.frame.size.height + height;
        
        [UIView animateWithDuration:self.animationShowDuration animations:^{
            self.tableView.frame = tableFrame;
            self.frame = newFrame;
        } completion:^(BOOL finished) {
        }];
        
    } else {
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = 0;
        
        CGRect newFrame = self.frame;
        newFrame.size.height = self.button.frame.size.height;
        
        [UIView animateWithDuration:self.animationHideDuration animations:^{
            self.tableView.frame = tableFrame;
            self.frame = newFrame;
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = self.showsScrollIndicator;
    
    return [self.delegate comboBoxNumberOfRows:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger lineTag = 100;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        
        UIView *lineView = [UIView new];
        lineView.tag = lineTag;
        lineView.backgroundColor = [UIColor clearColor];
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cell.contentView addSubview:lineView];
        
        NSDictionary *views = @{@"line": lineView};
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]-0-|" options:0 metrics:nil views:views]];
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]-0-|" options:0 metrics:nil views:views]];
        
        [cell.contentView setNeedsUpdateConstraints];
    }
    
    UIView *lineView = [cell.contentView viewWithTag:100];
    
    lineView.backgroundColor = self.cellLineColor;
    
    cell.contentView.backgroundColor = self.cellBackgroundColor;
    cell.textLabel.textColor = self.cellTextColor;
    
    cell.textLabel.text = [self.delegate comboBox:self titleForRow:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self comboTouch:tableView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:didSelectRow:)]) {
        [self.delegate comboBox:self didSelectRow:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.cellHeight;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(comboBox:heightForRow:)]) {
        height = [self.delegate comboBox:self heightForRow:indexPath.row];
    }
    
    return height;
}

#pragma mark - Setters

- (void)setCellHeight:(CGFloat)cellHeight
{
    _cellHeight = cellHeight;
    
    self.tableView.rowHeight = _cellHeight;
}

- (void)setShowsScrollIndicator:(BOOL)showsScrollIndicator
{
    _showsScrollIndicator = showsScrollIndicator;
}

@end
