#如何自定义视图控制器切换动画
>此教程工程来自Ray Wendelich的书籍:iOS_Animations_by_Tutorials

项目初始运行结果截图
-----
- 主界面  

![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/Start-project-1.png)
- 图片浏览界面  

![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/Start-project-detailViewer.png)

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
