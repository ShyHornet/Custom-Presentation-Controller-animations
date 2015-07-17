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

 1. 创建自定义的动画类,并实现`UIViewControllerAnimatedTransitioning`协议
 2. 让页面跳转的起始视图控制器和终点视图控制器都实现`UIViewControllerTransitioningDelegate`协议
 >记得在执行跳转前将`delegate`对象设置为`self`
 3. 具体实现动画内容，主要在`UIViewControllerAnimatedTransitioning`协议中的`func animateTransition(transitionContext: UIViewControllerContextTransitioning)`方法中实现
 
 so,我们知道了原理，也知道大概实现的步骤了，下面就开始写代码了！
 
开始写代码( ⊙ o ⊙ )
----

首先，新建一个动画类`popAnimator.swift`，用来实现我们的动画逻辑
```Swift
class PopAnimator: NSObject,UIViewControllerAnimatedTransitioning{

}
```
实现`UIViewControllerAnimatedTransitioning`协议的方法:
```Swift 
func transitionDuration(transitionContext: UIViewControllerContextTransitioning)-> NSTimeInterval 
{
  return 0
}
```
动画的时间设置成0只是暂时的(为了消除没有返回值的错误)，之后我们会设置它的具体时间
```Swift
func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
}
```
我们自定义的动画逻辑，主要就在这个方法中实现

在视图控制器`ViewController.swift`中实现UIViewControllerTransitioningDelegate,此处用extension方式实现,在类`ViewController`的外面，文件的底部添加如下代码

```Swift

extension ViewController: UIViewControllerTransitioningDelegate{
  
   //在显示视图控制器时执行  
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) 
    -> UIViewControllerAnimatedTransitioning?
    {
        transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame,
        toView: nil)
        transition.presenting = true
        selectedImage!.hidden = true
        
        return transition
    }
    
   func animationControllerForDismissedController(dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning?
    {   transition.presenting = false
        
        return transition
    }
}

```
实现`UIViewControllerAnimatedTransitioning`协议的两个方法

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
