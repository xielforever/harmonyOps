import router from '@ohos.router';
import { Theme } from '../theme/Theme';

@Entry
@Component
struct LoginPage {
  @State currentTabIndex: number = 0;
  
  // 租户登录状态 (Tenant Login State)
  @State masterAccount: string = '';
  @State subAccount: string = '';
  @State tenantPassword: string = '';

  // 账号登录状态 (Account Login State)
  @State account: string = '';
  @State accountPassword: string = '';

  handleLogin() {
    // TODO: 这里应添加实际的网络登录请求逻辑
    // 模拟登录成功，跳转至主页
    router.replaceUrl({ url: 'pages/MainPage' });
  }

  @Builder TabBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .fontColor(this.currentTabIndex === index ? Theme.PRIMARY : Theme.TEXT_SECONDARY)
        .fontSize(16)
        .fontWeight(this.currentTabIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .margin({ bottom: 8 })
      
      if (this.currentTabIndex === index) {
        Divider()
          .color(Theme.PRIMARY)
          .strokeWidth(2)
          .width(40)
      } else {
        Divider()
          .color(Color.Transparent)
          .strokeWidth(2)
          .width(40)
      }
    }
    .width('100%')
    .padding({ top: 16 })
    .onClick(() => {
      this.currentTabIndex = index;
    })
  }

  build() {
    Column() {
      // Logo / 标题区域
      Column() {
        Text('HarmonyOps')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor(Theme.TEXT_PRIMARY)
          .margin({ bottom: 8 })
        Text('运维助手')
          .fontSize(16)
          .fontColor(Theme.TEXT_SECONDARY)
      }
      .margin({ top: 80, bottom: 40 })
      .alignItems(HorizontalAlign.Center)

      // 登录卡片
      Column() {
        Tabs({ barPosition: BarPosition.Start }) {
          // 模式 1: 租户登录
          TabContent() {
            Column() {
              TextInput({ placeholder: '主账号', text: this.masterAccount })
                .placeholderColor(Theme.TEXT_SECONDARY)
                .fontColor(Theme.TEXT_PRIMARY)
                .backgroundColor(Theme.SURFACE_2)
                .height(48)
                .margin({ bottom: 16 })
                .onChange((value: string) => { this.masterAccount = value })

              TextInput({ placeholder: '子账号', text: this.subAccount })
                .placeholderColor(Theme.TEXT_SECONDARY)
                .fontColor(Theme.TEXT_PRIMARY)
                .backgroundColor(Theme.SURFACE_2)
                .height(48)
                .margin({ bottom: 16 })
                .onChange((value: string) => { this.subAccount = value })

              TextInput({ placeholder: '密码', text: this.tenantPassword })
                .type(InputType.Password)
                .placeholderColor(Theme.TEXT_SECONDARY)
                .fontColor(Theme.TEXT_PRIMARY)
                .backgroundColor(Theme.SURFACE_2)
                .height(48)
                .margin({ bottom: 24 })
                .onChange((value: string) => { this.tenantPassword = value })

              Button('登录')
                .width('100%')
                .height(48)
                .backgroundColor(Theme.PRIMARY)
                .fontColor(Theme.TEXT_PRIMARY)
                .onClick(() => this.handleLogin())
            }
            .padding(24)
            .width('100%')
          }.tabBar(this.TabBuilder('租户登录', 0))

          // 模式 2: 账号登录
          TabContent() {
            Column() {
              TextInput({ placeholder: '账号', text: this.account })
                .placeholderColor(Theme.TEXT_SECONDARY)
                .fontColor(Theme.TEXT_PRIMARY)
                .backgroundColor(Theme.SURFACE_2)
                .height(48)
                .margin({ bottom: 16 })
                .onChange((value: string) => { this.account = value })

              TextInput({ placeholder: '密码', text: this.accountPassword })
                .type(InputType.Password)
                .placeholderColor(Theme.TEXT_SECONDARY)
                .fontColor(Theme.TEXT_PRIMARY)
                .backgroundColor(Theme.SURFACE_2)
                .height(48)
                .margin({ bottom: 24 })
                .onChange((value: string) => { this.accountPassword = value })

              Button('登录')
                .width('100%')
                .height(48)
                .backgroundColor(Theme.PRIMARY)
                .fontColor(Theme.TEXT_PRIMARY)
                .onClick(() => this.handleLogin())
            }
            .padding(24)
            .width('100%')
          }.tabBar(this.TabBuilder('账号登录', 1))
        }
        .onChange((index: number) => {
          this.currentTabIndex = index;
        })
        .barMode(BarMode.Fixed)
        .barWidth('100%')
        .barHeight(56)
        .backgroundColor(Theme.SURFACE_1)
        .borderRadius(Theme.BORDER_RADIUS)
        .border({ width: Theme.BORDER_WIDTH, color: Theme.SURFACE_2, style: BorderStyle.Solid })
      }
      .width('90%')
      .margin({ bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
    .alignItems(HorizontalAlign.Center)
  }
}