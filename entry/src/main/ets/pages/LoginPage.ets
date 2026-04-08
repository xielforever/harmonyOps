import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Theme } from '../theme/Theme';

@Entry
@Component
struct LoginPage {
  @State currentTabIndex: number = 0;
  
  // 云服务商选择
  @State selectedCloud: string = '华为云';

  // 登录加载状态
  @State isLoggingIn: boolean = false;

  // 租户登录状态 (Tenant Login State)
  @State masterAccount: string = '';
  @State subAccount: string = '';
  @State tenantPassword: string = '';

  // 账号登录状态 (Account Login State)
  @State account: string = '';
  @State accountPassword: string = '';

  async handleLogin() {
    if (this.isLoggingIn) return;

    // 基础校验
    if (this.currentTabIndex === 0) {
      if (!this.masterAccount || !this.subAccount || !this.tenantPassword) {
        promptAction.showToast({ message: '请完整填写租户登录信息' });
        return;
      }
    } else {
      if (!this.account || !this.accountPassword) {
        promptAction.showToast({ message: '请完整填写账号和密码' });
        return;
      }
    }

    this.isLoggingIn = true;

    try {
      // 调用云服务商鉴权 API
      let loginResult = await this.mockCloudAuthApi();

      if (loginResult.success) {
        promptAction.showToast({ message: '登录成功' });
        // 鉴权成功，跳转下一步
        router.replaceUrl({ url: 'pages/MainPage' });
      } else {
        promptAction.showToast({ message: '登录失败: ' + loginResult.message });
      }
    } catch (error) {
      promptAction.showToast({ message: '网络请求异常，请稍后重试' });
    } finally {
      this.isLoggingIn = false;
    }
  }

  // 预留的华为云/腾讯云 API 鉴权接口
  mockCloudAuthApi(): Promise<{success: boolean, message: string}> {
    return new Promise((resolve) => {
      // 模拟网络延迟
      setTimeout(() => {
        let payload: any = {
          cloudProvider: this.selectedCloud,
          loginType: this.currentTabIndex === 0 ? 'tenant' : 'account'
        };

        if (this.currentTabIndex === 0) {
          payload.masterAccount = this.masterAccount;
          payload.subAccount = this.subAccount;
          payload.password = this.tenantPassword;
        } else {
          payload.account = this.account;
          payload.password = this.accountPassword;
        }

        console.info('HarmonyOps', 'Sending auth request to ' + this.selectedCloud, JSON.stringify(payload));

        // TODO: 这里替换为真实的 @ohos.net.http 华为云/腾讯云鉴权逻辑
        // 模拟验证：密码必须不为空（上层已校验），这里假设返回成功
        resolve({ success: true, message: 'ok' });
      }, 1000);
    });
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
        // 云服务商下拉选择
        Row() {
          Text('云服务商')
            .fontColor(Theme.TEXT_PRIMARY)
            .fontSize(14)
          Select([{ value: '华为云' }, { value: '腾讯云' }])
            .selected(0)
            .value(this.selectedCloud)
            .font({ size: 14 })
            .fontColor(Theme.TEXT_PRIMARY)
            .selectedOptionFont({ size: 14 })
            .optionFont({ size: 14 })
            .backgroundColor(Theme.SURFACE_2)
            .onSelect((index: number, value: string) => {
              this.selectedCloud = value;
            })
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 16 })
        .justifyContent(FlexAlign.SpaceBetween)

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

              Button(this.isLoggingIn ? '登录中...' : '登录')
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

              Button(this.isLoggingIn ? '登录中...' : '登录')
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
        .backgroundColor(Color.Transparent)
      }
      .width('90%')
      .backgroundColor(Theme.SURFACE_1)
      .borderRadius(Theme.BORDER_RADIUS)
      .border({ width: Theme.BORDER_WIDTH, color: Theme.SURFACE_2, style: BorderStyle.Solid })
      .margin({ bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
    .alignItems(HorizontalAlign.Center)
  }
}