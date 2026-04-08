@Builder
export function PageOneBuilder(name: string, param: string) {
  PageOne({ name: name, value: param });
}

@Component
export struct PageOne {
  navPathStack: NavPathStack = new NavPathStack();
  name: string = '';
  @State value: string = '';
  context = this.getUIContext().getHostContext();

  build() {
    NavDestination() {
      Column() {
        // $r('app.string.settingPage')需要替换为开发者所需的字符串资源文件
        Text(`${this.name}${this.context!.resourceManager.getStringSync($r('app.string.settingPage').id)}`)
          .width('100%')
          .fontSize(20)
          .fontColor(0x333333)
          .textAlign(TextAlign.Center)
          .textShadow({
            radius: 2,
            offsetX: 4,
            offsetY: 4,
            color: 0x909399
          })
          .padding({ top: 30 })
        Text(`${JSON.stringify(this.value)}`)
          .width('100%')
          .fontSize(18)
          .fontColor(0x666666)
          .textAlign(TextAlign.Center)
          .padding({ top: 45 })
        // $r('app.string.stepperIndex_text24')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.return'))
          .width('50%')
          .height(40)
          .margin({ top: 50 })
          .onClick(() => {
            // 弹出路由栈栈顶元素，返回上个页面
            this.navPathStack.pop();
          })
      }
      .size({ width: '100%', height: '100%' })
    }.title(`${this.name}`)
    .onReady((ctx: NavDestinationContext) => {
      // NavDestinationContext获取当前所在的导航控制器
      this.navPathStack = ctx.pathStack;
    })
  }
}