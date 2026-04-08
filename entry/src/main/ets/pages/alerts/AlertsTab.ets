import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct AlertsTab {
  build() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Text('告警通知').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
        }.width('100%').padding({ top: 16, bottom: 24, left: 16, right: 16 })

        // Mock Alert Card 1 (Unresolved)
        Card() {
          Row() {
            Column() {
              Text('CPU Usage High').fontSize(16).fontColor(Theme.ERROR).fontWeight(FontWeight.Bold).margin({ bottom: 4 })
              Text('db-server-01 CPU > 90% for 5 mins').fontSize(14).fontColor(Theme.TEXT_SECONDARY).margin({ bottom: 8 })
              Text('10 mins ago').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Button('Acknowledge')
              .fontSize(12)
              .fontColor(Theme.TEXT_PRIMARY)
              .backgroundColor(Theme.SURFACE_2)
              .border({ width: 1, color: Theme.TEXT_SECONDARY, style: BorderStyle.Solid })
              .height(30)
          }.width('100%').alignItems(VerticalAlign.Center)
        }

        // Mock Alert Card 2 (Resolved)
        Card() {
          Row() {
            Column() {
              Text('Disk Space Warning').fontSize(16).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold).margin({ bottom: 4 })
              Text('cache-01 disk > 80%').fontSize(14).fontColor(Theme.TEXT_SECONDARY).margin({ bottom: 8 })
              Text('2 hours ago').fontSize(12).fontColor(Theme.TEXT_SECONDARY)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Text('Resolved').fontSize(12).fontColor(Theme.TERTIARY)
          }.width('100%').alignItems(VerticalAlign.Center)
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
