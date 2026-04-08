import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct DashboardTab {
  build() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Text('概览').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
        }.width('100%').padding({ top: 16, bottom: 24, left: 16, right: 16 })

        // Stats Card
        Card() {
          Column() {
            Text('服务器健康度').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 12 })
            Row() {
              Column() {
                Text('总数').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
                Text('12').fontSize(28).fontColor(Theme.PRIMARY).fontWeight(FontWeight.Bold)
              }.alignItems(HorizontalAlign.Start).width('50%')
              Column() {
                Text('异常').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
                Text('0').fontSize(28).fontColor(Theme.TERTIARY).fontWeight(FontWeight.Bold)
              }.alignItems(HorizontalAlign.Start).width('50%')
            }.width('100%')
          }.alignItems(HorizontalAlign.Start).width('100%')
        }

        // Mock Server Card
        Card() {
          Column() {
            Text('web-server-01').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 8 })
            Text('CPU: 45%').fontSize(14).fontColor(Theme.TEXT_SECONDARY)
            Progress({ value: 45, total: 100, type: ProgressType.Linear })
              .color(Theme.PRIMARY).backgroundColor(Theme.SURFACE_2).margin({ top: 4, bottom: 8 })
            
            Text('RAM: 2.1GB / 4GB').fontSize(14).fontColor(Theme.TEXT_SECONDARY)
            Progress({ value: 52, total: 100, type: ProgressType.Linear })
              .color(Theme.PRIMARY).backgroundColor(Theme.SURFACE_2).margin({ top: 4 })
          }.alignItems(HorizontalAlign.Start).width('100%')
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
  }
}
