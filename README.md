#如何自定义视图控制器切换动画
1.创建自定义切换动画类和所需成员变量:
```Swift
class PopAnimator: NSObject,UIViewControllerAnimatedTransitioning{
  let duration:NSTimeInterval = 1.0//动画的持续时间
    var presenting = true//判断是显示还是返回视图控制器
    var originFrame = CGRect.zeroRect//初始化frame
    var dismissCompletion: (()->())?//动画完成的闭包
}
```
2.实现UIViewControllerAnimatedTransitioning协议的两个方法
```Swift
func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
    
    return duration
        
    }
  func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
    //添加动画具体实现
    }
```
