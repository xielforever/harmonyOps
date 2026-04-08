import { Theme } from '../theme/Theme';
import { DashboardTab } from './dashboard/DashboardTab';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? Theme.PRIMARY : Theme.TEXT_SECONDARY)
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        DashboardTab()
      }.tabBar(this.TabBuilder('概览', 0))

      TabContent() {
        Column() {
          Text('Terminal Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('终端', 1))

      TabContent() {
        Column() {
          Text('Alerts Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('告警', 2))

      TabContent() {
        Column() {
          Text('Scripts Placeholder').fontColor(Theme.TEXT_PRIMARY)
        }.width('100%').height('100%').backgroundColor(Theme.BACKGROUND)
      }.tabBar(this.TabBuilder('工具', 3))
    }
    .scrollable(false)
    .backgroundColor(Theme.SURFACE_0)
    .barBackgroundColor(Theme.SURFACE_1)
    .barHeight(50)
  }
}