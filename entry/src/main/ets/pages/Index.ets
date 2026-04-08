import router from '@ohos.router';
import { Theme } from '../theme/Theme';

@Entry
@Component
struct Index {
  onPageShow() {
    router.replaceUrl({ url: 'pages/LoginPage' });
  }

  build() {
    Column() {
      Text('Loading...')
        .fontColor(Theme.TEXT_PRIMARY)
        .fontSize(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
    .justifyContent(FlexAlign.Center)
  }
}