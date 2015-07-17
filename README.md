#如何自定义视图控制器的页面跳转动画
>此教程工程来自`Ray Wendelich`的书籍`iOS Animations by Tutorials`

项目初始运行结果
-----

- 初始项目的页面跳转效果  
![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/before.gif)  

- 即将实现的自定义页面跳转效果~  
![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/after.gif) 

运行环境要求
-----
- Xcode 7 beta2 +
- ios 8 +  

实现原理
-----
  是这样的，UIKIt是通过代理模式来自定义页面跳转动画,每次运行页面跳转动画时，UIKit都会去检查它的`UIViewControllerTransitioningDelegate`代理中的方法`func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?`的返回值，如果是nil的话，就会执行系统默认的页面跳转动画，如下图所示:  
![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/transitionDelegate.png)  
  如果返回值是一个`NSObject`,也就是我们将要创建的自定义动画控制器`Animator`,则会执行我们的自定义动画,如下图所示:  
![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/animator.png) 

所以总结一下，我们要自定义跳转动画的话需要这么几个步骤:

 1. 让页面跳转的起始视图控制器和终点视图控制器都实现`UIViewControllerTransitioningDelegate`协议
 >记得在执行跳转前将`delegate`对象设置为`self`
 2. 创建自定义的动画类,并实现`UIViewControllerAnimatedTransitioning`协议
 3. 具体实现动画内容，主要在`UIViewControllerAnimatedTransitioning`协议中的`func animateTransition(transitionContext: UIViewControllerContextTransitioning)`方法中实现
 

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
