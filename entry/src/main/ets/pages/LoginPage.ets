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
  
  // 记住我
  @State rememberMe: boolean = false;

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

        resolve({ success: true, message: 'ok' });
      }, 1000);
    });
  }

  @Builder CloudProviderCard(name: string, iconText: string, isSelected: boolean) {
    Column() {
      Text(iconText).fontSize(28).margin({ bottom: 8 })
      Text(name)
        .fontSize(12)
        .fontColor(isSelected ? Theme.TEXT_PRIMARY : Theme.TEXT_SECONDARY)
        .fontWeight(FontWeight.Bold)
    }
    .width(80)
    .height(80)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Theme.SURFACE_0)
    .borderRadius(8)
    .border({ width: 2, color: isSelected ? Theme.PRIMARY : Theme.SURFACE_2, style: BorderStyle.Solid })
    .onClick(() => { this.selectedCloud = name; })
  }

  @Builder InputField(label: string, placeholder: string, textValue: string, isPassword: boolean = false, onChange: (val: string) => void) {
    Column() {
      Text(label)
        .fontSize(14)
        .fontColor(Theme.TEXT_SECONDARY)
        .width('100%')
        .margin({ bottom: 8 })
      
      TextInput({ placeholder: placeholder, text: textValue })
        .type(isPassword ? InputType.Password : InputType.Normal)
        .placeholderColor(Theme.TEXT_SECONDARY)
        .fontColor(Theme.TEXT_PRIMARY)
        .backgroundColor(Theme.SURFACE_0)
        .border({ width: 1, color: Theme.SURFACE_2, style: BorderStyle.Solid })
        .borderRadius(8)
        .height(52)
        .width('100%')
        .onChange(onChange)
    }
    .margin({ bottom: 20 })
  }

  build() {
    Scroll() {
      Column() {
        // Top Navigation Bar
        Row() {
          Row() {
            Text('←').fontColor(Theme.TEXT_SECONDARY).fontSize(20).margin({ right: 8 })
            Text('Back').fontColor(Theme.TEXT_SECONDARY).fontSize(16)
          }
          
          Row() {
            Text('>_').fontColor(Theme.PRIMARY).fontSize(16).fontWeight(FontWeight.Bold).margin({ right: 8 })
              .backgroundColor(Theme.SURFACE_2).padding(4).borderRadius(4)
            Text('HarmonyOps').fontColor(Theme.TEXT_PRIMARY).fontSize(18).fontWeight(FontWeight.Bold)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 20, bottom: 40 })

        // Hero Text
        Column() {
          Text('Welcome Back')
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor(Theme.TEXT_PRIMARY)
            .margin({ bottom: 12 })
            .width('100%')
            .textAlign(TextAlign.Center)
          Text('Log in to your tenant account')
            .fontSize(16)
            .fontColor(Theme.TEXT_SECONDARY)
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .margin({ bottom: 40 })

        // Custom Tabs (Tenant Login / Account Login)
        Row() {
          Column() {
            Text('Tenant Login (租户)')
              .fontColor(this.currentTabIndex === 0 ? Theme.TEXT_PRIMARY : Theme.TEXT_SECONDARY)
              .fontSize(16)
              .fontWeight(this.currentTabIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
              .margin({ bottom: 12 })
            Divider()
              .color(this.currentTabIndex === 0 ? Theme.PRIMARY : Theme.SURFACE_2)
              .strokeWidth(this.currentTabIndex === 0 ? 3 : 1)
          }
          .layoutWeight(1)
          .onClick(() => this.currentTabIndex = 0)

          Column() {
            Text('Account Login (账号)')
              .fontColor(this.currentTabIndex === 1 ? Theme.TEXT_PRIMARY : Theme.TEXT_SECONDARY)
              .fontSize(16)
              .fontWeight(this.currentTabIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
              .margin({ bottom: 12 })
            Divider()
              .color(this.currentTabIndex === 1 ? Theme.PRIMARY : Theme.SURFACE_2)
              .strokeWidth(this.currentTabIndex === 1 ? 3 : 1)
          }
          .layoutWeight(1)
          .onClick(() => this.currentTabIndex = 1)
        }
        .width('100%')
        .margin({ bottom: 32 })

        // Cloud Provider Selector
        Column() {
          Text('SELECT CLOUD PROVIDER')
            .fontSize(12)
            .fontColor(Theme.TEXT_SECONDARY)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .margin({ bottom: 16 })
          
          Row() {
            this.CloudProviderCard('华为云', '☁️', this.selectedCloud === '华为云')
            Blank().width(16)
            this.CloudProviderCard('腾讯云', '☁️', this.selectedCloud === '腾讯云')
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
        .margin({ bottom: 32 })

        // Forms
        if (this.currentTabIndex === 0) {
          this.InputField('Main Account ID (主账号)', 'e.g. OBS-8829-01', this.masterAccount, false, (val) => { this.masterAccount = val })
          this.InputField('Sub-account / Username (子账号)', 'admin_devops', this.subAccount, false, (val) => { this.subAccount = val })
          this.InputField('Password (密码)', '', this.tenantPassword, true, (val) => { this.tenantPassword = val })
        } else {
          this.InputField('Account (账号)', 'Enter your account', this.account, false, (val) => { this.account = val })
          this.InputField('Password (密码)', '', this.accountPassword, true, (val) => { this.accountPassword = val })
        }

        // Remember Me & Forgot Password
        Row() {
          Row() {
            Checkbox({ name: 'remember', group: 'login' })
              .select(this.rememberMe)
              .selectedColor(Theme.PRIMARY)
              .onChange((value: boolean) => { this.rememberMe = value })
              .width(20).height(20).margin({ right: 8 })
            Text('Remember tenant')
              .fontSize(14)
              .fontColor(Theme.TEXT_SECONDARY)
          }
          
          Text('Forgot password?')
            .fontSize(14)
            .fontColor(Theme.PRIMARY)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 32 })

        // Submit Button
        Button() {
          Row() {
            Text('→] ').fontColor('#000000').fontSize(18).fontWeight(FontWeight.Bold).margin({ right: 8 })
            Text(this.isLoggingIn ? 'Signing in...' : 'Sign in to Console')
              .fontColor('#000000')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
        }
        .type(ButtonType.Normal)
        .borderRadius(8)
        .width('100%')
        .height(52)
        .backgroundColor(Theme.PRIMARY)
        .onClick(() => this.handleLogin())

        // Footer
        Row() {
          Text('🛡 SECURE INFRASTRUCTURE ENVIRONMENT')
            .fontSize(10)
            .fontColor(Theme.TEXT_SECONDARY)
            .letterSpacing(1)
            .fontWeight(FontWeight.Bold)
        }
        .margin({ top: 40, bottom: 40 })
        .width('100%')
        .justifyContent(FlexAlign.Center)

      }
      .padding({ left: 24, right: 24 })
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
  }
}