# JElasticPullToRefresh
Elastic pull to refresh compontent developed in Swift translate to Objective-C now!

Swift Source : [DGElasticPullToRefresh](https://github.com/gontovnik/DGElasticPullToRefresh)

Inspired by this Dribbble post: [Pull Down to Refresh](https://dribbble.com/shots/2232385-Pull-Down-to-Refresh) by [Hoang Nguyen](https://dribbble.com/Hoanguyen)

Tutorial on how swift bounce effect was achieved can be found [here](http://iostuts.io/2015/10/17/elastic-bounce-using-uibezierpath-and-pan-gesture/).

![](https://github.com/mifanj/JElasticPullToRefresh/blob/master/JElasticPullToRefreshPreview.gif?raw=true)

## Requirements
* Xcode 7 or higher
* iOS 7.0 or higher
* ARC
* Objective-C

## Demo

Open and run the JElasticPullToRefreshDemo project in Xcode to see JElasticPullToRefresh in action.

## Installation

### CocoaPods

``` ruby
pod "JElasticPullToRefresh"
```

### Manual

Add JElasticPullToRefresh folder into your project.

## Example usage

``` objc
JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
loadingViewCircle.tintColor = [UIColor whiteColor];

__weak __typeof(self)weakSelf = self;
[self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
  // Add your logic here
  // Do not forget to call '[tableView stopLoading]' here
  [weakSelf.tableView stopLoading];
} LoadingView:loadingViewCircle];
[self.tableView setJElasticPullToRefreshFillColor:[UIColor colorWithRed:0.0431 green:0.7569 blue:0.9412 alpha:1.0]];
[self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];
```

Do not forget to remove pull to refresh on view controller dealloc. It is a temporary solution.

``` objc
- (void)dealloc {
    [self.tableView removeJElasticPullToRefreshView];
}
```

### Description

You can use built-in *JElasticPullToRefreshLoadingViewCircle* or create your own by subclassing **JElasticPullToRefreshLoadingView** and implementing these methods:

``` objc
- (void)setPullProgress:(CGFloat)progress;
- (void)startAnimating;
- (void)stopLoading;
```

Remove pull to refresh:

``` objc
- (void)removeJElasticPullToRefreshView;
```

Change pull to refresh background color:

``` objc
- (void)setJElasticPullToRefreshBackgroundColor:(UIColor *)color;
```

Change pull to refresh fill color:

``` objc
- (void)setJElasticPullToRefreshFillColor:(UIColor *)color;
```

## Contribution

Please feel free to submit pull requests. Cannot wait to see your custom loading views for this pull to refresh.

## Contact

mifanJ
- https://github.com/gontovnik
- jy2211@qq.com

Danil Gontovnik (Swift Source Author)
- https://github.com/gontovnik
- https://twitter.com/gontovnik
- http://gontovnik.com/
- danil@gontovnik.com
- http://iostuts.io/author/danil-gontovnik/

## License

The MIT License (MIT)

Copyright (c) 2016 mifanJ

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
