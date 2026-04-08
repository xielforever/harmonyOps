import { Theme } from '../../theme/Theme';
import { Card } from '../../components/Card';

@Component
export struct TerminalTab {
  build() {
    Column() {
      // Header
      Row() {
        Text('服务器终端').fontSize(24).fontColor(Theme.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
      }.width('100%').padding({ top: 16, bottom: 16, left: 16, right: 16 })

      // Server List
      Scroll() {
        Column() {
          Card() {
            Row() {
              Column() {
                Text('web-server-01').fontSize(16).fontColor(Theme.TEXT_PRIMARY).margin({ bottom: 4 })
                Text('192.168.1.101').fontSize(14).fontColor(Theme.TEXT_SECONDARY)
              }.alignItems(HorizontalAlign.Start).layoutWeight(1)
              
              Button('Connect')
                .fontSize(12)
                .fontColor(Theme.TEXT_PRIMARY)
                .backgroundColor(Theme.SURFACE_2)
                .border({ width: 1, color: Theme.PRIMARY, style: BorderStyle.Solid })
                .height(30)
            }.width('100%').alignItems(VerticalAlign.Center)
          }

          // Mock Terminal Output Area
          Column() {
            Text('root@web-server-01:~# tail -f /var/log/syslog')
              .fontSize(12).fontColor(Theme.TEXT_PRIMARY).fontFamily('monospace').width('100%').margin({ bottom: 4 })
            Text('Apr  8 12:00:01 web-server CRON[1234]: pam_unix(cron:session): session opened for user root')
              .fontSize(12).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace').width('100%').margin({ bottom: 4 })
            Text('Apr  8 12:05:01 web-server systemd[1]: Started Clean php session files.')
              .fontSize(12).fontColor(Theme.TEXT_SECONDARY).fontFamily('monospace').width('100%')
          }
          .width('100%')
          .height(300)
          .backgroundColor('#000000') // Darker than background for terminal feel
          .borderRadius(Theme.BORDER_RADIUS)
          .padding(12)
          .margin({ top: 16 })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Theme.BACKGROUND)
  }
}
