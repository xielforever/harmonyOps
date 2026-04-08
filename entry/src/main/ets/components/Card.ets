import { Theme } from '../theme/Theme';

@Component
export struct Card {
  @BuilderParam content: () => void;

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Theme.SURFACE_1)
    .borderRadius(Theme.BORDER_RADIUS)
    .border({ width: Theme.BORDER_WIDTH, color: Theme.SURFACE_2, style: BorderStyle.Solid })
    .margin({ bottom: 12 })
  }
}
