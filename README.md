#如何自定义视图控制器的页面跳转动画
>此教程工程来自`Ray Wendelich`的书籍:iOS_Animations_by_Tutorials

项目初始运行结果截图
-----
- 主界面  

![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/Start-project-1.png)
- 图片浏览界面  

![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/Start-project-detailViewer.png)
运行环境要求
-----
- Xcode 7 beta2 +
- ios 8 +
具体实现
-----
运行时可以看到，点击单个图片会弹出一个新的视图控制器，用来展示图片的细节以及相应信息。页面的跳转动画是系统默认的动画,使用方法`func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)`进行页面跳转，此方法在`viewController.swift`中负责检测图片点击事件的方法`func didTapImageView(tap: UITapGestureRecognizer)`内进行了调用，我们要做的是用自定义的动画来替换系统默认的动画。
- 默认页面跳转效果  
- 
![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/before.gif)
-即将实现的自定义页面跳转效果~  

![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/after.gif)  

1.创建自定义切换动画类和所需成员变量:
```Swift
class PopAnimator: NSObject,UIViewControllerAnimatedTransitioning{
  let duration:NSTimeInterval = 1.0//动画的持续时间
    var presenting = true//判断是显示还是返回视图控制器
    var originFrame = CGRect.zeroRect//初始化frame
    var dismissCompletion: (()->())?//动画完成的闭包
}
```
2.实现`UIViewControllerAnimatedTransitioning`协议的两个方法
```Swift
func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) 
-> NSTimeInterval{
    
    return duration
        
    }
  func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
    //添加动画具体实现
    }
```
3.在视图控制器中实现UIViewControllerTransitioningDelegate,此处用extension方式实现
```Swift
extension ViewController: UIViewControllerTransitioningDelegate{
  
   //在显示视图控制器时执行  
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) 
    -> UIViewControllerAnimatedTransitioning?
    {transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame,
        toView: nil)
        transition.presenting = true
        selectedImage!.hidden = true
    return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning?
    {transition.presenting = false
        return transition
    }
}
```
