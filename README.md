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
  是这样的，UIKIt是通过**代理模式**来自定义页面跳转动画,每次运行页面跳转动画时，UIKit都会去检查它的`UIViewControllerTransitioningDelegate`代理中的方法`func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?`的返回值，如果是nil的话，就会执行系统默认的页面跳转动画，如下图所示:  
![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/transitionDelegate.png)  
  如果返回值是一个`NSObject`,也就是我们将要创建的自定义动画控制器`Animator`,则会执行我们的自定义动画,如下图所示:  
![](https://raw.githubusercontent.com/ShyHornet/Custom-Presentation-Controller-animations/master/Asset/animator.png) 

所以总结一下，我们要自定义跳转动画的话需要这么几个步骤:

 ####1. 创建自定义的动画类,并实现`UIViewControllerAnimatedTransitioning`协议
 ####2. 让页面跳转的起始视图控制器和终点视图控制器都实现`UIViewControllerTransitioningDelegate`代理
 >记得在执行跳转前将`delegate`对象设置为`self`  

 ####3. 具体实现动画内容，主要在`UIViewControllerAnimatedTransitioning`协议中的`func animateTransition(transitionContext: UIViewControllerContextTransitioning)`方法中实现
 
 so,我们知道了原理，也知道大概实现的步骤了，下面就开始写代码了！
 
开始写代码( ⊙ o ⊙ )
----
###1.创建动画类  

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
>动画的时间设置成0只是暂时的(为了消除没有返回值的错误)，之后我们会设置它的具体时间  

  ```Swift
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
  }
  ```
  我们自定义的动画逻辑，主要就在上述方法中实现

###2.实现`UIViewControllerTransitioningDelegate`代理 

在视图控制器`ViewController.swift`中实现UIViewControllerTransitioningDelegate,此处用extension方式实现,在类`ViewController`的外面，文件的结尾添加如下代码

```Swift

extension ViewController: UIViewControllerTransitioningDelegate{

}

```
>这段代码表明我们的视图控制器要遵循`UIViewControllerTransitioningDelegate`协议。  

找到`didTapImageView()`方法,在调用`presentViewController()`方法之前添加这一行代码:
```Swift
 herbDetails.transitioningDelegate = self
```
>`herbDetails`是我们要跳转到的视图控制器,也遵循`UIViewControllerTransitioningDelegate`协议，上述代码将其跳转代理设置为主页面的视图控制器`ViewController`，这样`UIKIt`在每次执行跳转动画时都会向`ViewController`索取一个动画对象,也就是我们下面要具体实现的`PopAnimator`  

然而我们并没有在`ViewController`中实际创建这个对象,所以我们先要创建这个`popAnimator `
为`ViewController`添加一个属性:
```Swift
let transition = PopAnimator()
```
在`extension`中添加如下方法:
```swift
func animationControllerForPresentedController( presented: UIViewController!,
presentingController presenting: UIViewController!, sourceController source: UIViewController!) 
-> UIViewControllerAnimatedTransitioning! 
{
   return transition 
}
```
返回刚才创建的动画对象,这样每次执行跳转动画时，就会调用我们自定义的动画对象，这个函数是在跳转的时候执行，那么如果是在返回的时候呢？那是下面这个函数所做的事情
添加另一个方法：
```swift
func animationControllerForDismissedController(dismissed: UIViewController!) 
-> UIViewControllerAnimatedTransitioning! 
{
   return nil 
}
```
我们还没有设置返回动画对象，所以返回时的动画还是使用默认的动画，我们先专注于跳转动画的实现，之后再去实现返回动画吧！
当然啦，现在运行，点击图片，你会发现没有任何反应，因为我们还没有在`popAnimator`中编写任何代码╰(￣▽￣)╮
###3.编写动画实现代码
向`popAnimator`类中添加属性:
```swift
let duration = 1.0
var presenting = true
var originFrame = CGRect.zeroRect
```

