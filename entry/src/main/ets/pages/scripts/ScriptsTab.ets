import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct ScriptsTab {
  build() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Text('常用工具').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
        }.width('100%').padding({ top: 16, bottom: 24, left: 16, right: 16 })

        // Script 1
        Card() {
          Row() {
            Column() {
              Text('Restart Nginx').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 4 })
              Text('systemctl restart nginx').fontSize(14).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace')
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Button('Run')
              .fontSize(12)
              .fontColor(Theme.TEXT_PRIMARY)
              .backgroundColor(Theme.PRIMARY)
              .height(30)
          }.width('100%').alignItems(VerticalAlign.Center)
        }

        // Script 2
        Card() {
          Row() {
            Column() {
              Text('Clear Cache').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 4 })
              Text('rm -rf /var/cache/app/*').fontSize(14).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace')
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            
            Button('Run')
              .fontSize(12)
              .fontColor(Theme.TEXT_PRIMARY)
              .backgroundColor(Theme.PRIMARY)
              .height(30)
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
